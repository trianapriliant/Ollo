import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../utils/icon_helper.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../domain/category.dart';

class SubCategoryManager extends StatefulWidget {
  final List<SubCategory> subCategories;
  final ValueChanged<List<SubCategory>> onSubCategoriesChanged;

  const SubCategoryManager({
    super.key,
    required this.subCategories,
    required this.onSubCategoriesChanged,
  });

  @override
  State<SubCategoryManager> createState() => _SubCategoryManagerState();
}

class _SubCategoryManagerState extends State<SubCategoryManager> {
  // We need a local copy to manipulate? 
  // Ideally, we just pass changes up.
  // But for the modal, we need to add/edit.



  // Re-using the full list from previous file would be better, 
  // but to keep this widget self-contained I'll include a decent set.
  static const List<String> commonIcons = [
    'fastfood', 'restaurant', 'lunch_dining', 'local_cafe', 
    'directions_bus', 'directions_car', 'local_gas_station', 
    'shopping_bag', 'shopping_cart', 
    'movie', 'sports_esports', 'fitness_center', 
    'medical_services', 'school', 'work', 
    'home', 'lightbulb', 'water_drop', 'wifi',
    'category', 'more_horiz', 'star', 'favorite'
  ];

  void _showSubCategoryEditor({SubCategory? subCategory, int? index}) {
    final isEditing = subCategory != null;
    final nameController = TextEditingController(text: isEditing ? subCategory.name : '');
    String selectedIcon = isEditing ? (subCategory.iconPath ?? 'category') : 'category';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'Edit Sub-Category' : 'New Sub-Category',
                        style: AppTextStyles.h3,
                      ),
                      TextButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            final newList = List<SubCategory>.from(widget.subCategories);
                            
                            if (isEditing) {
                              newList[index!] = SubCategory(
                                id: subCategory.id,
                                name: nameController.text,
                                iconPath: selectedIcon,
                              );
                            } else {
                              newList.add(SubCategory(
                                id: const Uuid().v4(),
                                name: nameController.text,
                                iconPath: selectedIcon,
                              ));
                            }
                            
                            widget.onSubCategoriesChanged(newList);
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Breakfast',
                              border: InputBorder.none,
                            ),
                            autofocus: !isEditing,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text('Icon', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: commonIcons.map((icon) {
                            final isSelected = selectedIcon == icon;
                            return GestureDetector(
                              onTap: () => setModalState(() => selectedIcon = icon),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sub-Categories', style: AppTextStyles.h3),
            IconButton(
              onPressed: () => _showSubCategoryEditor(),
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            ),
          ],
        ),
        if (widget.subCategories.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No sub-categories', style: TextStyle(color: Colors.grey)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.subCategories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final sub = widget.subCategories[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    IconHelper.getIcon(sub.iconPath ?? 'category'),
                    size: 16,
                    color: Colors.grey[700],
                  ),
                ),
                title: Text(sub.name ?? 'Unknown'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                      onPressed: () => _showSubCategoryEditor(subCategory: sub, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                      onPressed: () {
                         final newList = List<SubCategory>.from(widget.subCategories);
                         newList.removeAt(index);
                         widget.onSubCategoriesChanged(newList);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
