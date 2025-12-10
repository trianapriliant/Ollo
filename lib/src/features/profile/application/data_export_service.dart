import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../wallets/data/wallet_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart'; // For platform check if needed or use dart:io
import '../../categories/data/category_repository.dart';
import '../../transactions/domain/transaction.dart';

final dataExportServiceProvider = Provider((ref) => DataExportService(ref));

class DataExportService {
  final Ref _ref;

  DataExportService(this._ref);

  Future<void> exportTransactionsToCsv({
    required DateTime startDate,
    required DateTime endDate,
    String? walletId,
    String? categoryId,
    TransactionType? type,
  }) async {
    // 5. Generate CSV Data
    final csvData = await _generateCsvData(
      startDate: startDate,
      endDate: endDate,
      walletId: walletId,
      categoryId: categoryId,
      type: type,
    );

    // 6. Save to Temp File
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/ollo_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    // 7. Share File
    await Share.shareXFiles([XFile(path, mimeType: 'text/csv')], text: 'Here is my Ollo transaction data!');
  }

  Future<String> saveToDownloads({
    required DateTime startDate,
    required DateTime endDate,
    String? walletId,
    String? categoryId,
    TransactionType? type,
  }) async {
    // 1. Generate CSV Data
    final csvData = await _generateCsvData(
       startDate: startDate, 
       endDate: endDate, 
       walletId: walletId, 
       categoryId: categoryId, 
       type: type
    );

    // 2. Determine Path
    String? downloadPath;
    if (Platform.isAndroid) {
      downloadPath = '/storage/emulated/0/Download';
    } else {
      final dir = await getDownloadsDirectory();
      downloadPath = dir?.path ?? (await getApplicationDocumentsDirectory()).path;
    }

    final fileName = "ollo_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv";
    final path = "$downloadPath/$fileName";
    final file = File(path);

    // 3. Write
    try {
        await file.writeAsString(csvData);
        return path;
    } catch (e) {
        // Fallback for some restricted environments: try app docs
        final docsDir = await getApplicationDocumentsDirectory();
        final fallbackPath = "${docsDir.path}/$fileName";
        final fallbackFile = File(fallbackPath);
        await fallbackFile.writeAsString(csvData);
        return fallbackPath;
    }
  }

  Future<String> _generateCsvData({
    required DateTime startDate,
    required DateTime endDate,
    String? walletId,
    String? categoryId,
    TransactionType? type,
  }) async {
    final transactionRepo = await _ref.read(transactionRepositoryProvider.future);
    final walletRepo = await _ref.read(walletRepositoryProvider.future);
    final categoryRepo = await _ref.read(categoryRepositoryProvider.future);

    final allTransactions = await transactionRepo.getAllTransactions();
    final wallets = await walletRepo.watchWallets().first;
    final categories = await categoryRepo.getAllCategories();

    final transactions = _filterTransactions(
      allTransactions,
      startDate: startDate,
      endDate: endDate,
      walletId: walletId,
      categoryId: categoryId,
      type: type,
    );

    if (transactions.isEmpty) {
      throw Exception("No transactions match the selected filters");
    }

    final List<List<dynamic>> rows = [];
    rows.add([ "Date", "Title", "Type", "Wallet", "Destination Wallet", "Category", "SubCategory", "Amount", "Note" ]);

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    for (var t in transactions) {
      final wallet = wallets.firstWhere((w) {
         return (w.externalId ?? w.id.toString()) == t.walletId;
      }, orElse: () => wallets.first);

      String destWalletName = "";
      if (t.destinationWalletId != null) {
         final destWallet = wallets.firstWhere((w) {
            return (w.externalId ?? w.id.toString()) == t.destinationWalletId;
         }, orElse: () => wallets.first);
         destWalletName = destWallet.name;
      }

      String categoryName = "";
      if (t.categoryId != null) {
         if (t.categoryId == 'bills') categoryName = "Bills";
         else if (t.categoryId == 'wishlist') categoryName = "Wishlist";
         else if (t.categoryId == 'debt') categoryName = "Debt";
         else if (['notes', 'note', 'Smart Notes', 'smart notes'].contains(t.categoryId)) categoryName = "Smart Notes";
         else {
            final cat = categories.firstWhere((c) {
               return (c.externalId ?? c.id.toString()) == t.categoryId;
            }, orElse: () => categories.firstWhere((c) => c.name == 'Others', orElse: () => categories.first));
            categoryName = cat.name;
         }
      }

      rows.add([
        dateFormat.format(t.date),
        t.title,
        t.type.name.toUpperCase(),
        wallet.name,
        destWalletName,
        categoryName,
        t.subCategoryName ?? "",
        t.amount,
        t.note ?? "",
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  Future<int> getFilteredTransactionCount({
    required DateTime startDate,
    required DateTime endDate,
    String? walletId,
    String? categoryId,
    TransactionType? type,
  }) async {
    final transactionRepo = await _ref.read(transactionRepositoryProvider.future);
    final allTransactions = await transactionRepo.getAllTransactions();
    
    final filtered = _filterTransactions(
      allTransactions,
      startDate: startDate,
      endDate: endDate,
      walletId: walletId,
      categoryId: categoryId,
      type: type,
    );
    
    return filtered.length;
  }

  List<Transaction> _filterTransactions(
    List<Transaction> transactions, {
    required DateTime startDate,
    required DateTime endDate,
    String? walletId,
    String? categoryId,
    TransactionType? type,
  }) {
    // Normalize dates
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return transactions.where((t) {
      // Date Filter
      if (t.date.isBefore(start) || t.date.isAfter(end)) return false;

      // Type Filter
      if (type != null && t.type != type) return false;

      // Wallet Filter
      if (walletId != null && t.walletId != walletId) return false;

      // Category Filter
      if (categoryId != null) {
        // Special System Categories are handled by ID string check
        // Regular categories match by ID
        if (t.categoryId != categoryId) return false;
      }

      return true;
    }).toList();
  }
}
