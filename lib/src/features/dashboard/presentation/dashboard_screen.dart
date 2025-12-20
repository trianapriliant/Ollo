import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'widgets/main_account_card.dart';
import 'widgets/quick_record_section.dart';
import 'widgets/recent_transactions_list.dart';
import 'widgets/dashboard_filter_bar.dart';
import 'widgets/dashboard_menu_grid.dart';
import 'widgets/dashboard_budget_card.dart';
import 'dashboard_filter_provider.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../recurring/application/recurring_transaction_service.dart';
import '../../transactions/domain/transaction.dart';
import '../../home_widget/home_widget_service.dart';
import 'transaction_provider.dart';
import '../../../localization/generated/app_localizations.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger recurring transaction processing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recurringTransactionServiceFutureProvider.future).then((service) {
        service.processDueTransactions();
      });
    });
    
    // Sync Widget Data
    WidgetsBinding.instance.addPostFrameCallback((_) {
        // We use listenManual to avoid rebuilding the widget, but since we are in build/initState mix
        // We can just listen to the provider in the build method for changes.
    });
  }

  void _updateWidgetData(List<Transaction> transactions) {
     final now = DateTime.now();
     final currentMonthTransactions = transactions.where((t) {
        return t.date.year == now.year && t.date.month == now.month;
     }).toList();
     
     double income = 0;
     double expense = 0;
     
     for (var t in currentMonthTransactions) {
        if (t.type == TransactionType.income) {
            income += t.amount;
        } else if (t.type == TransactionType.expense) {
            expense += t.amount;
        }
        // Handle System transactions if needed (like Debt Income)
        // For simplicity, sticking to base types + System logic mirrored from other places could be complex.
        // Let's reuse the simple check:
        // Or better yet, just iterate and check isExpense getter?
        // But the previous complex logic handled 'System' types efficiently.
        // Let's use a simplified version:
        final isSystem = t.type == TransactionType.system;
        final isDebtIncome = isSystem && (t.title.toLowerCase().contains('borrowed') || t.title.toLowerCase().contains('received payment'));
        final isSavingsWithdraw = isSystem && t.title.toLowerCase().contains('withdraw from');
        
        if (t.type == TransactionType.income || isDebtIncome || isSavingsWithdraw) {
            if (t.type != TransactionType.income && (isDebtIncome || isSavingsWithdraw)) {
                 income += t.amount;
            }
        } else if (t.type == TransactionType.expense || (isSystem && !isDebtIncome && !isSavingsWithdraw)) {
             expense += t.amount;
        }
     }
     
     // Calculate Daily Expense for new Widget
     double todayExpense = 0;
     for (var t in transactions) {
        // Must be Expense or equivalent
        final isSystem = t.type == TransactionType.system;
        final isDebtIncome = isSystem && (t.title.toLowerCase().contains('borrowed') || t.title.toLowerCase().contains('received payment'));
        final isSavingsWithdraw = isSystem && t.title.toLowerCase().contains('withdraw from');
        
        final isExpenseOrEq = t.type == TransactionType.expense || (isSystem && !isDebtIncome && !isSavingsWithdraw);

        if (isExpenseOrEq) {
            if (t.date.year == now.year && t.date.month == now.month && t.date.day == now.day) {
                todayExpense += t.amount;
            }
        }
     }
     
     final balance = income - expense;
     
     HomeWidgetService.updateWidgetData(
        income: income,
        expense: expense,
        balance: balance,
        todayExpense: todayExpense,
     );

  }

  @override
  Widget build(BuildContext context) {
    // Listen to ALL transactions to update the widget background service
    ref.listen(transactionListProvider, (previous, next) {
        next.whenData((transactions) {
            _updateWidgetData(transactions);
        });
    });

    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: profileAsync.when(
          data: (profile) => Text(
            '~ ${AppLocalizations.of(context)!.welcome(profile.name)}',
            style: AppTextStyles.h2,
          ),
          loading: () => Text('~ ${AppLocalizations.of(context)!.welcomeSimple}', style: AppTextStyles.h2),
          error: (_, __) => Text('~ ${AppLocalizations.of(context)!.welcomeSimple}', style: AppTextStyles.h2),
        ),
        actions: [
          profileAsync.when(
            data: (profile) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.accentBlue,
                backgroundImage: profile.profileImagePath != null
                    ? FileImage(File(profile.profileImagePath!))
                    : null,
                child: profile.profileImagePath == null
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // Reduced top padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardFilterBar(),
              const SizedBox(height: 8), // Reduced from 16
              const MainAccountCard(),
              const SizedBox(height: 16),
              const DashboardMenuGrid(),
              const SizedBox(height: 16),
              const DashboardBudgetCard(),
              const SizedBox(height: 16),
              const QuickRecordSection(),
              const SizedBox(height: 16),
              transactionsAsync.when(
                data: (transactions) => RecentTransactionsList(transactions: transactions),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              const SizedBox(height: 80), // Bottom padding for scrolling
            ],
          ),
        ),
      ),
    );
  }
}
