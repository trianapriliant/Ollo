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
    String text = input.toLowerCase();

    // 1. Keyword-based Detection (Priority: Total, Sub Total, etc.)
    final totalKeywords = ['total belanja', 'grand total', 'sub total', 'total', 'jumlah', 'tagihan', 'amount'];
    
    // Split into lines to checking per-line context
    final lines = text.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].toLowerCase();
      
      for (final keyword in totalKeywords) {
        if (line.contains(keyword)) {
          // Found a "Total" line. Extract number from this line.
          // Allow internal spaces after dots/commas (e.g. "42, 684")
          final numRegex = RegExp(r'(\d+(?:[.,]\s*\d+)*)'); 
           
          // Remove the keyword itself
          String cleanLine = line.replaceAll(keyword, '');
          
          final matches = numRegex.allMatches(cleanLine);
          double maxValOnLine = 0;
          
          for (final m in matches) {
             String matchStr = m.group(1)!;
             // Remove spaces first (e.g. "42, 684" -> "42,684")
             String noSpace = matchStr.replaceAll(' ', '');
             
             String cleanNum = _cleanNumberString(noSpace);
             double? val = double.tryParse(cleanNum);
             if (val != null && val > maxValOnLine) maxValOnLine = val;
          }
          
          if (maxValOnLine > 0) return maxValOnLine;

          // --- LOOKAHEAD LOGIC ---
          if (i + 1 < lines.length) {
             String nextLine = lines[i+1];
             final matchesNext = numRegex.allMatches(nextLine);
             double maxValNext = 0;
              for (final m in matchesNext) {
                 String matchStr = m.group(1)!;
                 String noSpace = matchStr.replaceAll(' ', '');
                 
                 String cleanNum = _cleanNumberString(noSpace);
                 double? val = double.tryParse(cleanNum);
                 if (val != null && val > maxValNext) maxValNext = val;
              }
              if (maxValNext > 0) return maxValNext;
          }
        }
      }
    }

    // 2. Fallback
    final kRegex = RegExp(r'(\d+(?:[.,]\d+)?)\s*(k|rb|ribu)', caseSensitive: false);
    final jtRegex = RegExp(r'(\d+(?:[.,]\d+)?)\s*(jt|juta)', caseSensitive: false);
    // Be consistent with above regex
    final numRegex = RegExp(r'(\d+(?:[.,]\s*\d+)*)');
    
    // ... [Rest of fallback logic remains, just update regex usage]
    
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

    // Check for plain numbers (Largest in text maybe? Or first?)
    final numMatches = numRegex.allMatches(text);
    double maxVal = 0;
    
    for (final m in numMatches) {
        String matchStr = m.group(1)!;
        String noSpace = matchStr.replaceAll(' ', '');
        String cleanNum = _cleanNumberString(noSpace);
        double? val = double.tryParse(cleanNum);
        if (val != null && val > maxVal) maxVal = val;
    }

    return maxVal;
  }

  String _cleanNumberString(String input) {
     String cleanNum = input;
     // ID Format Logic Repeat
     if (cleanNum.contains('.') && cleanNum.contains(',')) {
         // Both present: 10.000,00 -> 10000.00
         cleanNum = cleanNum.replaceAll('.', '').replaceAll(',', '.');
       } else if (cleanNum.contains('.')) {
         // Dot only: 10.000 -> 10000
         // If 3 decimals exactly? Likely thousand separator.
         if (cleanNum.split('.').last.length == 3) {
            cleanNum = cleanNum.replaceAll('.', '');
         } 
       } else if (cleanNum.contains(',')) {
          // Comma only: 10,000 -> 10000 OR 10,5 -> 10.5
          // If 3 digits exactly after comma? Likely thousand separator (EN style or ID typoes)
          // User case: "42, 684" -> "42,684" -> Should be 42684
          if (cleanNum.split(',').last.length == 3) {
             cleanNum = cleanNum.replaceAll(',', '');
          } else {
             cleanNum = cleanNum.replaceAll(',', '.');
          }
       }
     return cleanNum;
  }

  ({Category? category, SubCategory? subCategory, String? keyword}) _extractCategory(String input, List<Category> categories) {
    String text = input.toLowerCase();
    
    // Map to track score: Category -> Score
    Map<Category, int> categoryScores = {};
    // Map to track subcat score: SubCategory -> Score
    Map<SubCategory, int> subCategoryScores = {};
    
    // Also track the "best matching keyword" for each category to use as Title
    Map<Category, String> bestKwForCat = {};
    Map<SubCategory, String> bestKwForSub = {};

    // 1. Scan ALL patterns and accumulate scores
    for (var entry in defaultCategoryPatterns.entries) {
      String categoryNameKey = entry.key;
      CategoryPattern pattern = entry.value;

      // Find the actual Category object from DB
      Category? dbCat;
      try {
           dbCat = categories.firstWhere(
             (c) => c.name.toLowerCase().contains(categoryNameKey.toLowerCase()) || 
                    categoryNameKey.toLowerCase().contains(c.name.toLowerCase())
           );
      } catch (e) { continue; } // DB doesn't have this category, skip
      
      // A. Check SubCategories
      for (var subEntry in pattern.subCategoryKeywords.entries) {
         String subCatNameKey = subEntry.key;
         List<String> subKeywords = subEntry.value;
         
         // Find actual SubCategory object
         SubCategory? dbSub;
         if (dbCat.subCategories != null) {
            try {
               dbSub = dbCat.subCategories!.firstWhere(
                 (s) => s.name?.toLowerCase().contains(subCatNameKey.toLowerCase()) == true ||
                        subCatNameKey.toLowerCase().contains(s.name?.toLowerCase() ?? '')
               );
            } catch (e) {
               // Subcat not in DB, but we still count the score for the Main Category
            }
         }

         for (var keyword in subKeywords) {
            if (text.contains(keyword.toLowerCase())) {
               // Increment Scores
               categoryScores[dbCat] = (categoryScores[dbCat] ?? 0) + 1;
               bestKwForCat[dbCat] = keyword; // Store last found keyword
               
               if (dbSub != null) {
                  subCategoryScores[dbSub] = (subCategoryScores[dbSub] ?? 0) + 1;
                  bestKwForSub[dbSub] = keyword;
               }
            }
         }
      } // end sub loop
      
      // B. Check Main Keywords
      for (var keyword in pattern.mainKeywords) {
         if (text.contains(keyword.toLowerCase())) {
             categoryScores[dbCat] = (categoryScores[dbCat] ?? 0) + 1;
             bestKwForCat[dbCat] = keyword;
         }
      }
    }

    // 2. Find Highest Scoring Category
    if (categoryScores.isEmpty) {
        // Fallback: Direct Name Match
        for (var cat in categories) {
          if (text.contains(cat.name.toLowerCase())) {
            return (category: cat, subCategory: null, keyword: cat.name);
          }
        }
        return (category: null, subCategory: null, keyword: null);
    }

    // Sort by score descending
    var sortedCats = categoryScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    Category winnerCat = sortedCats.first.key;
    
    // Find Highest Scoring SubCategory belonging to Winner
    SubCategory? winnerSub;
    int maxSubScore = 0;
    
    // We only care about subcategories OF the winning category
    // (Or should we allow global subcell winner? Usually safer to follow hierarchy)
    if (winnerCat.subCategories != null) {
       for (var sub in winnerCat.subCategories!) {
          if (subCategoryScores.containsKey(sub)) {
             int s = subCategoryScores[sub]!;
             if (s > maxSubScore) {
                maxSubScore = s;
                winnerSub = sub;
             }
          }
       }
    }

    // Keyword logic: Try to use SubCat keyword if available, else Cat keyword
    String? finalKeyword = winnerSub != null ? bestKwForSub[winnerSub] : bestKwForCat[winnerCat];

    return (category: winnerCat, subCategory: winnerSub, keyword: finalKeyword);
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
