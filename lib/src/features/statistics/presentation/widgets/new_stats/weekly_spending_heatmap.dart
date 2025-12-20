import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../statistics_provider.dart';

class WeeklySpendingHeatmap extends StatelessWidget {
  final List<WeeklyData> weeklyData;
  final bool isExpense;

  const WeeklySpendingHeatmap({
    super.key, 
    required this.weeklyData, 
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyData.isEmpty) return const SizedBox();

    double maxAmount = 0;
    for (var item in weeklyData) {
      if (item.amount > maxAmount) maxAmount = item.amount;
    }
    if (maxAmount == 0) maxAmount = 1; // Prevent div by zero

    // Build rows of 10
    List<Widget> rows = [];
    List<Widget> currentRowChildren = [];
    int itemsInRow = 0;

    for (int i = 0; i < weeklyData.length; i++) {
        final data = weeklyData[i];
        final intensity = (data.amount / maxAmount).clamp(0.0, 1.0);
        
        const baseColor = Color(0xFF7FFFD4);
        final targetColor = AppColors.primary;
        final color = Color.lerp(baseColor, targetColor, intensity) ?? baseColor;

        currentRowChildren.add(
            Expanded(
              child: Tooltip(
                message: 'Week ${data.week}: ${data.amount.toStringAsFixed(0)}',
                child: InkWell(
                  onTap: () {
                    context.push(
                      '/filtered-transactions', 
                      extra: {
                        'isExpense': isExpense,
                        'startDate': data.startDate,
                        'endDate': data.endDate,
                      }
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: data.amount > 0 ? color : Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${data.week}',
                        style: TextStyle(
                          fontSize: 8,
                          color: data.amount > 0 ? Colors.white : Colors.grey[400],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
        );
        itemsInRow++;

        if (itemsInRow == 10) {
            rows.add(Row(children: List.from(currentRowChildren)));
            rows.add(const SizedBox(height: 4));
            currentRowChildren.clear();
            itemsInRow = 0;
        }
    }

    // Handle last incomplete row
    if (currentRowChildren.isNotEmpty) {
        // Fill remaining slots with empty sized boxes to maintain aspect ratio/width
        while (itemsInRow < 10) {
           currentRowChildren.add(const Expanded(child: SizedBox()));
           itemsInRow++;
        }
        rows.add(Row(children: currentRowChildren));
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
              Text(AppLocalizations.of(context)!.weeklyActivityHeatmap, style: AppTextStyles.h3.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          ...rows,
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppLocalizations.of(context)!.less, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
              const SizedBox(width: 4),
              ...List.generate(5, (index) {
                const baseColor = Color(0xFF7FFFD4);
                final targetColor = AppColors.primary;
                final intensity = index / 4;
                final color = Color.lerp(baseColor, targetColor, intensity) ?? baseColor;
                
                return Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
              const SizedBox(width: 4),
              Text(AppLocalizations.of(context)!.more, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
