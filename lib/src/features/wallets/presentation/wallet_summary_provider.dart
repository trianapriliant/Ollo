import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../data/wallet_repository.dart';

class WalletSummaryState {
  final double totalBalance;
  final double periodChange; // Absolute change in the last 30 days
  final double percentageChange;

  WalletSummaryState({
    required this.totalBalance,
    required this.periodChange,
    required this.percentageChange,
  });

  factory WalletSummaryState.initial() {
    return WalletSummaryState(
      totalBalance: 0,
      periodChange: 0,
      percentageChange: 0,
    );
  }
}

final walletSummaryProvider = FutureProvider.autoDispose<WalletSummaryState>((ref) async {
  // 1. Get all wallets to calculate total balance
  final walletRepo = await ref.watch(walletRepositoryProvider.future);
  final wallets = await walletRepo.getAllWallets();
  final totalBalance = wallets.fold<double>(0, (sum, wallet) => sum + wallet.balance);

  // 2. Get transactions from the last 30 days to calculate trend
  final transactionRepo = await ref.watch(transactionRepositoryProvider.future);
  final allTransactions = await transactionRepo.getAllTransactions();
  
  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));

  final recentTransactions = allTransactions.where((t) {
    return t.date.isAfter(thirtyDaysAgo) && t.date.isBefore(now);
  });

  double income = 0;
  double expense = 0;

  for (var t in recentTransactions) {
    if (t.type == TransactionType.income) {
      income += t.amount;
    } else if (t.type == TransactionType.expense) {
      expense += t.amount;
    }
    // Transfers are neutral for total net worth (unless across tracked/untracked, but assuming closed system for now)
  }

  final periodChange = income - expense;

  // 3. Calculate percentage change
  // Formula: (Current Balance - Previous Balance) / |Previous Balance| * 100
  // Previous Balance = Current Balance - Period Change
  final previousBalance = totalBalance - periodChange;
  
  double percentageChange = 0;
  if (previousBalance != 0) {
    percentageChange = (periodChange / previousBalance.abs()) * 100;
  } else if (periodChange > 0) {
    percentageChange = 100; // From 0 to positive is 100% growth (technically infinite, but 100 is a safe UI representation)
  } else if (periodChange < 0) {
    percentageChange = -100;
  }

  return WalletSummaryState(
    totalBalance: totalBalance,
    periodChange: periodChange,
    percentageChange: percentageChange,
  );
});
