import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../categories/domain/category.dart';

class SubCategorySelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                  Icon(
                    _getIconData(subCategory.iconPath),
                    size: 18,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subCategory.name,
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

  IconData _getIconData(String iconPath) {
    switch (iconPath) {
      case 'bakery_dining': return Icons.bakery_dining;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'dinner_dining': return Icons.dinner_dining;
      case 'icecream': return Icons.icecream;
      case 'coffee': return Icons.coffee;
      case 'directions_bus': return Icons.directions_bus;
      case 'train': return Icons.train;
      case 'local_taxi': return Icons.local_taxi;
      case 'local_gas_station': return Icons.local_gas_station;
      case 'checkroom': return Icons.checkroom;
      case 'devices': return Icons.devices;
      case 'local_grocery_store': return Icons.local_grocery_store;
      case 'movie': return Icons.movie;
      case 'sports_esports': return Icons.sports_esports;
      case 'live_tv': return Icons.live_tv;
      case 'event': return Icons.event;
      case 'medical_services': return Icons.medical_services;
      case 'local_pharmacy': return Icons.local_pharmacy;
      case 'fitness_center': return Icons.fitness_center;
      case 'menu_book': return Icons.menu_book;
      case 'school': return Icons.school;
      case 'lightbulb': return Icons.lightbulb;
      case 'water_drop': return Icons.water_drop;
      case 'wifi': return Icons.wifi;
      case 'home': return Icons.home;
      case 'volunteer_activism': return Icons.volunteer_activism;
      case 'more_horiz': return Icons.more_horiz;
      case 'calendar_today': return Icons.calendar_today;
      case 'star': return Icons.star;
      case 'sell': return Icons.sell;
      case 'design_services': return Icons.design_services;
      case 'cake': return Icons.cake;
      case 'celebration': return Icons.celebration;
      case 'pie_chart': return Icons.pie_chart;
      case 'currency_bitcoin': return Icons.currency_bitcoin;
      case 'replay': return Icons.replay;
      default: return Icons.category;
    }
  }
}
