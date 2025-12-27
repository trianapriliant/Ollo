import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../categories/domain/category.dart';
import '../../../categories/presentation/category_localization_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/settings/presentation/icon_pack_provider.dart';

import '../../../../utils/icon_helper.dart';

class SubCategorySelector extends ConsumerWidget {
  final List<SubCategory> subCategories;
  final SubCategory? selectedSubCategory;
  final Function(SubCategory) onSubCategorySelected;
  final Color color;

  const SubCategorySelector({
    super.key,
    required this.subCategories,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (subCategories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: subCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          final isSelected = selectedSubCategory?.id == subCategory.id;

          return GestureDetector(
            onTap: () => onSubCategorySelected(subCategory),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  IconHelper.getIconWidget(
                    subCategory.iconPath ?? 'category',
                    pack: ref.watch(iconPackProvider),
                    size: 18,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CategoryLocalizationHelper.getLocalizedSubCategoryName(context, subCategory),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? Colors.white : Colors.grey[800],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
