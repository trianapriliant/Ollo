import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../statistics_provider.dart';

class DailyLineChart extends StatelessWidget {
  final List<DailyData> data;

  const DailyLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Find max value for Y-axis scaling
    double maxY = 0;
    for (var item in data) {
      if (item.income > maxY) maxY = item.income;
      if (item.expense > maxY) maxY = item.expense;
    }
    maxY = maxY * 1.2; // Add buffer
    if (maxY == 0) maxY = 100;

    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
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
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5, // Show label every 5 days
                getTitlesWidget: (value, meta) {
                  final day = value.toInt();
                  if (day > 0 && day <= data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        day.toString(),
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 1,
          maxX: data.length.toDouble(),
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            // Income Line
            LineChartBarData(
              spots: data.map((e) => FlSpot(e.day.toDouble(), e.income)).toList(),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
            // Expense Line
            LineChartBarData(
              spots: data.map((e) => FlSpot(e.day.toDouble(), e.expense)).toList(),
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.blueGrey,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  if (flSpot.x == 0 || flSpot.x > data.length) return null;

                  String type = barSpot.barIndex == 0 ? 'Income' : 'Expense';
                  Color color = barSpot.barIndex == 0 ? Colors.greenAccent : Colors.redAccent;

                  return LineTooltipItem(
                    '$type\n${flSpot.y.toStringAsFixed(0)}',
                    TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
