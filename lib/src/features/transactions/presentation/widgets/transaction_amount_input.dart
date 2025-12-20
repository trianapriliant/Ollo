import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../../utils/currency_input_formatter.dart';

class TransactionAmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String currencySymbol;
  final Color primaryColor;

  final String? title;
  final bool showSign;

  const TransactionAmountInput({
    super.key,
    required this.controller,
    required this.currencySymbol,
    required this.primaryColor,
    this.title,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? AppLocalizations.of(context)!.amount, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            CurrencyInputFormatter(),
          ],
          style: AppTextStyles.amountLarge.copyWith(color: primaryColor),
          decoration: InputDecoration(
            prefixText: '$currencySymbol ',
            prefixStyle: AppTextStyles.amountLarge.copyWith(color: primaryColor),
            border: InputBorder.none,
            hintText: '0.00',
          ),
        ),
      ],
    );
  }
}
