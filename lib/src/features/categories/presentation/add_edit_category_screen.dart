import 'package:flutter/material.dart';
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
      // Check externalId or id.toString()
      category = expenses.firstWhere((c) => (c.externalId ?? c.id.toString()) == widget.categoryId);
    } catch (_) {
      try {
        category = incomes.firstWhere((c) => (c.externalId ?? c.id.toString()) == widget.categoryId);
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
        existing = expenses.firstWhere((c) => (c.externalId ?? c.id.toString()) == widget.categoryId);
      } catch (_) {
        try {
          existing = incomes.firstWhere((c) => (c.externalId ?? c.id.toString()) == widget.categoryId);
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
       existing = expenses.firstWhere((c) => (c.externalId ?? c.id.toString()) == widget.categoryId);
     } catch (_) {
       try {
         existing = incomes.firstWhere((c) => (c.externalId ?? c.id.toString()) == widget.categoryId);
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

  void _addSubCategory() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('New Sub-Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _subCategories.add(SubCategory(
                      id: const Uuid().v4(),
                      name: controller.text,
                      iconPath: 'category', // Default icon for now
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
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
                    onPressed: _addSubCategory,
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
                      leading: const Icon(Icons.subdirectory_arrow_right, size: 20, color: Colors.grey),
                      title: Text(sub.name ?? 'Unknown'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _subCategories.removeAt(index);
                          });
                        },
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
          _getIconData(iconPath),
          color: isSelected ? AppColors.primary : Colors.grey,
        ),
      ),
    );
  }

  IconData _getIconData(String iconPath) {
    switch (iconPath) {
      case 'fastfood': return Icons.fastfood;
      case 'restaurant': return Icons.restaurant;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'local_cafe': return Icons.local_cafe;
      case 'directions_bus': return Icons.directions_bus;
      case 'directions_car': return Icons.directions_car;
      case 'local_gas_station': return Icons.local_gas_station;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'checkroom': return Icons.checkroom;
      case 'movie': return Icons.movie;
      case 'sports_esports': return Icons.sports_esports;
      case 'fitness_center': return Icons.fitness_center;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'work': return Icons.work;
      case 'home': return Icons.home;
      case 'receipt': return Icons.receipt;
      case 'attach_money': return Icons.attach_money;
      case 'savings': return Icons.savings;
      default: return Icons.category;
    }
  }
}
