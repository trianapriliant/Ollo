import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/presentation/transaction_provider.dart';
import '../../transactions/domain/transaction.dart';
import 'wallet_provider.dart';

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

final walletSummaryProvider = Provider.autoDispose<AsyncValue<WalletSummaryState>>((ref) {
  final walletsAsync = ref.watch(walletListProvider);
  final transactionsAsync = ref.watch(transactionListProvider);

  if (walletsAsync.isLoading || transactionsAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (walletsAsync.hasError) {
    return AsyncValue.error(walletsAsync.error!, walletsAsync.stackTrace!);
  }
  if (transactionsAsync.hasError) {
    return AsyncValue.error(transactionsAsync.error!, transactionsAsync.stackTrace!);
  }

  final wallets = walletsAsync.valueOrNull ?? [];
  final allTransactions = transactionsAsync.valueOrNull ?? [];

  // 1. Calculate total balance from wallets
  final totalBalance = wallets.fold<double>(0, (sum, wallet) => sum + wallet.balance);

  // 2. Calculate period change (last 30 days)
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
  }

  final periodChange = income - expense;

  // 3. Calculate percentage change
  final previousBalance = totalBalance - periodChange;
  
  double percentageChange = 0;
  if (previousBalance != 0) {
    percentageChange = (periodChange / previousBalance.abs()) * 100;
  } else if (periodChange > 0) {
    percentageChange = 100;
  } else if (periodChange < 0) {
    percentageChange = -100;
  }

  return AsyncValue.data(WalletSummaryState(
    totalBalance: totalBalance,
    periodChange: periodChange,
    percentageChange: percentageChange,
  ));
});
