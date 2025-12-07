import 'package:flutter/material.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_styles.dart';

class SpendingHeatmap extends StatelessWidget {
  final List<double> dailyAmounts; // mapped by day index (0 = 1st, etc)
  final int daysInMonth;

  const SpendingHeatmap({
    super.key, 
    required this.dailyAmounts,
    required this.daysInMonth,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate max for normalization
    double maxAmount = 0;
    for (var amount in dailyAmounts) {
      if (amount > maxAmount) maxAmount = amount;
    }
    if (maxAmount == 0) maxAmount = 1; // Prevent div by zero

    // Build rows dynamically
    List<Widget> rows = [];
    int currentRowCount = 0;
    List<Widget> currentRowChildren = [];

    // Calculate cell width to fit 7 items + spacing
    // We can't know precise pixel width here easily without LayoutBuilder, 
    // but assuming standard padding, we can use Expanded.

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
                  message: 'Day $day: ${amount.toStringAsFixed(0)}',
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
        );

        currentRowCount++;

        if (currentRowCount == 7) {
            rows.add(Row(children: List.from(currentRowChildren)));
            rows.add(const SizedBox(height: 4)); // Row spacing
            currentRowChildren.clear();
            currentRowCount = 0;
        }
    }

    // Handle last row and Legend
    if (currentRowCount > 0 || rows.length < 5) {
       // If last row isn't full (currentRowCount < 7)
       // Add empty spacers matching the remaining slots minus legend space?
       // Actually, we want to put the legend in the remaining space.
       // Remaining slots = 7 - currentRowCount.
       
       // Add remaining day spacers if needed to align left?
       // No, we want the legend to float right or filling the space?
       // User said "put into available empty space".
       
       // Let's create the legend widget
       final legend = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min, // shrink to fit
            children: [
              Text('Less', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
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
              Text('More', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
            ],
       );

       // Fill the rest of the row with spacers until the last slot?
       // OR just put the legend in the remaining space.
       
       // Strategy:
       // 1. Fill `currentRowChildren` with Expanded Spacers until length is 7?
       // 2. Replace the LAST Expanded Spacer with the Legend?
       // But the Legend width is varying.
       
       // Better:
       // If we have remaining space (e.g. 3 empty slots), we can put the legend there.
       // Legend takes roughly 2-3 slots worth of width visually.
       
       // Let's explicitly fill up to 7 items.
       int emptySlots = 7 - currentRowCount;
       
       // If emptySlots is small (e.g. 1 or 0), force a new row?
       // Feb 28 days -> emptySlots = 0.
       // Feb 29 days -> emptySlots = 6.
       // 30 days -> emptySlots = 35 - 30 = 5? No. 30 % 7 = 2 rem. 5 empty.
       // 31 days -> 31 % 7 = 3 rem. 4 empty.
       
       // If emptySlots == 0 (e.g. 28 days), we MUST add a new row for legend?
       // Or just don't show it? User asked to put it in "empty space". 
       // If no empty space, logic implies new row.
       
       if (emptySlots == 0) {
          // Add the full row of days
          rows.add(Row(children: List.from(currentRowChildren)));
           currentRowChildren.clear();
          // Add new row for legend
          rows.add(const SizedBox(height: 4));
          rows.add(Row(mainAxisAlignment: MainAxisAlignment.end, children: [legend]));
       } else {
          // We have empty slots.
          // Fill (emptySlots - 1) with Spacer/Empty Container to keep alignment?
          // Actually, `currentRowChildren` are `Expanded`.
          // If we add `Expanded(child: SizedBox())` they will take space.
          
          // We want the legend to be at the END.
          // Add Spacers for (emptySlots - 1) times? 
          // And the Legend in the last slot? 
          // But Legend might be wider than 1 slot.
          
          // Let's use `Expanded(flex: emptySlots)` for a container that holds the Legend aligned to right?
          
          currentRowChildren.add(
              Expanded(
                  flex: emptySlots, // Take up all remaining width
                  child: Container(
                      margin: const EdgeInsets.all(2),
                      alignment: Alignment.centerRight,
                      child: legend,
                  ),
              )
          );
          
          rows.add(Row(children: List.from(currentRowChildren)));
       }
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
              Text('Activity Heatmap', style: AppTextStyles.h3.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }
}
