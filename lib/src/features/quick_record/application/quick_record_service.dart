import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction.dart';
import '../../categories/domain/category.dart';
import '../data/quick_record_repository.dart';
import '../domain/category_patterns.dart';

class QuickRecordService {
  final QuickRecordRepository _repository;

  QuickRecordService(this._repository);

  /// Parses a natural language string into a potential Transaction.
  Future<({Transaction transaction, String? categoryName, String? subCategoryName})> parseTransaction(String input) async {
    final categories = await _repository.getAllCategories();
    
    // 1. Extract Amount
    double amount = _extractAmount(input);
    
    // 2. Extract Category & matched keyword
    final result = _extractCategory(input, categories);
    Category? matchedCategory = result.category;
    SubCategory? matchedSubCategory = result.subCategory;
    String matchedKeyword = result.keyword ?? '';
    
    // 3. Determine Title
    String title = matchedKeyword.isNotEmpty 
        ? matchedKeyword[0].toUpperCase() + matchedKeyword.substring(1) 
        : (matchedSubCategory?.name ?? matchedCategory?.name ?? 'Unknown Transaction');

    // 4. Determine Type
    TransactionType type = _determineType(input);
    
    // Override type if matched category has a specific type preference
    if (matchedCategory != null) {
       if (matchedCategory.type == CategoryType.income) {
          type = TransactionType.income;
       } else if (matchedCategory.type == CategoryType.expense) {
          type = TransactionType.expense;
       }
    }

    // 5. Note
    String note = input;

    final transaction = Transaction.create(
      title: title,
      amount: amount,
      date: DateTime.now(),
      type: type,
      categoryId: matchedCategory?.externalId ?? matchedCategory?.id.toString(),
      subCategoryId: matchedSubCategory?.id,
      subCategoryName: matchedSubCategory?.name,
      subCategoryIcon: matchedSubCategory?.iconPath,
      note: note,
    );

    return (
      transaction: transaction, 
      categoryName: matchedCategory?.name, 
      subCategoryName: matchedSubCategory?.name
    );
  }

  double _extractAmount(String input) {
    // Regex for "50k", "50rb", "10jt", "50.000", "50000"
    final kRegex = RegExp(r'(\d+(?:[.,]\d+)?)\s*(k|rb|ribu)', caseSensitive: false);
    final jtRegex = RegExp(r'(\d+(?:[.,]\d+)?)\s*(jt|juta)', caseSensitive: false);
    final numRegex = RegExp(r'(\d+(?:[.]\d+)*(?:,\d+)?)');

    String text = input.toLowerCase();
    
    // Check for Million (jt)
    final jtMatch = jtRegex.firstMatch(text);
    if (jtMatch != null) {
      String clean = jtMatch.group(1)!.replaceAll(',', '.');
      double val = double.tryParse(clean) ?? 0;
      return val * 1000000;
    }

    // Check for Thousand (k/rb)
    final kMatch = kRegex.firstMatch(text);
    if (kMatch != null) {
      String clean = kMatch.group(1)!.replaceAll(',', '.');
      double val = double.tryParse(clean) ?? 0;
      return val * 1000;
    }

    // Check for plain numbers
    final numMatches = numRegex.allMatches(text);
    for (final m in numMatches) {
        String matchStr = m.group(1)!;
        String cleanNum = matchStr.replaceAll('.', '').replaceAll(',', '.');
        double? val = double.tryParse(cleanNum);
        
        if (val != null && val > 0) {
            return val;
        }
    }

    return 0;
  }

  ({Category? category, SubCategory? subCategory, String? keyword}) _extractCategory(String input, List<Category> categories) {
    String text = input.toLowerCase();
    
    // 1. Direct Pattern Matching (Priority)
    for (var entry in defaultCategoryPatterns.entries) {
      String categoryNameKey = entry.key;
      CategoryPattern pattern = entry.value;

      // A. Check SubCategories first (Specific)
      for (var subEntry in pattern.subCategoryKeywords.entries) {
        String subCatNameKey = subEntry.key;
        List<String> subKeywords = subEntry.value;

        for (var keyword in subKeywords) {
           if (text.contains(keyword.toLowerCase())) {
             // Found SubCategory Keyword!
             // 1. Find Main Category
             try {
                final cat = categories.firstWhere(
                  (c) => c.name.toLowerCase().contains(categoryNameKey.toLowerCase()) || 
                         categoryNameKey.toLowerCase().contains(c.name.toLowerCase()),
                  orElse: () => throw 'CategoryNotFound'
                );
                
                // 2. Find SubCategory within it
                SubCategory? subCat;
                if (cat.subCategories != null) {
                   try {
                     subCat = cat.subCategories!.firstWhere(
                       (s) => s.name?.toLowerCase().contains(subCatNameKey.toLowerCase()) == true || 
                              subCatNameKey.toLowerCase().contains(s.name?.toLowerCase() ?? ''),
                        orElse: () => throw 'SubNotFound'
                     );
                   } catch(e) {
                     // SubCategory not in DB? Just return Main Category + Keyword
                   }
                }

                return (category: cat, subCategory: subCat, keyword: keyword);

             } catch (e) {
               // Main Category not found in DB? Skip.
             }
           }
        }
      }
      
      // B. Check Main Keywords (Generic)
      for (var keyword in pattern.mainKeywords) {
        if (text.contains(keyword.toLowerCase())) {
           try {
                final cat = categories.firstWhere(
                  (c) => c.name.toLowerCase().contains(categoryNameKey.toLowerCase()) || 
                         categoryNameKey.toLowerCase().contains(c.name.toLowerCase()),
                  orElse: () => throw 'NotFound'
                );
                return (category: cat, subCategory: null, keyword: keyword);
            } catch (e) {
            }
        }
      }
    }

    // 2. Direct Name Match (Fallback) - Simple contains check on DB names
    for (var cat in categories) {
      if (text.contains(cat.name.toLowerCase())) {
        return (category: cat, subCategory: null, keyword: cat.name);
      }
      // Check its subcategories
      if (cat.subCategories != null) {
        for (var sub in cat.subCategories!) {
             if (sub.name != null && text.contains(sub.name!.toLowerCase())) {
                 return (category: cat, subCategory: sub, keyword: sub.name);
             }
        }
      }
    }
    
    return (category: null, subCategory: null, keyword: null);
  }

  TransactionType _determineType(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('income') || lower.contains('gaji') || lower.contains('masuk') || lower.contains('dapat')) {
      return TransactionType.income;
    }
    return TransactionType.expense;
  }
}

final quickRecordServiceProvider = Provider<QuickRecordService>((ref) {
  final repo = ref.watch(quickRecordRepositoryProvider);
  return QuickRecordService(repo);
});
