import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../localization/generated/app_localizations.dart';
import '../../../categories/domain/category.dart';
import '../../../categories/presentation/category_localization_helper.dart';

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
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
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
            sectionsSpace: 2,
            centerSpaceRadius: 70,
            sections: _showingSections(),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              touchedIndex == -1
                  ? AppLocalizations.of(context)!.total
                  : CategoryLocalizationHelper.getLocalizedCategoryName(
                      context,
                      Category(
                          name: widget.data[touchedIndex].categoryName,
                          colorValue: widget.data[touchedIndex].color.value,
                          iconPath: widget.data[touchedIndex].iconPath,
                          type: CategoryType.expense, // Dummy type for localization lookup
                          externalId: int.tryParse(widget.data[touchedIndex].categoryId) == null
                              ? widget.data[touchedIndex].categoryId
                              : null,
                      )..id = int.tryParse(widget.data[touchedIndex].categoryId) ?? -1
                    ),
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.currency.format(
                touchedIndex == -1 ? widget.totalAmount : widget.data[touchedIndex].amount,
              ),
              style: AppTextStyles.h3.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 35.0 : 30.0;
      final item = widget.data[i];

      return PieChartSectionData(
        color: item.color,
        value: item.amount,
        title: '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
