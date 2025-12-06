import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'dashboard_filter_provider.dart';
import 'widgets/recent_transactions_list.dart';

class FilteredTransactionsScreen extends ConsumerWidget {
  final bool isExpense;

  const FilteredTransactionsScreen({
    super.key,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the same provider used by the dashboard to ensure consistency with the time filter
    final filteredTransactionsAsync = ref.watch(filteredTransactionsProvider);
    final filterState = ref.watch(dashboardFilterProvider);

    String timeLabel = '';
    switch (filterState.filterType) {
      case TimeFilterType.day:
        timeLabel = 'Today';
        break;
      case TimeFilterType.week:
        timeLabel = 'This Week';
        break;
      case TimeFilterType.month:
        timeLabel = 'This Month';
        break;
      case TimeFilterType.year:
        timeLabel = 'This Year';
        break;
      case TimeFilterType.all:
        timeLabel = 'All Time';
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              isExpense ? 'Expense Details' : 'Income Details',
              style: AppTextStyles.h3,
            ),
            Text(
              timeLabel,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: filteredTransactionsAsync.when(
        data: (transactions) {
          // Filter by type (Income/Expense)
          final typeFilteredTransactions = transactions.where((t) {
            // Check for System transactions that might be income/expense
            final isSystem = t.type.name == 'system'; // Using loose check or existing check
             
            // Re-using logic from RecentTransactionsList/TransactionListItem for consistent classification
            final isDebtIncome = isSystem && (t.title.toLowerCase().contains('borrowed') || t.title.toLowerCase().contains('received payment'));
            final isSavingsWithdraw = isSystem && t.title.toLowerCase().contains('withdraw from');
            
            final isTExpense = (t.isExpense || isSystem) && !isDebtIncome && !isSavingsWithdraw;
            
            return isTExpense == isExpense;
          }).toList();

          if (typeFilteredTransactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isExpense ? Icons.money_off_csred_rounded : Icons.attach_money_rounded,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No ${isExpense ? 'expenses' : 'income'} found",
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "for $timeLabel",
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          // Sort by date descending
          typeFilteredTransactions.sort((a, b) => b.date.compareTo(a.date));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: RecentTransactionsList(transactions: typeFilteredTransactions),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
