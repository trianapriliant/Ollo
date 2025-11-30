import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../statistics_provider.dart';

class DailyStackedBarChart extends StatelessWidget {
  final List<DailyData> data;
  final Currency currency;

  const DailyStackedBarChart({
    super.key,
    required this.data,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate width based on number of days to ensure bars are readable
    // 3 bars per day * 8px width + spacing
    final double chartWidth = data.length * 50.0; 
    
    // Find max value for Y-axis scaling
    double maxY = 0;
    for (var item in data) {
      if (item.income > maxY) maxY = item.income;
      if (item.expense > maxY) maxY = item.expense;
      final savings = item.income - item.expense;
      if (savings > maxY) maxY = savings;
    }
    
    // Add some buffer
    maxY = maxY * 1.2;
    if (maxY == 0) maxY = 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Overview', style: AppTextStyles.h3),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: chartWidth < MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width : chartWidth,
            height: 220,
            padding: const EdgeInsets.only(top: 20), // Space for top tooltips
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final dayData = data[group.x.toInt() - 1];
                      String label;
                      double value;
                      Color color;
                      
                      if (rodIndex == 0) {
                        label = 'Income';
                        value = dayData.income;
                        color = const Color(0xFF4ADE80);
                      } else if (rodIndex == 1) {
                        label = 'Expense';
                        value = dayData.expense;
                        color = const Color(0xFFF87171);
                      } else {
                        label = 'Savings';
                        value = dayData.income - dayData.expense;
                        color = const Color(0xFF60A5FA);
                      }

                      return BarTooltipItem(
                        '$label\n',
                        TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: currency.format(value),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            day.toString(),
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: data.map((item) {
                  final savings = item.income - item.expense;
                  
                  return BarChartGroupData(
                    x: item.day,
                    barsSpace: 4, // Space between bars in a group
                    barRods: [
                      // Income Bar
                      BarChartRodData(
                        toY: item.income,
                        width: 8,
                        color: const Color(0xFF4ADE80), // Green
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Expense Bar
                      BarChartRodData(
                        toY: item.expense,
                        width: 8,
                        color: const Color(0xFFF87171), // Red
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Savings Bar
                      BarChartRodData(
                        toY: savings > 0 ? savings : 0,
                        width: 8,
                        color: const Color(0xFF60A5FA), // Blue
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFF4ADE80), 'Income'),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFFF87171), 'Expense'),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFF60A5FA), 'Savings'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
