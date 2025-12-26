import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

import '../../recurring/data/recurring_repository.dart';
import '../../recurring/domain/recurring_transaction.dart';
import '../../wishlist/data/wishlist_repository.dart';
import '../../wishlist/domain/wishlist.dart';
import '../../smart_notes/data/smart_note_repository.dart';
import '../../smart_notes/domain/smart_note.dart';
import '../../savings/data/saving_repository.dart';
import '../../savings/domain/saving_goal.dart';
import '../../savings/domain/saving_log.dart';
import '../../cards/data/card_repository.dart';
import '../../cards/domain/card.dart';

import '../../profile/data/user_profile_repository.dart';
import '../../profile/domain/user_profile.dart';

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
    final recurringRepo = _ref.read(recurringRepositoryProvider);
    final wishlistRepo = _ref.read(wishlistRepositoryProvider);
    final smartNoteRepo = _ref.read(smartNoteRepositoryProvider);
    final savingRepo = _ref.read(savingRepositoryProvider);
    final cardRepo = _ref.read(cardRepositoryProvider);
    final profileRepo = await _ref.read(userProfileRepositoryProvider.future);

    final transactions = await transactionRepo.getAllTransactions();
    final wallets = await walletRepo.getAllWallets();
    final categories = await categoryRepo.getAllCategories();
    final debts = await debtRepo.getAllDebts();
    final budgets = await budgetRepo.getAllBudgets();
    final bills = await billRepo.getAllBills();
    final recurring = await recurringRepo.getAllRecurringTransactions();
    final wishlists = await wishlistRepo.getAllWishlists();
    final smartNotes = await smartNoteRepo.watchNotes().first; // Stream
    final savingGoals = await savingRepo.getSavingGoals();
    final savingLogs = await savingRepo.getAllLogs();
    final cards = await cardRepo.watchCards().first; // Stream
    final profile = await profileRepo.getUserProfile();
    
    // Fetch settings from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final settings = {
      'transaction_color_theme': prefs.getInt('transaction_color_theme'),
      'main_card_theme': prefs.getString('main_card_theme'),
      'language_code': prefs.getString('language_code'),
      'voice_language_code': prefs.getString('voice_language_code'),
      'dashboard_menu_order': prefs.getStringList('dashboard_menu_order'),
    };

    // 2. Construct Data Map
    final backupData = {
      'version': 2,
      'timestamp': DateTime.now().toIso8601String(),
      'data': {
        'wallets': wallets.map((e) => e.toJson()).toList(),
        'categories': categories.map((e) => e.toJson()).toList(),
        'transactions': transactions.map((e) => e.toJson()).toList(),
        'debts': debts.map((e) => e.toJson()).toList(),
        'budgets': budgets.map((e) => e.toJson()).toList(),
        'bills': bills.map((e) => e.toJson()).toList(),
        'recurring': recurring.map((e) => e.toJson()).toList(),
        'wishlists': wishlists.map((e) => e.toJson()).toList(),
        'smartNotes': smartNotes.map((e) => e.toJson()).toList(),
        'savingGoals': savingGoals.map((e) => e.toJson()).toList(),
        'savingLogs': savingLogs.map((e) => e.toJson()).toList(),
        'cards': cards.map((e) => e.toJson()).toList(),
        'profile': profile.toJson(),
        'settings': settings,
      }
    };

    // 3. Convert to JSON
    final jsonString = jsonEncode(backupData);

    // 4. Save to Custom Folder
    String? downloadPath;
    if (Platform.isAndroid) {
      // Try to save to "Documents/Ollo/Backup"
      // /storage/emulated/0/Documents/Ollo/Backup
      final directory = Directory('/storage/emulated/0/Documents/Ollo/Backup');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      downloadPath = directory.path;
    } else {
      final dir = await getDownloadsDirectory();
      downloadPath = dir?.path ?? (await getApplicationDocumentsDirectory()).path;
    }

    final fileName = "ollo_backup_v2_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json";
    final path = "$downloadPath/$fileName";
    final file = File(path);

    try {
        await file.writeAsString(jsonString);
        return path;
    } catch (e) {
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
    // Version check kept simple for now
    
    final data = backupData['data'] as Map<String, dynamic>;

    // 3. Deserialize Data
    // Helper to safely map list
    List<T> safeMap<T>(dynamic list, T Function(Map<String, dynamic>) mapper) {
      if (list == null) return [];
      return (list as List).map((e) => mapper(e as Map<String, dynamic>)).toList();
    }

    final wallets = safeMap(data['wallets'], (json) => Wallet.fromJson(json));
    final categories = safeMap(data['categories'], (json) => Category.fromJson(json));
    final transactions = safeMap(data['transactions'], (json) => Transaction.fromJson(json));
    final debts = safeMap(data['debts'], (json) => Debt.fromJson(json));
    final budgets = safeMap(data['budgets'], (json) => Budget.fromJson(json));
    final bills = safeMap(data['bills'], (json) => Bill.fromJson(json));
    final recurring = safeMap(data['recurring'], (json) => RecurringTransaction.fromJson(json));
    final wishlists = safeMap(data['wishlists'], (json) => Wishlist.fromJson(json));
    final smartNotes = safeMap(data['smartNotes'], (json) => SmartNote.fromJson(json));
    final savingGoals = safeMap(data['savingGoals'], (json) => SavingGoal.fromJson(json));
    final savingLogs = safeMap(data['savingLogs'], (json) => SavingLog.fromJson(json));
    final cards = safeMap(data['cards'], (json) => BankCard.fromJson(json));
    
    UserProfile? profile;
    if (data['profile'] != null) {
      profile = UserProfile.fromJson(data['profile']);
    }

    // 4. Clear & Import (Wipe & Replace)
    final transactionRepo = await _ref.read(transactionRepositoryProvider.future);
    final walletRepo = await _ref.read(walletRepositoryProvider.future);
    final categoryRepo = await _ref.read(categoryRepositoryProvider.future);
    final debtRepo = _ref.read(debtRepositoryProvider);
    final budgetRepo = _ref.read(budgetRepositoryProvider);
    final billRepo = _ref.read(billRepositoryProvider);
    final recurringRepo = _ref.read(recurringRepositoryProvider);
    final wishlistRepo = _ref.read(wishlistRepositoryProvider);
    final smartNoteRepo = _ref.read(smartNoteRepositoryProvider);
    final savingRepo = _ref.read(savingRepositoryProvider);
    final cardRepo = _ref.read(cardRepositoryProvider);
    final profileRepo = await _ref.read(userProfileRepositoryProvider.future);

    await transactionRepo.clearAllTransactions();
    await walletRepo.clearAllWallets();
    await categoryRepo.clearAllCategories();
    await debtRepo.clearAllDebts();
    await budgetRepo.clearAllBudgets();
    await billRepo.clearAllBills();
    await recurringRepo.clearAll();
    await wishlistRepo.clearAll();
    await smartNoteRepo.clearAll();
    await savingRepo.clearAll();
    await cardRepo.clearAll();
    // No need to clear profile, we overwrite it.

    await walletRepo.importWallets(wallets);
    await categoryRepo.importCategories(categories);
    await transactionRepo.importTransactions(transactions);
    await debtRepo.importDebts(debts);
    await budgetRepo.importBudgets(budgets);
    await billRepo.importBills(bills);
    await recurringRepo.importAll(recurring);
    await wishlistRepo.importAll(wishlists);
    await smartNoteRepo.importAll(smartNotes);
    await savingRepo.importAll(savingGoals, savingLogs);
    await cardRepo.importAll(cards);
    
    if (profile != null) {
      await profileRepo.importProfile(profile);
    }
    
    // 5. Restore Settings from SharedPreferences (if present in backup)
    if (data['settings'] != null) {
      final settings = data['settings'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      
      // Color Palette Theme
      if (settings['transaction_color_theme'] != null) {
        await prefs.setInt('transaction_color_theme', settings['transaction_color_theme'] as int);
      }
      
      // Card Appearance Theme
      if (settings['main_card_theme'] != null) {
        await prefs.setString('main_card_theme', settings['main_card_theme'] as String);
      }
      
      // App Language
      if (settings['language_code'] != null) {
        await prefs.setString('language_code', settings['language_code'] as String);
      }
      
      // Voice Input Language
      if (settings['voice_language_code'] != null) {
        await prefs.setString('voice_language_code', settings['voice_language_code'] as String);
      }
      
      // Dashboard Menu Order
      if (settings['dashboard_menu_order'] != null) {
        await prefs.setStringList('dashboard_menu_order', 
            (settings['dashboard_menu_order'] as List).cast<String>());
      }
    }
  }
}
