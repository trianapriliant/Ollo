import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../domain/category_data.dart';
import 'statistics_provider.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/monthly_bar_chart.dart';
import 'widgets/daily_line_chart.dart';
import 'widgets/insight_card.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  bool _isExpense = true;

  @override
  Widget build(BuildContext context) {
    final statisticsAsync = ref.watch(statisticsProvider(_isExpense));
    final currencySymbol = ref.watch(currencyProvider).symbol;

    final monthlyStatsAsync = ref.watch(monthlyStatisticsProvider);
    final dailyStatsAsync = ref.watch(dailyStatisticsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Statistics', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 0. Key Insights (This Month)
              if (monthlyStatsAsync.valueOrNull != null && monthlyStatsAsync.valueOrNull!.isNotEmpty) ...[
                Builder(
                  builder: (context) {
                    final currentMonth = monthlyStatsAsync.valueOrNull!.last;
                    return Row(
                      children: [
                        Expanded(
                          child: InsightCard(
                            title: 'Income',
                            value: '${currencySymbol} ${currentMonth.income.toStringAsFixed(0)}',
                            icon: Icons.arrow_downward,
                            color: Colors.green,
                            subtitle: 'This Month',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InsightCard(
                            title: 'Expense',
                            value: '${currencySymbol} ${currentMonth.expense.toStringAsFixed(0)}',
                            icon: Icons.arrow_upward,
                            color: Colors.red,
                            subtitle: 'This Month',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],

              // 1. Monthly Trends (Bar Chart)
              Text('Monthly Trends', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: monthlyStatsAsync.when(
                  data: (data) => MonthlyBarChart(data: data),
                  loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                  error: (err, _) => Text('Error: $err'),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Daily Trends (Line Chart)
              Text('Daily Trends (This Month)', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: dailyStatsAsync.when(
                  data: (data) => DailyLineChart(data: data),
                  loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                  error: (err, _) => Text('Error: $err'),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Category Breakdown (Donut Chart)
              Text('Category Breakdown', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              
              // Toggle Button (Income / Expense)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isExpense ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Expense',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: _isExpense ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isExpense ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Income',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: !_isExpense ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Chart & List
              statisticsAsync.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              "No data available",
                              style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final totalAmount = data.fold(0.0, (sum, item) => sum + item.amount);

                  return Column(
                    children: [
                      CategoryPieChart(
                        data: data,
                        totalAmount: totalAmount,
                        currencySymbol: currencySymbol,
                      ),
                      const SizedBox(height: 32),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return _buildCategoryItem(item, currencySymbol);
                        },
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryData item, String currencySymbol) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconData(item.iconPath),
              color: item.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.categoryName, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: item.percentage / 100,
                  backgroundColor: Colors.grey[100],
                  color: item.color,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$currencySymbol ${item.amount.toStringAsFixed(0)}',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${item.percentage.toStringAsFixed(1)}%',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconPath) {
    // Duplicate logic from AddTransactionScreen, ideally should be in a shared utility
    switch (iconPath) {
      case 'fastfood': return Icons.fastfood;
      case 'directions_bus': return Icons.directions_bus;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'movie': return Icons.movie;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'receipt': return Icons.receipt;
      case 'attach_money': return Icons.attach_money;
      case 'store': return Icons.store;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'trending_up': return Icons.trending_up;
      default: return Icons.category;
    }
  }
}
