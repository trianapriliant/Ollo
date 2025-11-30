import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';
import '../data/recurring_repository.dart';
import '../domain/recurring_transaction.dart';

class RecurringTransactionService {
  final RecurringRepository recurringRepo;
  final TransactionRepository transactionRepo;
  final WalletRepository walletRepo;

  RecurringTransactionService({
    required this.recurringRepo,
    required this.transactionRepo,
    required this.walletRepo,
  });

  Future<void> processDueTransactions() async {
    final activeRecurring = await recurringRepo.getActiveRecurringTransactions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var recurring in activeRecurring) {
      // Check if due date is today or in the past
      if (recurring.nextDueDate.isBefore(today) || recurring.nextDueDate.isAtSameMomentAs(today)) {
        await _processSingleTransaction(recurring);
      }
    }
  }

  Future<void> _processSingleTransaction(RecurringTransaction recurring) async {
    // 1. Get Wallet
    final wallet = await walletRepo.getWallet(recurring.walletId);
    if (wallet == null) return; // Skip if wallet not found

    // 2. Create Transaction
    final newTransaction = Transaction.create(
      title: recurring.note ?? 'Recurring Payment',
      amount: recurring.amount,
      type: TransactionType.expense,
      categoryId: recurring.categoryId,
      walletId: recurring.walletId,
      note: 'Auto-processed recurring payment',
      date: recurring.nextDueDate, // Use the due date as transaction date
    );

    // 3. Update Wallet Balance
    wallet.balance -= recurring.amount;

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
    await transactionRepo.addTransaction(newTransaction);
    await walletRepo.updateWallet(wallet);
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
  final recurringRepo = ref.watch(recurringRepositoryProvider);
  final transactionRepo = await ref.watch(transactionRepositoryProvider.future);
  final walletRepo = await ref.watch(walletRepositoryProvider.future);

  return RecurringTransactionService(
    recurringRepo: recurringRepo,
    transactionRepo: transactionRepo,
    walletRepo: walletRepo,
  );
});
