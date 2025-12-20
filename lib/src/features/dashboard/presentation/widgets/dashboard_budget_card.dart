import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../budget/data/budget_repository.dart';
import '../../../budget/domain/budget.dart';
import '../dashboard_filter_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

import '../transaction_provider.dart';

class DashboardBudgetCard extends ConsumerWidget {
  const DashboardBudgetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetListProvider);
    final filterState = ref.watch(dashboardFilterProvider);
    // Watch transactions to trigger rebuild when they change
    ref.watch(transactionListProvider);
    final currency = ref.watch(currencyProvider);

    return budgetsAsync.when(
      data: (budgets) {
        if (budgets.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<Map<String, double>>(
          future: _calculateTotals(ref, budgets, filterState),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            final data = snapshot.data!;
            final totalBudget = data['totalBudget']!;
            final totalSpent = data['totalSpent']!;
            final percentage = totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;

            String title = AppLocalizations.of(context)!.monthlyBudget;
            if (filterState.filterType == TimeFilterType.day) title = AppLocalizations.of(context)!.dailyBudget;
            if (filterState.filterType == TimeFilterType.week) title = AppLocalizations.of(context)!.weeklyBudget;
            if (filterState.filterType == TimeFilterType.year) title = AppLocalizations.of(context)!.yearlyBudget;

            return Container(
              padding: const EdgeInsets.all(12), // Reduced from 16
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: AppTextStyles.h3),
                      Text(
                        '${(percentage * 100).toStringAsFixed(0)}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: percentage > 0.8 ? Colors.red : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Reduced from 12
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage > 0.8 ? Colors.red : AppColors.primary,
                    ),
                    minHeight: 6, // Reduced from 8
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6), // Reduced from 8
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currency.format(totalSpent),
                        style: AppTextStyles.bodySmall,
                      ),
                      Text(
                        currency.format(totalBudget),
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<Map<String, double>> _calculateTotals(
    WidgetRef ref, 
    List<Budget> budgets,
    DashboardFilterState filterState,
  ) async {
    double totalBudget = 0;
    double totalSpent = 0;
    final repo = ref.read(budgetRepositoryProvider);

    // Determine date range and multiplier
    DateTime start;
    DateTime end;
    double multiplier = 1.0;
    final now = filterState.selectedDate;

    switch (filterState.filterType) {
      case TimeFilterType.day:
        start = DateTime(now.year, now.month, now.day);
        end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
        multiplier = 1 / 30; // Approx
        break;
      case TimeFilterType.week:
        start = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(start.year, start.month, start.day);
        end = start.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));
        multiplier = 1 / 4; // Approx
        break;
      case TimeFilterType.year:
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year + 1, 1, 1).subtract(const Duration(milliseconds: 1));
        multiplier = 12.0;
        break;
      case TimeFilterType.month:
      default:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(milliseconds: 1));
        multiplier = 1.0;
        break;
    }

    for (var budget in budgets) {
      // Adjust budget amount based on period vs filter
      // Assuming budget.amount is ALWAYS Monthly for now as per user request "ngaturnya tetep di monthly budget"
      // If we support other budget periods later, we need to normalize them to Monthly first.
      // For now, let's assume budget.amount is Monthly.
      
      double budgetAmount = budget.amount;
      if (budget.period == BudgetPeriod.weekly) {
        budgetAmount = budget.amount * 4; // Normalize to monthly approx
      } else if (budget.period == BudgetPeriod.yearly) {
        budgetAmount = budget.amount / 12; // Normalize to monthly
      }
      
      // Apply filter multiplier
      totalBudget += budgetAmount * multiplier;

      // Calculate spent for the specific range
      totalSpent += await repo.calculateSpentAmountForRange(budget, start, end);
    }

    return {'totalBudget': totalBudget, 'totalSpent': totalSpent};
  }
}
