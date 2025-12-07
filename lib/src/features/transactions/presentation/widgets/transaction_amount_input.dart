import 'package:flutter/material.dart';
import '../../../../constants/app_text_styles.dart';

class TransactionAmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String currencySymbol;
  final Color primaryColor;

  const TransactionAmountInput({
    super.key,
    required this.controller,
    required this.currencySymbol,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
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
