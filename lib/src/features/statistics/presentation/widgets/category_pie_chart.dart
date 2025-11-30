import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_text_styles.dart';
import '../../domain/category_data.dart';

import '../../../settings/presentation/currency_provider.dart';

class CategoryPieChart extends StatefulWidget {
  final List<CategoryData> data;
  final double totalAmount;
  final Currency currency;

  const CategoryPieChart({
    super.key,
    required this.data,
    required this.totalAmount,
    required this.currency,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2, // Reduced spacing slightly
          centerSpaceRadius: 65, // Reduced from 80
          sections: _showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 30.0 : 25.0; // Reduced from 70/60 to 30/25 for slimmer look
      final item = widget.data[i];

      return PieChartSectionData(
        color: item.color,
        value: item.amount,
        title: '', // Hide title on chart
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
