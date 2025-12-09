import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'dashboard_filter_provider.dart';
import 'widgets/recent_transactions_list.dart';
import 'transaction_provider.dart';
import '../../transactions/domain/transaction.dart';

class FilteredTransactionsScreen extends ConsumerWidget {
  final bool isExpense;
  final DateTime? specificDate; // New optional parameter

  const FilteredTransactionsScreen({
    super.key,
    required this.isExpense,
    this.specificDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTransactionsAsync = ref.watch(filteredTransactionsProvider);
    final allTransactionsAsync = ref.watch(transactionListProvider); // Needed when specificDate is used
    final filterState = ref.watch(dashboardFilterProvider);

    String timeLabel = '';
    
    if (specificDate != null) {
      // Format: "Dec 7, 2025"
      timeLabel = _formatDate(specificDate!);
    } else {
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
      body: specificDate != null 
          ? allTransactionsAsync.when(
              data: (transactions) => _buildTransactionList(transactions, isSpecificDate: true),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            )
          : filteredTransactionsAsync.when(
              data: (transactions) => _buildTransactionList(transactions, isSpecificDate: false),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildTransactionList(List<Transaction> transactions, {required bool isSpecificDate}) { 
    // Filter logic
    final typeFilteredTransactions = transactions.where((t) {
      
       // 1. Date Check (if specificDate is set)
       if (isSpecificDate && specificDate != null) {
         if (t.date.year != specificDate!.year || 
             t.date.month != specificDate!.month || 
             t.date.day != specificDate!.day) {
           return false;
         }
       }

      // 2. Type Check
      // Check for System transactions that might be income/expense
      final isSystem = t.type == TransactionType.system; 
        
      // Re-using logic from RecentTransactionsList/TransactionListItem for consistent classification
      final isDebtIncome = isSystem && (t.title.toLowerCase().contains('borrowed') || t.title.toLowerCase().contains('received payment'));
      final isSavingsWithdraw = isSystem && t.title.toLowerCase().contains('withdraw from');
      
      final isTransfer = t.type == TransactionType.transfer;
      final isReimbursement = t.type == TransactionType.reimbursement;

      if (isTransfer || isReimbursement) return false; // Strictly exclude Transfer/Reimbursement from Income/Expense lists

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
              "for this date", // Simplified label
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    // Sort by date descending
    typeFilteredTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Cast to List<Transaction> if needed, though mostly implicit
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      // Assuming RecentTransactionsList takes List<Transaction>
      child: RecentTransactionsList(transactions: typeFilteredTransactions), 
    );
  }
}
