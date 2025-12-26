import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../data/budget_repository.dart';
import '../../domain/budget.dart';

import '../../../dashboard/presentation/transaction_provider.dart';

class BudgetSummaryCard extends ConsumerWidget {
  const BudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetListProvider);
    // Watch transactions to trigger rebuild when they change
    ref.watch(transactionListProvider);

    return budgetsAsync.when(
      data: (budgets) {
        // Always calculate totals, even if empty
        return FutureBuilder<Map<String, double>>(
          future: _calculateTotals(ref, budgets),
          builder: (context, snapshot) {
            // Show loading or default 0s if waiting
            final data = snapshot.data ?? {'totalBudget': 0.0, 'totalSpent': 0.0};
            final totalBudget = data['totalBudget']!;
            final totalSpent = data['totalSpent']!;
            final remaining = totalBudget - totalSpent;
            // Avoid division by zero
            final percentage = totalBudget > 0 
                ? (totalSpent / totalBudget).clamp(0.0, 1.0) 
                : 0.0;

            return Container(
              // Removed fixed height: 320
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Wrap content
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You can Spend',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(remaining < 0 ? 0 : remaining),
                            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                          ),
                          Text(
                            'More This Month',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: remaining >= 0 ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              remaining >= 0 ? Icons.check_circle : Icons.warning,
                              size: 16,
                              color: remaining >= 0 ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              remaining >= 0 ? 'Normal' : 'Over',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: remaining >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12), // Reduced from 24
                  SizedBox(
                    height: 100, // Reduced from 150
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PieChart(
                          PieChartData(
                            startDegreeOffset: 180,
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 35, // Slightly reduced from 40 to fit better
                            sections: [
                              PieChartSectionData(
                                color: AppColors.primary,
                                value: percentage * 100,
                                title: '',
                                radius: 15, // Reduced from 20
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: AppColors.primary.withOpacity(0.1),
                                value: (1 - percentage) * 100,
                                title: '',
                                radius: 15, // Reduced from 20
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: Colors.transparent,
                                value: 100,
                                title: '',
                                radius: 15, // Reduced from 20
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10), // Adjusted padding
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${(percentage * 100).toStringAsFixed(0)}%',
                                  style: AppTextStyles.h1.copyWith(fontSize: 28), // Slightly smaller font
                                ),
                                Text(
                                  'Used',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 0), // Reduced from 8
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(totalSpent),
                        style: AppTextStyles.h3,
                      ),
                      Text(
                        ' / ${NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(totalBudget)}',
                        style: AppTextStyles.h3.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(), // Keep loading hidden or show skeleton
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<Map<String, double>> _calculateTotals(WidgetRef ref, List<Budget> budgets) async {
    double totalBudget = 0;
    double totalSpent = 0;
    final repo = ref.read(budgetRepositoryProvider);

    for (var budget in budgets) {
      totalBudget += budget.amount;
      totalSpent += await repo.calculateSpentAmount(budget);
    }

    return {'totalBudget': totalBudget, 'totalSpent': totalSpent};
  }
}
