import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../../transactions/domain/transaction.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../common/data/isar_provider.dart';

final dataImportServiceProvider = Provider<DataImportService>((ref) {
  return DataImportService(ref);
});

class DataImportService {
  final Ref ref;

  DataImportService(this.ref);

  Future<String> generateTemplate() async {
    final List<List<dynamic>> rows = [];
    
    // Header
    rows.add([
      'Date (YYYY-MM-DD)', 
      'Type (Income, Expense, Transfer)', 
      'Amount', 
      'Title', 
      'Wallet (Name)', 
      'Destination Wallet (Transfer Only)', 
      'Category (Name)', 
      'SubCategory (Optional)', 
      'Note',
      'Fee (Optional)'
    ]);

    // Example Rows
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    
    rows.add([
      dateStr, 'Expense', 50000, 'Lunch', 'Cash', '', 'Food', 'Lunch', 'Team lunch', ''
    ]);
    rows.add([
      dateStr, 'Income', 10000000, 'Salary', 'Bank', '', 'Salary', 'Monthly', 'October Salary', ''
    ]);
    rows.add([
      dateStr, 'Transfer', 500000, 'Topup E-Wallet', 'Bank', 'E-Wallet', '', '', 'Topup', '2500'
    ]);

    String csv = const ListToCsvConverter().convert(rows);
    
    // Save to Downloads
    String? path;
    if (Platform.isAndroid) {
        path = '/storage/emulated/0/Download';
    } else if (Platform.isWindows) {
        final directory = await getDownloadsDirectory();
        path = directory?.path;
    } else {
        final directory = await getApplicationDocumentsDirectory();
        path = directory.path;
    }
    
    if (path == null) throw Exception('Could not find downloads directory');
    
    final file = File('$path/ollo_import_template.csv');
    await file.writeAsString(csv);
    
    return file.path;
  }

  Future<Map<String, int>> importCsv(File file) async {
    final input = await file.readAsString();
    return importCsvContent(input);
  }

  Future<Map<String, int>> importCsvContent(String input) async {
    final List<List<dynamic>> rows = const CsvToListConverter().convert(input, eol: '\n');
    
    if (rows.isEmpty || rows.length < 2) {
      throw Exception('File is empty or missing headers');
    }

    // Repositories
    final transactionRepo = await ref.read(transactionRepositoryProvider.future);
    final walletRepo = await ref.read(walletRepositoryProvider.future);
    
    // Cache Wallets and Categories
    final wallets = await walletRepo.getAllWallets();
    final categories = await ref.read(allCategoriesStreamProvider.future);

    int success = 0;
    int failed = 0;

    // Skip Header (Start from index 1)
    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
        if (row.isEmpty) continue; // Skip empty rows
        
        // Parse columns (Safe access)
        final String dateStr = row.length > 0 ? row[0].toString().trim() : '';
        final String typeStr = row.length > 1 ? row[1].toString().trim().toLowerCase() : '';
        final double amount = row.length > 2 ? (double.tryParse(row[2].toString()) ?? 0.0) : 0.0;
        final String title = row.length > 3 ? row[3].toString().trim() : 'Imported';
        final String walletName = row.length > 4 ? row[4].toString().trim().toLowerCase() : '';
        final String destWalletName = row.length > 5 ? row[5].toString().trim().toLowerCase() : '';
        final String catName = row.length > 6 ? row[6].toString().trim().toLowerCase() : '';
        final String subCatName = row.length > 7 ? row[7].toString().trim().toLowerCase() : '';
        final String note = row.length > 8 ? row[8].toString().trim() : '';
        final double fee = row.length > 9 ? (double.tryParse(row[9].toString()) ?? 0.0) : 0.0;

        if (amount <= 0 && fee <= 0) continue; // Skip invalid amount 
        
        // Date Parsing
        DateTime date;
        try {
             if (dateStr.contains('/')) {
                 // Try DD/MM/YYYY
                 final parts = dateStr.split('/');
                 if (parts.length == 3) {
                     date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                 } else {
                     date = DateTime.now();
                 }
             } else {
                 date = DateTime.parse(dateStr);
             }
        } catch (_) {
             date = DateTime.now();
        }

        // Type Parsing
        TransactionType type = TransactionType.expense;
        if (typeStr == 'income') type = TransactionType.income;
        if (typeStr == 'transfer') type = TransactionType.transfer;

        // Resolve Wallet
        String? walletId;
        try {
           final wallet = wallets.firstWhere(
             (w) => w.name.toLowerCase() == walletName, 
             orElse: () => wallets.firstWhere((w) => w.externalId == 'cash_default', orElse: () => wallets.first)
           );
           walletId = wallet.externalId ?? wallet.id.toString();
        } catch (_) {}

        if (walletId == null) throw Exception('No valid wallet found');

        // Resolve Destination Wallet (Transfer)
        String? destWalletId;
        if (type == TransactionType.transfer) {
           try {
              final destWallet = wallets.firstWhere((w) => w.name.toLowerCase() == destWalletName);
              destWalletId = destWallet.externalId ?? destWallet.id.toString();
           } catch (_) {}
           
           if (destWalletId == null && destWalletName.isNotEmpty) {
               // Fallback: If destination wallet not found
           }
        }

        // Resolve Category
        Category? category;
        SubCategory? subCategory;
        if (type != TransactionType.transfer) {
            try {
               // Find Category Name Match
               category = categories.firstWhere((c) => c.name.toLowerCase() == catName);
               
               // Find SubCategory
               if (subCatName.isNotEmpty && category.subCategories != null) {
                  try {
                      subCategory = category.subCategories!.firstWhere((s) => (s.name?.toLowerCase() ?? '') == subCatName);
                  } catch (_) {}
               }
            } catch (_) {
               // Fallback to "Others" or "Uncategorized" if available
               try {
                  if (type == TransactionType.expense) {
                     category = categories.firstWhere((c) => c.externalId == 'financial' || c.externalId == 'shopping', orElse: () => categories.first);
                  } else {
                     category = categories.firstWhere((c) => c.externalId == 'other_income', orElse: () => categories.where((c) => c.type == CategoryType.income).first);
                  }
               } catch (_) {}
            }
        }

        // Create Transaction
        final transaction = Transaction()
          ..title = title
          ..date = date
          ..amount = amount
          ..type = type
          ..walletId = walletId
          ..destinationWalletId = destWalletId
          ..categoryId = category?.externalId ?? category?.id.toString()
          ..subCategoryId = subCategory?.id
          ..subCategoryName = subCategory?.name
          ..subCategoryIcon = subCategory?.iconPath
          ..note = note;
          
        await transactionRepo.addTransaction(transaction);
        
        // Handle Fee
        if (type == TransactionType.transfer && fee > 0) {
           // Find Fee Category
           Category? feeCategory;
           SubCategory? feeSubCategory;
           
           try {
              final financialCat = categories.firstWhere((c) => c.externalId == 'financial', orElse: () => categories.first);
              if (financialCat.subCategories != null) {
                 feeSubCategory = financialCat.subCategories!.firstWhere((s) => s.id == 'fees' || s.id == 'fee', orElse: () => financialCat.subCategories!.first);
                 feeCategory = financialCat;
              }
           } catch (_) {}
           
           final feeTx = Transaction()
             ..title = 'Transfer Fee ($title)'
             ..date = date
             ..amount = fee
             ..type = TransactionType.expense
             ..walletId = walletId
             ..categoryId = feeCategory?.externalId ?? feeCategory?.id.toString()
             ..subCategoryId = feeSubCategory?.id
             ..subCategoryName = feeSubCategory?.name
             ..subCategoryIcon = feeSubCategory?.iconPath
             ..note = 'Fee for transfer (Imported)';
             
           await transactionRepo.addTransaction(feeTx);
        }

        success++;
      } catch (e) {
        failed++;
        print('Error importing row $i: $e');
      }
    }
    
    return {'success': success, 'failed': failed};
  }
}
