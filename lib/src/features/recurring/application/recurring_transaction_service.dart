import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/data/isar_provider.dart';
import 'package:uuid/uuid.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';
import '../data/recurring_repository.dart';
import '../domain/recurring_transaction.dart';
import '../../bills/data/bill_repository.dart';
import '../../bills/domain/bill.dart';

class RecurringTransactionService {
  final RecurringRepository recurringRepo;
  final TransactionRepository transactionRepo;
  final WalletRepository walletRepo;
  final BillRepository billRepo;

  RecurringTransactionService({
    required this.recurringRepo,
    required this.transactionRepo,
    required this.walletRepo,
    required this.billRepo,
  });

  bool _isProcessing = false;

  Future<void> processDueTransactions() async {
    if (_isProcessing) return;
    _isProcessing = true;
    
    try {
      final activeRecurring = await recurringRepo.getActiveRecurringTransactions();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (var recurring in activeRecurring) {
        // Check if due date is today or in the past
        if (recurring.nextDueDate.isBefore(today) || recurring.nextDueDate.isAtSameMomentAs(today)) {
          await _processSingleTransaction(recurring);
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processSingleTransaction(RecurringTransaction recurring) async {
    // 1. Get Wallet
    final wallet = await walletRepo.getWallet(recurring.walletId);
    if (wallet == null) return; // Skip if wallet not found

    // 2. Process based on type
    if (recurring.createBillOnly) {
      // Create Bill (Unpaid)
      final newBill = Bill(
        title: recurring.note ?? 'Recurring Bill',
        amount: recurring.amount,
        dueDate: recurring.nextDueDate,
        categoryId: recurring.categoryId,
        walletId: recurring.walletId,
        note: 'Auto-generated from recurring',
        status: BillStatus.unpaid,
        recurringTransactionId: recurring.id,
      );
      await billRepo.addBill(newBill);
    } else {
      // Create Transaction (Auto-pay)
      final newTransaction = Transaction.create(
        title: recurring.note ?? 'Recurring Payment',
        amount: recurring.amount,
        type: TransactionType.expense,
        categoryId: recurring.categoryId,
        walletId: recurring.walletId,
        note: 'Auto-processed recurring payment',
        date: recurring.nextDueDate,
      );
      
      // Update Wallet Balance
      wallet.balance -= recurring.amount;
      await transactionRepo.addTransaction(newTransaction);
      await walletRepo.updateWallet(wallet);
    }

    // 4. Calculate Next Due Date
    DateTime nextDue = recurring.nextDueDate;
    switch (recurring.frequency) {
      case RecurringFrequency.daily:
        nextDue = nextDue.add(const Duration(days: 1));
        break;
      case RecurringFrequency.weekly:
        nextDue = nextDue.add(const Duration(days: 7));
        break;
      case RecurringFrequency.monthly:
        nextDue = DateTime(nextDue.year, nextDue.month + 1, nextDue.day);
        break;
      case RecurringFrequency.yearly:
        nextDue = DateTime(nextDue.year + 1, nextDue.month, nextDue.day);
        break;
    }
    recurring.nextDueDate = nextDue;

    // 5. Save Changes
    // Ideally this should be a single transaction, but for now we do it sequentially
    // Transaction and Wallet updates are handled above if needed
    await recurringRepo.updateRecurringTransaction(recurring);
  }
}

final recurringTransactionServiceProvider = Provider<RecurringTransactionService>((ref) {
  // We use read here because repositories are initialized in main
  // But to be safe inside a Provider, we should watch or ensure they are ready.
  // Since repositories are synchronous wrappers around Isar (which is async init),
  // we might need to handle the async nature.
  // However, the repositories themselves are provided as synchronous objects once Isar is ready.
  // Let's assume Isar is ready when this is called.
  
  // Actually, the repositories are provided via Providers that might throw if Isar isn't ready.
  // We should use a FutureProvider or ensure initialization.
  // For simplicity, we'll assume this service is used after app init.
  
  final recurringRepo = ref.watch(recurringRepositoryProvider);
  // Transaction and Wallet repos are FutureProviders in the current codebase, 
  // so we need to handle that.
  // Wait, let's check the repository providers again.
  // recurringRepositoryProvider is a Provider (sync).
  // walletRepositoryProvider is a FutureProvider.
  // transactionRepositoryProvider is a FutureProvider.
  
  // This makes it tricky to create a sync Provider for the service.
  // We'll make this a FutureProvider.
  throw UnimplementedError('Use recurringTransactionServiceFutureProvider instead');
});

final recurringTransactionServiceFutureProvider = FutureProvider<RecurringTransactionService>((ref) async {
  // Ensure Isar is initialized before accessing synchronous repositories
  await ref.watch(isarProvider.future);

  final recurringRepo = ref.watch(recurringRepositoryProvider);
  final transactionRepo = await ref.watch(transactionRepositoryProvider.future);
  final walletRepo = await ref.watch(walletRepositoryProvider.future);
  final billRepo = ref.watch(billRepositoryProvider);

  return RecurringTransactionService(
    recurringRepo: recurringRepo,
    transactionRepo: transactionRepo,
    walletRepo: walletRepo,
    billRepo: billRepo,
  );
});
