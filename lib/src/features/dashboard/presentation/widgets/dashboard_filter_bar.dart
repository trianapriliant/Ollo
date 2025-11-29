import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../dashboard_filter_provider.dart';

class DashboardFilterBar extends ConsumerWidget {
  const DashboardFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(dashboardFilterProvider);

    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterTab(context, ref, 'Day', TimeFilterType.day, filterState.filterType),
          _buildFilterTab(context, ref, 'Month', TimeFilterType.month, filterState.filterType),
          _buildFilterTab(context, ref, 'Year', TimeFilterType.year, filterState.filterType),
          _buildFilterTab(context, ref, 'All', TimeFilterType.all, filterState.filterType),
          _buildFilterTab(context, ref, 'Custom', TimeFilterType.custom, filterState.filterType),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    BuildContext context,
    WidgetRef ref,
    String label,
    TimeFilterType type,
    TimeFilterType currentType,
  ) {
    final isSelected = type == currentType;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (type == TimeFilterType.custom) {
            _showCustomRangePicker(context, ref);
          } else {
            ref.read(dashboardFilterProvider.notifier).setFilterType(type);
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCustomRangePicker(BuildContext context, WidgetRef ref) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
    
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      ref.read(dashboardFilterProvider.notifier).setCustomRange(pickedRange);
    }
  }
}
