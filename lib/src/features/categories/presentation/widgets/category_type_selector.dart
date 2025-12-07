import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../domain/category.dart';

class CategoryTypeSelector extends StatelessWidget {
  final CategoryType selectedType;
  final ValueChanged<CategoryType> onTypeChanged;

  const CategoryTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildTypeChip('Expense', CategoryType.expense),
            const SizedBox(width: 12),
            _buildTypeChip('Income', CategoryType.income),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTypeChip(String label, CategoryType type) {
    final isSelected = selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onTypeChanged(type);
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }
}
