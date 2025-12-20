import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../../settings/presentation/currency_provider.dart';

class SpendingHeatmap extends ConsumerWidget {
  final List<double> dailyAmounts;
  final int daysInMonth;
  final DateTime monthStartDate;
  final bool isExpense;

  const SpendingHeatmap({
    super.key, 
    required this.dailyAmounts, 
    required this.daysInMonth,
    required this.monthStartDate,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dailyAmounts.isEmpty) return const SizedBox();
    final currency = ref.watch(currencyProvider);

    double maxAmount = 0;
    for (var amount in dailyAmounts) {
      if (amount > maxAmount) maxAmount = amount;
    }
    if (maxAmount == 0) maxAmount = 1; // Prevent div by zero

    // Build rows dynamically
    List<Widget> rows = [];
    int currentRowCount = 0;
    List<Widget> currentRowChildren = [];

    for (int i = 0; i < daysInMonth; i++) {
        final day = i + 1;
        final amount = i < dailyAmounts.length ? dailyAmounts[i] : 0.0;
        final intensity = (amount / maxAmount).clamp(0.0, 1.0);
        
        // Gradient from Aquamarine (light) to Theme Primary (dark)
        const baseColor = Color(0xFF7FFFD4);
        final targetColor = AppColors.primary;
        final color = Color.lerp(baseColor, targetColor, intensity) ?? baseColor;

        currentRowChildren.add(
            Expanded(
              child: Tooltip(
                  message: 'Day $day: ${currency.format(amount)}',
                  child: InkWell(
                    onTap: () {
                      final specificDate = DateTime(monthStartDate.year, monthStartDate.month, day);
                       context.push(
                        '/filtered-transactions',
                        extra: {
                          'isExpense': isExpense,
                          'specificDate': specificDate,
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin: const EdgeInsets.all(2), // spacing
                        decoration: BoxDecoration(
                          color: amount > 0 ? color : Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day', 
                          style: TextStyle(
                            fontSize: 10, 
                            color: amount > 0 ? Colors.white : Colors.grey[400],
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            ),
        );

        currentRowCount++;

        if (currentRowCount == 7) {
            rows.add(Row(children: List.from(currentRowChildren)));
            rows.add(const SizedBox(height: 4)); // Row spacing
            currentRowChildren.clear();
            currentRowCount = 0;
        }
    }

    // Legend Logic for remaining space
     int emptySlots = 7 - currentRowCount;
     
     final legend = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min, 
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
     );

       if (emptySlots == 0) {
          // Row full, new line
          rows.add(Row(children: List.from(currentRowChildren)));
          rows.add(const SizedBox(height: 4));
          rows.add(Row(mainAxisAlignment: MainAxisAlignment.end, children: [legend]));
       } else {
          // Append to current row
           currentRowChildren.add(
              Expanded(
                  flex: emptySlots, 
                  child: Container(
                      margin: const EdgeInsets.all(2),
                      alignment: Alignment.centerRight,
                      child: legend,
                  ),
              )
          );
          rows.add(Row(children: List.from(currentRowChildren)));
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
              Text(AppLocalizations.of(context)!.activityHeatmap, style: AppTextStyles.h3.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }
}
