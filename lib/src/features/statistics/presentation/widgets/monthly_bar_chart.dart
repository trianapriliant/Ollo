import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../statistics_provider.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<MonthlyData> data;

  const MonthlyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Find max value for Y-axis scaling
    double maxY = 0;
    for (var item in data) {
      if (item.income > maxY) maxY = item.income;
      if (item.expense > maxY) maxY = item.expense;
    }
    // Add some buffer
    maxY = maxY * 1.2;
    if (maxY == 0) maxY = 100;

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String type = rodIndex == 0 ? 'Income' : 'Expense';
                return BarTooltipItem(
                  '$type\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: rod.toY.toStringAsFixed(0),
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
                  final date = data[index].month;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MMM').format(date),
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.income,
                  color: Colors.green,
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: item.expense,
                  color: Colors.red,
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
