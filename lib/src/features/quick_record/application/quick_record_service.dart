import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/domain/wallet.dart';
import '../../categories/domain/category.dart';
import '../data/quick_record_repository.dart';
import '../domain/patterns/pattern_manager.dart';
import '../domain/patterns/pattern_base.dart';

/// Result class for parsed transaction - supports both regular and transfer transactions
class ParsedTransactionResult {
  final Transaction transaction;
  final String? categoryName;
  final String? subCategoryName;
  final String? walletName;
  
  // Transfer-specific fields
  final bool isTransfer;
  final Wallet? sourceWallet;
  final Wallet? destinationWallet;
  final double transferFee;
  
  ParsedTransactionResult({
    required this.transaction,
    this.categoryName,
    this.subCategoryName,
    this.walletName,
    this.isTransfer = false,
    this.sourceWallet,
    this.destinationWallet,
    this.transferFee = 0,
  });
}

class QuickRecordService {
  final QuickRecordRepository _repository;

  QuickRecordService(this._repository);

  // Transfer detection keywords - VERY SPECIFIC to avoid false positives
  static const _transferKeywords = [
    'transfer', 'tf ', 'kirim uang', 'kirim ke', 'pindah dana', 'pindahkan',
  ];
  
  // Pattern: must have BOTH "dari" AND "ke" for transfer (prevents false positive)
  static final _transferPatternId = RegExp(
    r'(?:transfer|tf|kirim|pindah)\s+.*(?:dari|from)\s+.+\s+(?:ke|to)\s+',
    caseSensitive: false,
  );
  
  static final _transferPatternEn = RegExp(
    r'(?:transfer|send|move)\s+.*(?:from)\s+.+\s+(?:to)\s+',
    caseSensitive: false,
  );

  /// Parses a natural language string into a potential Transaction.
  /// PRIORITY: Transfer detection happens FIRST to prevent misclassification.
  Future<ParsedTransactionResult> parseTransaction(String input, {String languageCode = 'id_ID'}) async {
    final wallets = await _repository.getAllWallets();
    final categories = await _repository.getAllCategories();
    
    // ============================================
    // STEP 0: TRANSFER DETECTION (HIGHEST PRIORITY)
    // ============================================
    // Transfer MUST be detected first, before any expense/income logic
    // A valid transfer requires: transfer keyword + source wallet + destination wallet
    if (_isTransferInput(input)) {
      final transferResult = _parseTransfer(input, wallets);
      if (transferResult != null && 
          transferResult.sourceWallet != null && 
          transferResult.destinationWallet != null) {
        // Successfully parsed as transfer - return immediately
        // This prevents any chance of being treated as expense/income
        final transaction = Transaction.create(
          title: 'Transfer',
          amount: transferResult.amount,
          date: _extractDate(input),
          type: TransactionType.transfer,
          walletId: transferResult.sourceWallet!.externalId ?? transferResult.sourceWallet!.id.toString(),
          note: input,
        );
        
        return ParsedTransactionResult(
          transaction: transaction,
          isTransfer: true,
          sourceWallet: transferResult.sourceWallet,
          destinationWallet: transferResult.destinationWallet,
          transferFee: transferResult.adminFee,
          walletName: transferResult.sourceWallet!.name,
        );
      }
    }
    
    // ============================================
    // REGULAR TRANSACTION PARSING (Expense/Income)
    // ============================================
    // Only reaches here if NOT a valid transfer
    
    // 1. Extract Amount
    double amount = _extractAmount(input);
    
    // 2. Extract Category & matched keyword
    final result = _extractCategory(input, categories, languageCode);
    Category? matchedCategory = result.category;
    SubCategory? matchedSubCategory = result.subCategory;
    String matchedKeyword = result.keyword ?? '';
    
    // 3. Extract Wallet
    Wallet? matchedWallet = _extractWallet(input, wallets);

    // 4. Extract Date
    DateTime date = _extractDate(input);

    // 5. Determine Title (Cleaned)
    String title = _cleanTitle(
      input: input,
      matchedKeyword: matchedKeyword,
      categoryName: matchedSubCategory?.name ?? matchedCategory?.name,
      walletName: matchedWallet?.name,
      amount: amount,
    );

    // 6. Determine Type
    TransactionType type = _determineType(input);
    
    // Override type if matched category has a specific type preference
    if (matchedCategory != null) {
       if (matchedCategory.type == CategoryType.income) {
          type = TransactionType.income;
       } else if (matchedCategory.type == CategoryType.expense) {
          type = TransactionType.expense;
       }
    }

    // 7. Note (Original input)
    String note = input;

    final transaction = Transaction.create(
      title: title,
      amount: amount,
      date: date,
      type: type,
      categoryId: matchedCategory?.externalId ?? matchedCategory?.id.toString(),
      subCategoryId: matchedSubCategory?.id,
      subCategoryName: matchedSubCategory?.name,
      subCategoryIcon: matchedSubCategory?.iconPath,
      walletId: matchedWallet?.externalId ?? matchedWallet?.id.toString() ?? '1',
      note: note,
    );

    return ParsedTransactionResult(
      transaction: transaction, 
      categoryName: matchedCategory?.name, 
      subCategoryName: matchedSubCategory?.name,
      walletName: matchedWallet?.name,
      isTransfer: false,
    );
  }
  
  /// Determines if input is a transfer command
  /// Uses STRICT rules to prevent false positives
  bool _isTransferInput(String input) {
    final lower = input.toLowerCase();
    
    // Method 1: Check for transfer keyword + dari/ke pattern (Indonesian)
    if (_transferPatternId.hasMatch(lower)) return true;
    
    // Method 2: Check for transfer keyword + from/to pattern (English)
    if (_transferPatternEn.hasMatch(lower)) return true;
    
    // Method 3: Check explicit transfer keywords with wallet indicators
    for (final keyword in _transferKeywords) {
      if (lower.contains(keyword)) {
        // Must also contain source AND destination indicators
        bool hasSource = lower.contains('dari ') || lower.contains('from ');
        bool hasDest = lower.contains(' ke ') || lower.contains(' to ');
        if (hasSource && hasDest) return true;
      }
    }
    
    return false;
  }
  
  /// Parses transfer details from input
  /// Returns null if parsing fails (will fallback to regular transaction)
  ({double amount, Wallet? sourceWallet, Wallet? destinationWallet, double adminFee})? 
  _parseTransfer(String input, List<Wallet> wallets) {
    final lower = input.toLowerCase();
    
    // 1. Extract amount (same logic as regular)
    final amount = _extractAmount(input);
    if (amount <= 0) return null;
    
    // 2. Extract source wallet: text after "dari/from" until "ke/to"
    Wallet? sourceWallet;
    final sourceRegex = RegExp(r'(?:dari|from)\s+(.+?)\s+(?:ke|to)\s', caseSensitive: false);
    final sourceMatch = sourceRegex.firstMatch(lower);
    if (sourceMatch != null) {
      final sourceText = sourceMatch.group(1)?.trim();
      sourceWallet = _matchWalletByText(sourceText, wallets);
    }
    
    // 3. Extract destination wallet: text after "ke/to" until end or "dengan/admin/fee"
    Wallet? destWallet;
    final destRegex = RegExp(r'(?:ke|to)\s+(.+?)(?:\s+(?:dengan|admin|fee|biaya)|$)', caseSensitive: false);
    final destMatch = destRegex.firstMatch(lower);
    if (destMatch != null) {
      final destText = destMatch.group(1)?.trim();
      destWallet = _matchWalletByText(destText, wallets);
    }
    
    // 4. Extract admin fee (optional)
    double adminFee = 0;
    final adminRegex = RegExp(r'(?:admin|fee|biaya\s*admin?)\s*(?:rp\.?\s*)?(\d+(?:[.,]\d+)*)\s*(rb|k|ribu)?', caseSensitive: false);
    final adminMatch = adminRegex.firstMatch(lower);
    if (adminMatch != null) {
      String numStr = adminMatch.group(1)!;
      String? suffix = adminMatch.group(2);
      
      numStr = _cleanNumberString(numStr);
      adminFee = double.tryParse(numStr) ?? 0;
      
      // Apply multiplier for rb/k/ribu
      if (suffix != null && (suffix == 'rb' || suffix == 'k' || suffix == 'ribu')) {
        adminFee *= 1000;
      }
    }
    
    return (
      amount: amount,
      sourceWallet: sourceWallet,
      destinationWallet: destWallet,
      adminFee: adminFee,
    );
  }
  
  /// Matches wallet by text using fuzzy matching
  Wallet? _matchWalletByText(String? text, List<Wallet> wallets) {
    if (text == null || text.isEmpty) return null;
    
    final searchText = text.toLowerCase().trim();
    
    // 1. Exact match
    for (var wallet in wallets) {
      if (wallet.name.toLowerCase() == searchText) {
        return wallet;
      }
    }
    
    // 2. Contains match (wallet name contains search text)
    for (var wallet in wallets) {
      if (wallet.name.toLowerCase().contains(searchText)) {
        return wallet;
      }
    }
    
    // 3. Reverse contains (search text contains wallet name)
    for (var wallet in wallets) {
      if (searchText.contains(wallet.name.toLowerCase())) {
        return wallet;
      }
    }
    
    // 4. Fuzzy word match - check if distinctive word matches
    final commonWords = ['bank', 'wallet', 'account', 'dompet', 'rekening', 'cash', 'tunai'];
    for (var wallet in wallets) {
      List<String> walletWords = wallet.name.toLowerCase().split(' ');
      for (String word in walletWords) {
        if (word.length < 3 || commonWords.contains(word)) continue;
        if (searchText.contains(word)) {
          return wallet;
        }
      }
    }
    
    return null;
  }


  Wallet? _extractWallet(String input, List<Wallet> wallets) {
    String text = input.toLowerCase();
    
    // 1. Strict Match (Full Name)
    for (var wallet in wallets) {
      if (text.contains(wallet.name.toLowerCase())) {
        return wallet;
      }
    }

    // 2. Partial Word Match (Smart Fuzzy)
    // Example: "Bank Mandiri" -> user says "Mandiri" -> Match!
    // We split wallet name into words, and check if any *distinctive* word exists in text.
    
    final commonWords = ['bank', 'wallet', 'account', 'dompet', 'rekening', 'the', 'my', 'cash', 'tunai'];

    for (var wallet in wallets) {
       List<String> walletWords = wallet.name.toLowerCase().split(' ');
       for (String word in walletWords) {
          // Filter out too short or common words to avoid false positives
          if (word.length < 3 || commonWords.contains(word)) continue;
          
          if (text.contains(word)) {
             return wallet;
          }
       }
    }

    return null;
  }

  DateTime _extractDate(String input) {
    String text = input.toLowerCase();
    final now = DateTime.now();
    
    if (text.contains('kemarin') || text.contains('yesterday')) {
      return now.subtract(const Duration(days: 1));
    } else if (text.contains('besok') || text.contains('tomorrow')) {
      return now.add(const Duration(days: 1));
    } else if (text.contains('lusa')) { // The day after tomorrow
       return now.add(const Duration(days: 2));
    }
    // Default to today
    return now;
  }

  String _cleanTitle({
    required String input,
    required String matchedKeyword,
    String? categoryName,
    String? walletName,
    double? amount,
  }) {
    String text = input.toLowerCase();

    // 1. Remove Amounts
    // Regex to match "15k", "15.000", "Rp 15000", "20rb"
    // Also matched "total 15000" if we want to be aggressive, but removing numbers is usually safe.
    // \d+([.,]\d+)*\s*(rb|k|jt|juta|ribu)?
    final amountRegex = RegExp(r'(rp\.?|rp)?\s*\d+([.,]\d+)*\s*(rb|k|jt|juta|ribu)?', caseSensitive: false);
    text = text.replaceAll(amountRegex, ' '); // Replace with space

    // 2. Remove Wallet Name if present
    if (walletName != null) {
      // Try to remove full wallet name
      text = text.replaceAll(walletName.toLowerCase(), ' ');
      
      // Also try to remove individual logical words of the wallet (e.g. "Mandiri" from "Bank Mandiri")
      // to avoid "Bayar Pakai [Mandiri]" leaving nothing.
      final commonWalletWords = ['bank', 'wallet', 'account', 'dompet', 'rekening'];
      final parts = walletName.toLowerCase().split(' ');
      for (var p in parts) {
        if (!commonWalletWords.contains(p) && p.length > 2) {
          text = text.replaceAll(p, ' ');
        }
      }
    }

    // 3. Remove Date Keywords
    final dateKeywords = ['kemarin', 'yesterday', 'besok', 'tomorrow', 'lusa', 'hari ini', 'today'];
    for (var d in dateKeywords) {
      text = text.replaceAll(d, ' ');
    }

    // 4. Remove Stop Words / Verbs
    // Expanded list for better cleanup
    final stopWords = [
      'beli', 'purchase', 'bayar', 'pay', 
      'di', 'ke', 'via', 'pakai', 'pake', 'menggunakan', 'untuk', 'buat', 'sama', 'dan', 'with', 'and',
      'total', 'sub total', 'jumlah', 'harga', 'price', 'rp', 'idr'
    ];
    
    // Sort stopWords by length descending to remove longest matches first (e.g. "sub total" before "total")
    stopWords.sort((a, b) => b.length.compareTo(a.length));

    for (var w in stopWords) {
      // Use word boundary to avoid removing parts of words (e.g. "di" inside "dia")
      // But for simple indo logic, replaceAll ' word ' is safer than regex boundary sometimes due to punctuation.
      // Let's use simple replace matches closely.
      // Better: RegExp(r'\bword\b')
      text = text.replaceAll(RegExp(r'\b' + RegExp.escape(w) + r'\b'), '');
    }

    // 5. Remove Punctuation and Extra Spaces
    text = text.replaceAll(RegExp(r'[^\w\s]'), ' '); // Replace punct with space
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim(); // Collapse spaces

    // 6. Final Decision
    if (text.length > 1) {
       // Serialize to Title Case
       return text.split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : '').join(' ');
    }

    // Fallback logic
    if (matchedKeyword.isNotEmpty) {
       return matchedKeyword[0].toUpperCase() + matchedKeyword.substring(1);
    }
    
    return categoryName ?? 'Unknown Transaction';
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

  ({Category? category, SubCategory? subCategory, String? keyword}) _extractCategory(String input, List<Category> categories, String languageCode) {
    String text = input.toLowerCase();
    
    // Map to track score: Category -> Score
    Map<Category, int> categoryScores = {};
    // Map to track subcat score: SubCategory -> Score
    Map<SubCategory, int> subCategoryScores = {};
    
    // Also track the "best matching keyword" for each category to use as Title
    Map<Category, String> bestKwForCat = {};
    Map<SubCategory, String> bestKwForSub = {};

    // 1. Scan ALL patterns and accumulate scores
    final patterns = PatternManager.getPatterns(languageCode); // Use Manager
    
    for (var entry in patterns.entries) {
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

