import 'package:flutter/material.dart';
import '../../../../constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class StatisticsTypeToggle extends StatelessWidget {
  final bool isExpense;
  final Function(bool isExpense) onTypeChanged;

  const StatisticsTypeToggle({
    super.key,
    required this.isExpense,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !isExpense ? Colors.green.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: !isExpense ? Border.all(color: Colors.green.withOpacity(0.5)) : null,
                ),
                child: Text(
                  AppLocalizations.of(context)!.income,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: !isExpense ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isExpense ? Colors.red.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isExpense ? Border.all(color: Colors.red.withOpacity(0.5)) : null,
                ),
                child: Text(
                   AppLocalizations.of(context)!.expense,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isExpense ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
