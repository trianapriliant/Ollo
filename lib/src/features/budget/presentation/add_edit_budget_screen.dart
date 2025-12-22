import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/modern_confirm_dialog.dart';
import '../data/budget_repository.dart';
import '../domain/budget.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../transactions/presentation/widgets/category_selector.dart';
import '../../../localization/generated/app_localizations.dart';

import 'package:intl/intl.dart';
import '../../../utils/currency_input_formatter.dart';

class AddEditBudgetScreen extends ConsumerStatefulWidget {
  final Budget? budget;

  const AddEditBudgetScreen({super.key, this.budget});

  @override
  ConsumerState<AddEditBudgetScreen> createState() => _AddEditBudgetScreenState();
}

class _AddEditBudgetScreenState extends ConsumerState<AddEditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  Category? _selectedCategory;
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      // Format existing amount with commas
      _amountController.text = CurrencyInputFormatter.parse(widget.budget!.amount.toString()).toString();
      // Wait, parse returns double. We want to formatting it TO string.
      // Actually simpler:
      final number = widget.budget!.amount;
      _amountController.text = NumberFormat.decimalPattern('en_US').format(number);

      _selectedPeriod = widget.budget!.period;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCategory(widget.budget!.categoryId);
      });
    }
  }

  Future<void> _loadCategory(String id) async {
    final repo = await ref.read(categoryRepositoryProvider.future);
    final expenses = await repo.getCategories(CategoryType.expense);
    try {
      final cat = expenses.firstWhere((c) => (c.externalId ?? c.id.toString()) == id);
      setState(() {
        _selectedCategory = cat;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorSelectCategory)),
      );
      return;
    }

    // Strip commas before parsing
    final amount = CurrencyInputFormatter.parse(_amountController.text);
    
    final budget = Budget()
      ..categoryId = _selectedCategory!.externalId ?? _selectedCategory!.id.toString()
      ..amount = amount
      ..period = _selectedPeriod
      ..startDate = DateTime.now();

    if (widget.budget != null) {
      budget.id = widget.budget!.id;
      budget.startDate = widget.budget!.startDate;
      await ref.read(budgetRepositoryProvider).updateBudget(budget);
    } else {
      await ref.read(budgetRepositoryProvider).addBudget(budget);
    }

    if (mounted) {
      context.pop();
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
        title: Text(widget.budget == null ? AppLocalizations.of(context)!.newBudget : AppLocalizations.of(context)!.editBudget, style: AppTextStyles.h2),
        actions: [
          TextButton(
            onPressed: _saveBudget,
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
              // Amount Input
              Text(AppLocalizations.of(context)!.limitAmount, style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text('Rp', style: AppTextStyles.h2.copyWith(color: Colors.grey)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatter(),
                        ],
                        style: AppTextStyles.h2,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                        ),
                        validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.enterAmount : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Period Selector
              Text(AppLocalizations.of(context)!.period, style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildPeriodTab(AppLocalizations.of(context)!.weekly, BudgetPeriod.weekly)),
                    Expanded(child: _buildPeriodTab(AppLocalizations.of(context)!.monthly, BudgetPeriod.monthly)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Category Selector
              Text(AppLocalizations.of(context)!.category, style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final categoriesAsync = ref.watch(categoryListProvider(CategoryType.expense));
                  
                  return categoriesAsync.when(
                    data: (categories) {
                      return CategorySelector(
                        categories: categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text('Failed to load categories'),
                  );
                },
              ),
              
              if (widget.budget != null) ...[
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _deleteBudget,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: Text(AppLocalizations.of(context)!.deleteBudget, style: const TextStyle(color: Colors.red)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodTab(String label, BudgetPeriod period) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = period),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected ? [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteBudget() async {
    final confirm = await showModernConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.deleteBudget,
      message: AppLocalizations.of(context)!.deleteBudgetConfirm,
      confirmText: AppLocalizations.of(context)!.delete,
      cancelText: AppLocalizations.of(context)!.cancel,
      type: ConfirmDialogType.delete,
    );

    if (confirm == true && widget.budget != null) {
      await ref.read(budgetRepositoryProvider).deleteBudget(widget.budget!.id);
      if (mounted) {
        context.pop();
      }
    }
  }
}
