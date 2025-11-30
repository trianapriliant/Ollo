import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../data/budget_repository.dart';
import '../../domain/budget.dart';

class BudgetSummaryCard extends ConsumerWidget {
  const BudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetListProvider);

    return budgetsAsync.when(
      data: (budgets) {
        if (budgets.isEmpty) return const SizedBox.shrink();
        
        // Calculate totals
        // This is a bit heavy for build, ideally move to a provider
        return FutureBuilder<Map<String, double>>(
          future: _calculateTotals(ref, budgets),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            
            final data = snapshot.data!;
            final totalBudget = data['totalBudget']!;
            final totalSpent = data['totalSpent']!;
            final remaining = totalBudget - totalSpent;
            final percentage = (totalSpent / totalBudget).clamp(0.0, 1.0);

            return Container(
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
                            'Rp ${remaining < 0 ? 0 : remaining.toStringAsFixed(0)}',
                            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                          ),
                          Text(
                            'More Today', // Simplified text
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
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            startDegreeOffset: 180,
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                color: AppColors.primary,
                                value: percentage * 100,
                                title: '',
                                radius: 20,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: AppColors.primary.withOpacity(0.1),
                                value: (1 - percentage) * 100,
                                title: '',
                                radius: 20,
                                showTitle: false,
                              ),
                              // Invisible section to make it a semi-circle
                              PieChartSectionData(
                                color: Colors.transparent,
                                value: 100,
                                title: '',
                                radius: 20,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20), // Adjust based on semi-circle
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${(percentage * 100).toStringAsFixed(0)}%',
                                  style: AppTextStyles.h1,
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rp ${totalSpent.toStringAsFixed(0)}',
                        style: AppTextStyles.h3,
                      ),
                      Text(
                        ' / Rp ${totalBudget.toStringAsFixed(0)}',
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
      loading: () => const SizedBox.shrink(),
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
