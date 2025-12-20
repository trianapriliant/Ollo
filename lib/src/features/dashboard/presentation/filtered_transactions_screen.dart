import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'dashboard_filter_provider.dart';
import 'widgets/recent_transactions_list.dart';
import 'transaction_provider.dart';
import '../../transactions/domain/transaction.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class FilteredTransactionsScreen extends ConsumerWidget {
  final bool isExpense;
  final DateTime? specificDate;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilteredTransactionsScreen({
    super.key,
    required this.isExpense,
    this.specificDate,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTransactionsAsync = ref.watch(filteredTransactionsProvider);
    final allTransactionsAsync = ref.watch(transactionListProvider); // Needed when specificDate is used
    final filterState = ref.watch(dashboardFilterProvider);

    String timeLabel = '';
    
    if (specificDate != null) {
      // Format: "Dec 7, 2025"
      timeLabel = _formatDate(context, specificDate!);
    } else if (startDate != null && endDate != null) {
      // Format: "Dec 1 - Dec 7, 2025"
      timeLabel = '${_formatDate(context, startDate!)} - ${_formatDate(context, endDate!)}';
    } else {
      switch (filterState.filterType) {
        case TimeFilterType.day:
          timeLabel = AppLocalizations.of(context)!.timeFilterToday;
          break;
        case TimeFilterType.week:
          timeLabel = AppLocalizations.of(context)!.timeFilterThisWeek;
          break;
        case TimeFilterType.month:
          timeLabel = AppLocalizations.of(context)!.timeFilterThisMonth;
          break;
        case TimeFilterType.year:
          timeLabel = AppLocalizations.of(context)!.timeFilterThisYear;
          break;
        case TimeFilterType.all:
          timeLabel = AppLocalizations.of(context)!.timeFilterAllTime;
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
              isExpense ? AppLocalizations.of(context)!.expenseDetails : AppLocalizations.of(context)!.incomeDetails,
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
      body: (specificDate != null || (startDate != null && endDate != null))
          ? allTransactionsAsync.when(
              data: (transactions) => _buildTransactionList(context, transactions, isSpecificDate: specificDate != null),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.error(err.toString()))),
            )
          : filteredTransactionsAsync.when(
              data: (transactions) => _buildTransactionList(context, transactions, isSpecificDate: false),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.error(err.toString()))),
            ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);
  }

  Widget _buildTransactionList(BuildContext context, List<Transaction> transactions, {required bool isSpecificDate}) { 
    // Filter logic
    final typeFilteredTransactions = transactions.where((t) {
      
       // 1. Date Check
       if (isSpecificDate && specificDate != null) {
         if (t.date.year != specificDate!.year || 
             t.date.month != specificDate!.month || 
             t.date.day != specificDate!.day) {
           return false;
         }
       } else if (startDate != null && endDate != null) {
          // Range check
          if (t.date.isBefore(startDate!) || t.date.isAfter(endDate!.add(const Duration(days: 1) - const Duration(milliseconds: 1)))) {
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
              isExpense ? AppLocalizations.of(context)!.noExpensesFound : AppLocalizations.of(context)!.noIncomeFound,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
             (startDate != null && endDate != null) ? 'For this period' : AppLocalizations.of(context)!.forThisDate, // TODO: Localize
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
