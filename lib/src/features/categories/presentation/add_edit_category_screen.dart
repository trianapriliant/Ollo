import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/modern_confirm_dialog.dart';
import '../data/category_repository.dart';
import '../domain/category.dart';
import 'widgets/category_color_selector.dart';
import 'widgets/category_icon_selector.dart';
import 'widgets/category_type_selector.dart';
import 'widgets/sub_category_manager.dart';
import '../../../localization/generated/app_localizations.dart';
import 'category_localization_helper.dart';
import '../../transactions/data/transaction_repository.dart';
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
  int? _originalId; // Store the original Isar ID for updates
  String? _originalExternalId; // Store the original externalId to preserve it

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
        _originalId = category!.id; // Store the original ID
        _originalExternalId = category!.externalId; // Store the original externalId
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
      // Preserve the original externalId when editing, generate new UUID only for new categories
      externalId: _isNew ? const Uuid().v4() : (_originalExternalId ?? widget.categoryId),
      name: _nameController.text,
      iconPath: _selectedIcon,
      type: _type,
      colorValue: _selectedColor.value,
      subCategories: _subCategories,
    );


    if (_isNew) {
      await repository.addCategory(category);
    } else {
      // Use the stored original ID to ensure we update the correct record
      if (_originalId != null) {
        category.id = _originalId!;
      } else {
        // Fallback: try to find by externalId if _originalId wasn't set
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

  Future<void> _showDeleteConfirmation() async {
    if (widget.categoryId == null) return;
    
    // Check for linked transactions - search by both externalId and numeric ID
    final txnRepository = await ref.read(transactionRepositoryProvider.future);
    
    // Transactions might have categoryId stored as either externalId or numeric ID
    final searchIds = <String>{};
    if (_originalExternalId != null) searchIds.add(_originalExternalId!);
    if (_originalId != null) searchIds.add(_originalId.toString());
    searchIds.add(widget.categoryId!);
    
    // Get transactions matching any of the IDs
    int count = 0;
    for (final id in searchIds) {
      final transactions = await txnRepository.getTransactionsByCategoryId(id);
      count += transactions.length;
    }
    
    if (!mounted) return;
    
    final confirmed = await showModernConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.deleteCategory,
      message: AppLocalizations.of(context)!.deleteCategoryConfirm,
      secondaryMessage: count > 0 
        ? '$count ${count == 1 ? 'transaction uses' : 'transactions use'} this category'
        : null,
      confirmText: AppLocalizations.of(context)!.delete,
      cancelText: AppLocalizations.of(context)!.cancel,
      type: ConfirmDialogType.delete,
    );
    
    if (confirmed == true) {
      _deleteCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(_isNew ? AppLocalizations.of(context)!.newCategory : AppLocalizations.of(context)!.editCategory, style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          if (!_isNew)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(),
            ),
          TextButton(
            onPressed: _saveCategory,
            child: Text(AppLocalizations.of(context)!.save, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Input
              Text(
                AppLocalizations.of(context)!.categoryName, 
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterCategoryName,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    prefixIcon: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: _selectedColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.label_outline, color: _selectedColor),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.required : null,
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
