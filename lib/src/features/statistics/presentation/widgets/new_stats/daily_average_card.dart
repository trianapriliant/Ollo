import 'package:flutter/material.dart';
import '../../../../../constants/app_text_styles.dart';
import '../../../../settings/presentation/currency_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class DailyAverageCard extends StatelessWidget {
  final double average;
  final double projected;
  final Currency currency;
  final bool isExpense;

  const DailyAverageCard({
    super.key, 
    required this.average, 
    required this.projected, 
    required this.currency,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.dailyAverage, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      currency.format(average),
                      style: AppTextStyles.h3.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey[200]),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(AppLocalizations.of(context)!.projectedTotal, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      currency.format(projected),
                      style: AppTextStyles.h3.copyWith(fontSize: 20, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.spendingHabitsNote,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.blue[800]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
