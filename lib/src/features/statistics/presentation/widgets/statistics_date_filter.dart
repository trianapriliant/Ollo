import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_text_styles.dart';
import '../statistics_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class StatisticsDateFilter extends StatelessWidget {
  final DateTime selectedDate;
  final TimeRange timeRange;
  final Function(int offset) onDateChanged;
  final Function(TimeRange range) onRangeChanged;

  const StatisticsDateFilter({
    super.key,
    required this.selectedDate,
    required this.timeRange,
    required this.onDateChanged,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toggle Week/Month/Year
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleBtn(AppLocalizations.of(context)!.weekly, TimeRange.week),
              _buildToggleBtn(AppLocalizations.of(context)!.monthly, TimeRange.month),
              _buildToggleBtn(AppLocalizations.of(context)!.yearly, TimeRange.year),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Date Scroller
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => onDateChanged(-1),
            ),
            Text(
              _formatDate(context, selectedDate),
              style: AppTextStyles.h3,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onDateChanged(1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleBtn(String label, TimeRange range) {
    final isSelected = timeRange == range;
    return GestureDetector(
      onTap: () => onRangeChanged(range),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    
    if (timeRange == TimeRange.week) {
      // Get Monday and Sunday of the week
      final weekday = date.weekday;
      final monday = date.subtract(Duration(days: weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      
      // Format as "Dec 23 - 29" or "Dec 30 - Jan 5" if cross-month
      if (monday.month == sunday.month) {
        return '${DateFormat('MMM d', locale).format(monday)} - ${DateFormat('d', locale).format(sunday)}';
      } else {
        return '${DateFormat('MMM d', locale).format(monday)} - ${DateFormat('MMM d', locale).format(sunday)}';
      }
    } else if (timeRange == TimeRange.month) {
      return DateFormat('MMMM y', locale).format(date);
    } else {
      return '${date.year}';
    }
  }
}
