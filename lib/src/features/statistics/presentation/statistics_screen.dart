import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import 'statistics_provider.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/monthly_bar_chart.dart';
import 'widgets/insight_card.dart';
import 'widgets/daily_stacked_bar_chart.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

import 'dart:ui';
import 'package:go_router/go_router.dart';

import 'extended_statistics_provider.dart';
import 'widgets/new_stats/comparative_analysis_card.dart';
import 'widgets/new_stats/top_spenders_card.dart';
import 'widgets/new_stats/daily_average_card.dart';
import 'widgets/new_stats/spending_heatmap.dart';
import 'widgets/new_stats/weekly_spending_heatmap.dart';

import 'widgets/statistics_category_item.dart';
import 'widgets/statistics_date_filter.dart';
import 'widgets/statistics_type_toggle.dart';
import 'widgets/transaction_table_preview.dart';
import '../../subscription/presentation/premium_provider.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  bool _isExpense = true;
  TimeRange _timeRange = TimeRange.month;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);
    final isVip = ref.watch(isVipProvider);
    final hasPremiumAccess = isPremium || isVip;
    final statisticsAsync = ref.watch(statisticsProvider(StatisticsFilter(isExpense: _isExpense, timeRange: _timeRange, date: _selectedDate)));
    final insightAsync = ref.watch(insightProvider(StatisticsFilter(isExpense: _isExpense, timeRange: _timeRange, date: _selectedDate)));
    final currency = ref.watch(currencyProvider);

    final monthlyStatsAsync = ref.watch(monthlyStatisticsProvider(_selectedDate));
    final dailyStatsAsync = ref.watch(dailyStatisticsProvider(_selectedDate));
    final weeklyStatsAsync = ref.watch(weeklyStatisticsProvider(StatisticsFilter(isExpense: _isExpense, timeRange: _timeRange, date: _selectedDate)));

    final comparativeAsync = ref.watch(comparativeStatisticsProvider(StatisticsFilter(isExpense: _isExpense, timeRange: _timeRange, date: _selectedDate)));
    final topSpendersAsync = ref.watch(topMerchantsProvider(StatisticsFilter(isExpense: _isExpense, timeRange: _timeRange, date: _selectedDate)));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.statistics, style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Date Navigation & Toggle
              StatisticsDateFilter(
                selectedDate: _selectedDate,
                timeRange: _timeRange,
                onDateChanged: _changeDate,
                onRangeChanged: (range) => setState(() => _timeRange = range),
              ),
              const SizedBox(height: 12),

              // 2. Insight Card
              insightAsync.when(
                data: (insight) {
                  if (insight == null) return const SizedBox();
                  return InsightCard(
                    message: insight.message,
                    isGood: insight.isGood,
                    percentage: insight.percentageChange,
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
              const SizedBox(height: 12),

              // 3. Income/Expense Toggle
              StatisticsTypeToggle(
                isExpense: _isExpense,
                onTypeChanged: (val) => setState(() => _isExpense = val),
              ),
              const SizedBox(height: 16),

              // 4. Pie Chart Section
              statisticsAsync.when(
                data: (data) {
                  final totalAmount = data.fold(0.0, (sum, item) => sum + item.amount);
                  return Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: CategoryPieChart(
                          key: ValueKey('$_selectedDate-$_timeRange-$_isExpense'), // Force rebuild on filter change
                          data: data,
                          totalAmount: totalAmount,
                          currency: currency,
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(height: 250, child: Center(child: CircularProgressIndicator())),
                error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.error(err.toString()))),
              ),
              
              const SizedBox(height: 16),

              // 5. Category List
              statisticsAsync.when(
                data: (data) {
                  if (data.isEmpty) return Center(child: Text(AppLocalizations.of(context)!.noDataForPeriod));
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return StatisticsCategoryItem(
                        item: item,
                        currency: currency,
                        filterDate: _selectedDate,
                        filterTimeRange: _timeRange,
                        isExpense: _isExpense,
                      );
                    },
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
              
              const SizedBox(height: 16),

              // 6. Trend Chart Section
              if (_timeRange == TimeRange.month)
                dailyStatsAsync.when(
                  data: (data) {
                    if (data.isEmpty) return const SizedBox();
                    
                    // Calculate Averages
                    double totalIncome = 0;
                    double totalExpense = 0;
                    double totalSavings = 0;
                    
                    final now = DateTime.now();
                    final isCurrentMonth = _selectedDate.year == now.year && _selectedDate.month == now.month;
                    
                    // If current month, use days passed so far. Otherwise use total days in month (data.length).
                    int daysToCount = isCurrentMonth ? now.day : data.length;
                    if (daysToCount == 0) daysToCount = 1; // Prevent division by zero

                    for (var day in data) {
                      // Only include data up to the count day if it's current month (optional, but safer)
                      if (day.day <= daysToCount) {
                        totalIncome += day.income;
                        totalExpense += day.expense;
                        totalSavings += day.savings;
                      }
                    }
                    
                    final avgIncome = totalIncome / daysToCount;
                    final avgExpense = totalExpense / daysToCount;
                    final avgSavings = totalSavings / daysToCount;

                    return DailyStackedBarChart(
                      data: data,
                      currency: currency,
                      avgIncome: avgIncome,
                      avgExpense: avgExpense,
                      avgSavings: avgSavings,
                      selectedDate: _selectedDate,
                    );
                  },
                  loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                  error: (_, __) => const SizedBox(),
                )
              else
                monthlyStatsAsync.when(
                  data: (data) {
                    if (data.isEmpty) return const SizedBox();
                    
                    // Calculate Averages
                    double totalIncome = 0;
                    double totalExpense = 0;

                    for (var month in data) {
                      totalIncome += month.income;
                      totalExpense += month.expense;
                    }
                    
                    final now = DateTime.now();
                    int divisor;
                    
                    if (_selectedDate.year == now.year) {
                      // For current year, divide by months passed so far
                      divisor = now.month;
                    } else if (_selectedDate.year < now.year) {
                      // For past years, divide by 12
                      divisor = 12;
                    } else {
                      // Future years (shouldn't happen with data, but safe fallback)
                      divisor = 1;
                    }
                    
                    // Avoid division by zero
                    if (divisor == 0) divisor = 1;

                    final avgIncome = totalIncome / divisor;
                    final avgExpense = totalExpense / divisor;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.dailyOverview, style: AppTextStyles.h3),
                        const SizedBox(height: 16),
                        MonthlyBarChart(
                          data: data,
                          avgIncome: avgIncome,
                          avgExpense: avgExpense,
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                  error: (_, __) => const SizedBox(),
                ),

              const SizedBox(height: 24),
              
              // 7. Comparative Analysis (Premium Feature)
              _PremiumLock(
                isLocked: !hasPremiumAccess,
                onUnlock: () => context.push('/premium'),
                child: comparativeAsync.when(
                  data: (data) {
                    if (data == null) return const SizedBox();
                    return ComparativeAnalysisCard(data: data, isExpense: _isExpense);
                  }, 
                  loading: () => const SizedBox(), 
                  error: (_,__) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 16),

              // 8. Daily Average & Projection (Reuse dailyStatsAsync)
              // Only relevant per month
              if (_timeRange == TimeRange.month)
                dailyStatsAsync.when(
                  data: (data) {
                    if (data.isEmpty) return const SizedBox();
                    
                    double total = 0;
                    for(var day in data) {
                        // Logic similar to existing chart calculation
                        if(_isExpense) {
                          total += day.expense;
                        } else {
                          total += day.income;
                        }
                    }

                    final now = DateTime.now();
                    final isCurrentMonth = _selectedDate.year == now.year && _selectedDate.month == now.month;
                    // Days passed so far or total days in closed month
                    int daysPassed = isCurrentMonth ? now.day : data.length;
                    if (daysPassed == 0) daysPassed = 1;

                    final avg = total / daysPassed;
                    final projected = avg * data.length; // Projected for full month

                    final dailyAmounts = data.map((d) => _isExpense ? d.expense : d.income).toList();
                    final daysInMonth = data.length;

                    return Column(
                      children: [
                        DailyAverageCard(
                          key: ValueKey('DailyAvg-$_selectedDate'),
                          average: avg, 
                          projected: projected, 
                          currency: currency, 
                          isExpense: _isExpense
                        ),
                        const SizedBox(height: 16),
                        SpendingHeatmap(
                          key: ValueKey('Heatmap-$_selectedDate'),
                          dailyAmounts: dailyAmounts, 
                          daysInMonth: daysInMonth,
                          monthStartDate: DateTime(_selectedDate.year, _selectedDate.month, 1),
                          isExpense: _isExpense,
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(), 
                  error: (_,__) => const SizedBox(),
                )
              else if (_timeRange == TimeRange.year)
                weeklyStatsAsync.when(
                  data: (data) {
                    if (data.isEmpty) return const SizedBox();
                    return WeeklySpendingHeatmap(
                      weeklyData: data,
                      isExpense: _isExpense,
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),

              const SizedBox(height: 16),

              // 9. Top Spenders
              topSpendersAsync.when(
                data: (data) => TopSpendersCard(
                  key: ValueKey('TopSpenders-$_selectedDate'),
                  data: data, 
                  currency: currency
                ),
                loading: () => const SizedBox(),
                error: (e,s) => Text(AppLocalizations.of(context)!.error(e.toString())),
              ),

              const SizedBox(height: 24),

              // 10. Transaction Log
              const TransactionTablePreview(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  void _changeDate(int offset) {
    setState(() {
      if (_timeRange == TimeRange.month) {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + offset, 1);
      } else {
        _selectedDate = DateTime(_selectedDate.year + offset, 1, 1);
      }
    });
  }
}

class _PremiumLock extends StatelessWidget {
  final Widget child;
  final bool isLocked;
  final VoidCallback onUnlock;

  const _PremiumLock({
    required this.child,
    required this.isLocked,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) return child;

    return Stack(
      children: [
        // Blurred Child
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AbsorbPointer(child: child), // Prevent interaction
        ),
        // Lock Overlay
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.01), // Transparent overlay to catch taps if needed, but AbsorbPointer handles it
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.lock, color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onUnlock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.unlockPremiumStats),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
