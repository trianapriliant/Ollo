import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_styles.dart';
import '../../extended_statistics_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class ComparativeAnalysisCard extends StatelessWidget {
  final ComparativeData data;
  final bool isExpense;

  const ComparativeAnalysisCard({super.key, required this.data, required this.isExpense});

  @override
  Widget build(BuildContext context) {
    final isGood = isExpense ? data.percentageChange < 0 : data.percentageChange > 0;
    final color = isGood ? Colors.green : Colors.red;
    final icon = isGood ? Icons.trending_down : Icons.trending_up; // Typically down is good for expense
    
    // Adjust icon logic: trending_up is literally up arrow. 
    // If expense and up (bad), use trending_up (red). 
    // If expense and down (good), use trending_down (green).
    // If income and up (good), use trending_up (green).
    // If income and down (bad), use trending_down (red).
    final displayIcon = data.percentageChange >= 0 ? Icons.trending_up : Icons.trending_down;

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
              Text(AppLocalizations.of(context)!.monthlyComparison, style: AppTextStyles.h3.copyWith(fontSize: 16)),
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
                      interval: 5, // Show label every 5 days
                      getTitlesWidget: (value, meta) {
                         if (value == 0 || value > 31) return const SizedBox();
                         return Padding(
                           padding: const EdgeInsets.only(top: 4),
                           child: Text(
                             value.toInt().toString(),
                             style: const TextStyle(fontSize: 10, color: Colors.grey),
                           ),
                         );
                      },
                      reservedSize: 20,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Previous Month (Grey, Dashed or lighter)
                  LineChartBarData(
                    spots: _generateSpots(data.previousPeriodData),
                    isCurved: true,
                    color: Colors.grey.withOpacity(0.3),
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Current Month (Color)
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

  List<FlSpot> _generateSpots(List<double> values) {
    if (values.isEmpty) return [];
    
    // Accumulate sum for "Area" effect or just daily values?
    // Sparklines usually show trend of value over time. 
    // Since this is "Comparison", let's show CUMULATIVE spending to see where we deviate?
    // OR just daily spikes. Cumulative is smoother and often more meaningful for "Am I ahead of schedule?".
    // Let's try Cumulative.
    
    double sum = 0;
    return values.asMap().entries.map((e) {
      sum += e.value;
      return FlSpot(e.key.toDouble(), sum);
    }).toList();
  }
}
