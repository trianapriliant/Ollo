import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_styles.dart';
import '../../extended_statistics_provider.dart';
import '../../statistics_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class ComparativeAnalysisCard extends StatelessWidget {
  final ComparativeData data;
  final bool isExpense;
  final TimeRange timeRange;

  const ComparativeAnalysisCard({
    super.key, 
    required this.data, 
    required this.isExpense,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    final isGood = isExpense ? data.percentageChange < 0 : data.percentageChange > 0;
    final color = isGood ? Colors.green : Colors.red;
    final displayIcon = data.percentageChange >= 0 ? Icons.trending_up : Icons.trending_down;

    // Dynamic title based on view
    String title;
    switch (timeRange) {
      case TimeRange.week:
        title = AppLocalizations.of(context)!.weeklyComparison;
        break;
      case TimeRange.month:
        title = AppLocalizations.of(context)!.monthlyComparison;
        break;
      case TimeRange.year:
        title = AppLocalizations.of(context)!.yearlyComparison;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(displayIcon, color: color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${data.percentageChange.abs().toStringAsFixed(1)}%',
                      style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isGood 
              ? AppLocalizations.of(context)!.spendingLessNote 
              : AppLocalizations.of(context)!.spendingMoreNote,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getInterval(),
                      getTitlesWidget: (value, meta) => _buildXAxisLabel(value, context),
                      reservedSize: 18,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Previous Period (Grey, lighter)
                  LineChartBarData(
                    spots: _generateSpots(data.previousPeriodData),
                    isCurved: true,
                    color: Colors.grey.withOpacity(0.3),
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Current Period (Color)
                  LineChartBarData(
                    spots: _generateSpots(data.currentPeriodData),
                    isCurved: true,
                    color: isExpense ? Colors.red : Colors.green,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: (isExpense ? Colors.red : Colors.green).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getInterval() {
    switch (timeRange) {
      case TimeRange.week:
        return 1; // Every day
      case TimeRange.month:
        return 10; // Every 10 days
      case TimeRange.year:
        return 1; // Every month
    }
  }

  Widget _buildXAxisLabel(double value, BuildContext context) {
    switch (timeRange) {
      case TimeRange.week:
        // For weekly: show day abbreviations
        final dayIndex = value.toInt();
        if (dayIndex < 0 || dayIndex >= 7) return const SizedBox();
        const dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            dayNames[dayIndex],
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        );
      case TimeRange.month:
        // For monthly: show day numbers
        final day = value.toInt();
        if (day != 1 && day != 10 && day != 20 && day != 30) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            day.toString(),
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        );
      case TimeRange.year:
        // For yearly: show month abbreviations
        final monthIndex = value.toInt();
        if (monthIndex < 0 || monthIndex >= 12) {
          return const SizedBox();
        }
        // Show only every 2 months to avoid overlap
        if (monthIndex % 2 != 0) {
          return const SizedBox();
        }
        final monthName = DateFormat('MMM').format(DateTime(2024, monthIndex + 1));
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            monthName,
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
        );
    }
  }

  List<FlSpot> _generateSpots(List<double> values) {
    if (values.isEmpty) return [];
    
    // Cumulative sum for trend line
    double sum = 0;
    return values.asMap().entries.map((e) {
      sum += e.value;
      return FlSpot(e.key.toDouble(), sum);
    }).toList();
  }
}
