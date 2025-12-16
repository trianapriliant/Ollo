import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../dashboard_filter_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

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
          _buildFilterTab(context, ref, AppLocalizations.of(context)!.filterDay, TimeFilterType.day, filterState.filterType),
          _buildFilterTab(context, ref, AppLocalizations.of(context)!.filterWeek, TimeFilterType.week, filterState.filterType),
          _buildFilterTab(context, ref, AppLocalizations.of(context)!.filterMonth, TimeFilterType.month, filterState.filterType),
          _buildFilterTab(context, ref, AppLocalizations.of(context)!.filterYear, TimeFilterType.year, filterState.filterType),
          _buildFilterTab(context, ref, AppLocalizations.of(context)!.filterAll, TimeFilterType.all, filterState.filterType),
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
          ref.read(dashboardFilterProvider.notifier).setFilterType(type);
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
}
