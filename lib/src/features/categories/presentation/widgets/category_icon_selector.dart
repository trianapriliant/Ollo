import 'package:flutter/material.dart';
import '../../../../utils/icon_helper.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';

class CategoryIconSelector extends StatefulWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;

  const CategoryIconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  State<CategoryIconSelector> createState() => _CategoryIconSelectorState();
}

class _CategoryIconSelectorState extends State<CategoryIconSelector> {
  static const Map<String, List<String>> iconGroups = {
    'Food & Drink': [
      'fastfood', 'restaurant', 'lunch_dining', 'local_cafe', 'local_bar', 'local_pizza', 'bakery_dining', 'icecream'
    ],
    'Transport': [
      'directions_bus', 'directions_car', 'local_gas_station', 'directions_bike', 'train', 'flight', 'local_taxi', 'directions_boat'
    ],
    'Shopping': [
      'shopping_bag', 'shopping_cart', 'checkroom', 'local_grocery_store', 'store', 'card_giftcard', 'receipt'
    ],
    'Entertainment': [
      'movie', 'sports_esports', 'fitness_center', 'pool', 'music_note', 'theater_comedy', 'casino'
    ],
    'Health': [
      'medical_services', 'local_hospital', 'local_pharmacy', 'healing', 'spa'
    ],
    'Education & Work': [
      'school', 'work', 'menu_book', 'science', 'computer', 'business_center'
    ],
    'Home & Utilities': [
      'home', 'lightbulb', 'water_drop', 'wifi', 'build', 'cleaning_services', 'kitchen'
    ],
    'Finance': [
      'attach_money', 'savings', 'account_balance', 'credit_card', 'trending_up', 'trending_down'
    ],
    'Other': [
      'category', 'more_horiz', 'star', 'favorite', 'pets', 'child_care', 'celebration'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Icon', style: AppTextStyles.h3),
            TextButton(
              onPressed: _showFullIconPicker,
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Simplified quick access list
              'fastfood', 'restaurant', 'local_cafe',
              'directions_bus', 'directions_car',
              'shopping_bag', 'shopping_cart',
              'movie', 'sports_esports',
              'medical_services', 'school', 'work',
              'home', 'attach_money',
            ].map((icon) => _buildIconOption(icon)).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildIconOption(String iconPath) {
    final isSelected = widget.selectedIcon == iconPath;
    return GestureDetector(
      onTap: () => widget.onIconSelected(iconPath),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppColors.primary, width: 2) : Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(
          IconHelper.getIcon(iconPath),
          color: isSelected ? AppColors.primary : Colors.grey,
        ),
      ),
    );
  }

  void _showFullIconPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Select Icon', style: AppTextStyles.h3),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: iconGroups.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            entry.key,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: entry.value.map((icon) {
                            final isSelected = widget.selectedIcon == icon;
                            return GestureDetector(
                              onTap: () {
                                widget.onIconSelected(icon);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : Colors.grey[200]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Icon(
                                  IconHelper.getIcon(icon),
                                  color: isSelected ? AppColors.primary : Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
