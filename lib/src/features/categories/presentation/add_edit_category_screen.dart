import 'package:flutter/material.dart';
import 'package:ollo/src/utils/icon_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/category_repository.dart';
import '../domain/category.dart';

class AddEditCategoryScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  final CategoryType? initialType;

  const AddEditCategoryScreen({
    super.key,
    this.categoryId,
    this.initialType,
  });

  @override
  ConsumerState<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends ConsumerState<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late CategoryType _type;
  Color _selectedColor = Colors.blue;
  String _selectedIcon = 'category';
  List<SubCategory> _subCategories = [];

  bool _isNew = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _type = widget.initialType ?? CategoryType.expense;
    
    if (widget.categoryId != null) {
      _isNew = false;
      // Load existing category data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCategory();
      });
    }
  }

  Future<void> _loadCategory() async {
    final repository = await ref.read(categoryRepositoryProvider.future);
    // In a real app, we might need a getCategoryById method. 
    // For now, we'll search in both lists.
    final expenses = await repository.getCategories(CategoryType.expense);
    final incomes = await repository.getCategories(CategoryType.income);
    
    Category? category;
    try {
      category = expenses.firstWhere((c) => c.id.toString() == widget.categoryId || c.externalId == widget.categoryId);
    } catch (_) {
      try {
        category = incomes.firstWhere((c) => c.id.toString() == widget.categoryId || c.externalId == widget.categoryId);
      } catch (_) {}
    }

    if (category != null) {
      setState(() {
        _nameController.text = category!.name;
        _type = category!.type;
        _selectedColor = category!.color;
        _selectedIcon = category!.iconPath;
        _subCategories = List.from(category!.subCategories ?? []);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = await ref.read(categoryRepositoryProvider.future);
    
    // For new categories, we don't set ID manually if using autoIncrement, 
    // but we might need externalId if we want to refer to it by string later?
    // Or just let Isar handle it.
    // However, the app logic seems to rely on passing String IDs.
    // If it's an update, we need the Isar ID (int).
    // But we only have the String ID (widget.categoryId).
    // We need to fetch the existing category to get its Isar ID.
    final category = Category(
      externalId: _isNew ? const Uuid().v4() : widget.categoryId,
      name: _nameController.text,
      iconPath: _selectedIcon,
      type: _type,
      colorValue: _selectedColor.value,
      subCategories: _subCategories,
    );

    if (_isNew) {
      await repository.addCategory(category);
    } else {
      // Find existing to get Isar ID
      final expenses = await repository.getCategories(CategoryType.expense);
      final incomes = await repository.getCategories(CategoryType.income);
      Category? existing;
      try {
        existing = expenses.firstWhere((c) => c.id.toString() == widget.categoryId || c.externalId == widget.categoryId);
      } catch (_) {
        try {
          existing = incomes.firstWhere((c) => c.id.toString() == widget.categoryId || c.externalId == widget.categoryId);
        } catch (_) {}
      }
      
      if (existing != null) {
        category.id = existing.id;
      }
      await repository.updateCategory(category);
    }
    
    // ... wait, I'll fix the logic below in a separate block or just do a quick lookup here.
    // Actually, let's just fetch it again to be safe.
    
    // Logic moved above

    if (mounted) {
      context.pop();
      // Refresh the list
      ref.refresh(categoryListProvider(_type));
    }
  }

  void _deleteCategory() async {
    if (widget.categoryId == null) return;
    
    final repository = await ref.read(categoryRepositoryProvider.future);
    
    // Need Isar ID to delete
    // Same lookup logic...
     final expenses = await repository.getCategories(CategoryType.expense);
     final incomes = await repository.getCategories(CategoryType.income);
     Category? existing;
     try {
       existing = expenses.firstWhere((c) => c.id.toString() == widget.categoryId || c.externalId == widget.categoryId);
     } catch (_) {
       try {
         existing = incomes.firstWhere((c) => c.id.toString() == widget.categoryId || c.externalId == widget.categoryId);
       } catch (_) {}
     }
     
     if (existing != null) {
       await repository.deleteCategory(existing.id);
     }
    
    if (mounted) {
      context.pop();
      ref.refresh(categoryListProvider(_type));
    }
  }

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
                // Handle bar
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
                // Header
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
                            setState(() {
                              if (isEditing) {
                                _subCategories[index!] = SubCategory(
                                  id: subCategory.id,
                                  name: nameController.text,
                                  iconPath: selectedIcon,
                                );
                              } else {
                                _subCategories.add(SubCategory(
                                  id: const Uuid().v4(),
                                  name: nameController.text,
                                  iconPath: selectedIcon,
                                ));
                              }
                            });
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
                        // Name Input
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

                        // Icon Picker
                        Text('Icon', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ...iconGroups.entries.map((entry) {
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
                              const SizedBox(height: 24),
                            ],
                          );
                        }).toList(),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(_isNew ? 'New Category' : 'Edit Category', style: AppTextStyles.h2),
        actions: [
          if (!_isNew)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Category?'),
                    content: const Text('This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteCategory();
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          TextButton(
            onPressed: _saveCategory,
            child: Text('Save', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: InputBorder.none,
                    icon: Icon(Icons.label_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                ),
              ),
              const SizedBox(height: 24),

              // Type Selector (Only if new)
              if (_isNew) ...[
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

              // Color Picker (Simplified)
              Text('Color', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
                    Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
                    Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
                    Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
                    Colors.brown, Colors.grey, Colors.blueGrey,
                  ].map((color) => _buildColorOption(color)).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Icon Picker (Simplified)
              Text('Icon', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    'fastfood', 'restaurant', 'lunch_dining', 'local_cafe',
                    'directions_bus', 'directions_car', 'local_gas_station',
                    'shopping_bag', 'shopping_cart', 'checkroom',
                    'movie', 'sports_esports', 'fitness_center',
                    'medical_services', 'school', 'work',
                    'home', 'receipt', 'attach_money', 'savings',
                  ].map((icon) => _buildIconOption(icon)).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Sub-Categories
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
              if (_subCategories.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No sub-categories', style: TextStyle(color: Colors.grey)),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _subCategories.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final sub = _subCategories[index];
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
                              setState(() {
                                _subCategories.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, CategoryType type) {
    final isSelected = _type == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _type = type);
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = _selectedColor.value == color.value;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }

  Widget _buildIconOption(String iconPath) {
    final isSelected = _selectedIcon == iconPath;
    return GestureDetector(
      onTap: () => setState(() => _selectedIcon = iconPath),
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

  // Removed local _getIconData in favor of IconHelper.getIcon
}
