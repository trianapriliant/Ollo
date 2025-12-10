import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bills/data/bill_repository.dart';
import '../../bills/domain/bill.dart';
import '../../budget/data/budget_repository.dart';
import '../../budget/domain/budget.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../debts/data/debt_repository.dart';
import '../../debts/domain/debt.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';

final backupServiceProvider = Provider((ref) => BackupService(ref));

class BackupService {
  final Ref _ref;

  BackupService(this._ref);

  Future<String> createBackup() async {
    // 1. Fetch All Data
    final transactionRepo = await _ref.read(transactionRepositoryProvider.future);
    final walletRepo = await _ref.read(walletRepositoryProvider.future);
    final categoryRepo = await _ref.read(categoryRepositoryProvider.future);
    final debtRepo = _ref.read(debtRepositoryProvider);
    final budgetRepo = _ref.read(budgetRepositoryProvider);
    final billRepo = _ref.read(billRepositoryProvider);

    final transactions = await transactionRepo.getAllTransactions();
    final wallets = await walletRepo.getAllWallets();
    final categories = await categoryRepo.getAllCategories();
    final debts = await debtRepo.getAllDebts();
    final budgets = await budgetRepo.getAllBudgets();
    final bills = await billRepo.getAllBills();

    // 2. Construct Data Map
    final backupData = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'data': {
        'wallets': wallets.map((e) => e.toJson()).toList(),
        'categories': categories.map((e) => e.toJson()).toList(),
        'transactions': transactions.map((e) => e.toJson()).toList(),
        'debts': debts.map((e) => e.toJson()).toList(),
        'budgets': budgets.map((e) => e.toJson()).toList(),
        'bills': bills.map((e) => e.toJson()).toList(),
      }
    };

    // 3. Convert to JSON
    final jsonString = jsonEncode(backupData);

    // 4. Save to Downloads (Logic matched from DataExportService)
    String? downloadPath;
    if (Platform.isAndroid) {
      downloadPath = '/storage/emulated/0/Download';
      
      // Basic check for permissions if needed, generally public dir writable
      // If we want to be safe we could request manage external storage but let's try direct write first
    } else {
      final dir = await getDownloadsDirectory();
      downloadPath = dir?.path ?? (await getApplicationDocumentsDirectory()).path;
    }

    final fileName = "ollo_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json";
    final path = "$downloadPath/$fileName";
    final file = File(path);

    try {
        await file.writeAsString(jsonString);
        return path;
    } catch (e) {
        // Fallback
        final docsDir = await getApplicationDocumentsDirectory();
        final fallbackPath = "${docsDir.path}/$fileName";
        final fallbackFile = File(fallbackPath);
        await fallbackFile.writeAsString(jsonString);
        return fallbackPath;
    }
  }

  Future<void> restoreBackup() async {
    // 1. Pick File
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) {
      return; // User canceled
    }

    final file = File(result.files.single.path!);
    final content = await file.readAsString();
    
    // 2. Parse JSON
    final Map<String, dynamic> backupData;
    try {
       backupData = jsonDecode(content);
    } catch (e) {
       throw const FormatException("Invalid backup file format");
    }

    final version = backupData['version'] as int?;
    if (version == null || version != 1) {
       // Handle version mismatch if needed in future
    }
    
    final data = backupData['data'] as Map<String, dynamic>;

    // 3. Deserialize Data
    final wallets = (data['wallets'] as List).map((e) => Wallet.fromJson(e)).toList();
    final categories = (data['categories'] as List).map((e) => Category.fromJson(e)).toList();
    final transactions = (data['transactions'] as List).map((e) => Transaction.fromJson(e)).toList();
    final debts = (data['debts'] as List?)?.map((e) => Debt.fromJson(e)).toList() ?? [];
    final budgets = (data['budgets'] as List?)?.map((e) => Budget.fromJson(e)).toList() ?? [];
    final bills = (data['bills'] as List?)?.map((e) => Bill.fromJson(e)).toList() ?? [];

    // 4. Clear & Import (Wipe & Replace)
    final transactionRepo = await _ref.read(transactionRepositoryProvider.future);
    final walletRepo = await _ref.read(walletRepositoryProvider.future);
    final categoryRepo = await _ref.read(categoryRepositoryProvider.future);
    final debtRepo = _ref.read(debtRepositoryProvider);
    final budgetRepo = _ref.read(budgetRepositoryProvider);
    final billRepo = _ref.read(billRepositoryProvider);

    // Order matters? Usually Reference integrity isn't strictly enforced by Isar unless links are set.
    // We clear children first usually, but Isar clear removes collection.
    
    // Validate we have data before clearing!
    if (wallets.isEmpty && transactions.isEmpty) {
       throw Exception("Backup file appears empty");
    }

    await transactionRepo.clearAllTransactions();
    await walletRepo.clearAllWallets();
    await categoryRepo.clearAllCategories();
    await debtRepo.clearAllDebts();
    await budgetRepo.clearAllBudgets();
    await billRepo.clearAllBills();

    await walletRepo.importWallets(wallets);
    await categoryRepo.importCategories(categories);
    await transactionRepo.importTransactions(transactions);
    await debtRepo.importDebts(debts);
    await budgetRepo.importBudgets(budgets);
    await billRepo.importBills(bills);
  }
}
