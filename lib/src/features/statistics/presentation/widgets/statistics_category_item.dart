import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/domain/category.dart';
import '../../../categories/presentation/category_localization_helper.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../../../../utils/icon_helper.dart';
import '../../domain/category_data.dart';
import '../statistics_provider.dart';
import '../../../settings/presentation/icon_style_provider.dart';

class StatisticsCategoryItem extends ConsumerWidget {
  final CategoryData item;
  final Currency currency;
  final DateTime filterDate;
  final TimeRange filterTimeRange;
  final bool isExpense;

  const StatisticsCategoryItem({
    super.key,
    required this.item,
    required this.currency,
    required this.filterDate,
    required this.filterTimeRange,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconStyle = ref.watch(iconStyleProvider);
    
    return GestureDetector(
      onTap: () {
        final localizedName = CategoryLocalizationHelper.getLocalizedCategoryName(
            context,
            Category(
                name: item.categoryName,
                colorValue: item.color.value,
                iconPath: item.iconPath,
                type: isExpense ? CategoryType.expense : CategoryType.income,
                externalId: int.tryParse(item.categoryId) == null ? item.categoryId : null,
            )..id = int.tryParse(item.categoryId) ?? -1
        );
        
        context.push(
          '/statistics/category-details',
          extra: {
            'categoryId': item.categoryId,
            'categoryName': localizedName, 
            'filterDate': filterDate,
            'filterTimeRange': filterTimeRange,
            'isExpense': isExpense,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              IconHelper.getIconWithStyle(item.iconPath, iconStyle),
              color: item.color,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CategoryLocalizationHelper.getLocalizedCategoryName(
                        context,
                        Category(
                            name: item.categoryName,
                            colorValue: item.color.value, 
                            iconPath: item.iconPath,
                            type: isExpense ? CategoryType.expense : CategoryType.income,
                            externalId: int.tryParse(item.categoryId) == null ? item.categoryId : null,
                        )..id = int.tryParse(item.categoryId) ?? -1
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),

                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: LinearProgressIndicator(
                value: item.percentage / 100,
                backgroundColor: Colors.grey[100],
                color: item.color,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${item.percentage.toStringAsFixed(0)}%',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
