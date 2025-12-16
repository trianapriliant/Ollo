import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/category_repository.dart';
import '../domain/category.dart';
import 'widgets/category_color_selector.dart';
import 'widgets/category_icon_selector.dart';
import 'widgets/category_type_selector.dart';
import 'widgets/sub_category_manager.dart';
import '../../../localization/generated/app_localizations.dart';
import 'category_localization_helper.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCategory();
      });
    }
  }

  Future<void> _loadCategory() async {
    final repository = await ref.read(categoryRepositoryProvider.future);
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
        _nameController.text = CategoryLocalizationHelper.getLocalizedCategoryName(context, category!);
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

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = await ref.read(categoryRepositoryProvider.future);
    
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
    
    if (mounted) {
      context.pop();
      ref.refresh(categoryListProvider(_type));
    }
  }

  Future<void> _deleteCategory() async {
    if (widget.categoryId == null) return;
    
    final repository = await ref.read(categoryRepositoryProvider.future);
    
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
        title: Text(_isNew ? AppLocalizations.of(context)!.newCategory : AppLocalizations.of(context)!.editCategory, style: AppTextStyles.h2),
        actions: [
          if (!_isNew)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.deleteCategory),
                    content: Text(AppLocalizations.of(context)!.deleteCategoryConfirm),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteCategory();
                        },
                        child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          TextButton(
            onPressed: _saveCategory,
            child: Text(AppLocalizations.of(context)!.save, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.categoryName,
                    border: InputBorder.none,
                    icon: const Icon(Icons.label_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterCategoryName : null,
                ),
              ),
              const SizedBox(height: 24),

              // Modular Type Selector
              if (_isNew)
                CategoryTypeSelector(
                  selectedType: _type,
                  onTypeChanged: (newType) => setState(() => _type = newType),
                ),

              // Modular Color Selector
              CategoryColorSelector(
                selectedColor: _selectedColor,
                onColorSelected: (color) => setState(() => _selectedColor = color),
              ),

              // Modular Icon Selector
              CategoryIconSelector(
                selectedIcon: _selectedIcon,
                onIconSelected: (icon) => setState(() => _selectedIcon = icon),
              ),

              // Modular Sub-Category Manager
              SubCategoryManager(
                subCategories: _subCategories,
                onSubCategoriesChanged: (newList) => setState(() => _subCategories = newList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
