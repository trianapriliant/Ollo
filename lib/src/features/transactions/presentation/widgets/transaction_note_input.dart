import 'package:flutter/material.dart';
import '../../../../constants/app_text_styles.dart';

class TransactionNoteInput extends StatelessWidget {
  final TextEditingController controller;

  const TransactionNoteInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Add a note...',
            hintStyle: AppTextStyles.bodyMedium,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
