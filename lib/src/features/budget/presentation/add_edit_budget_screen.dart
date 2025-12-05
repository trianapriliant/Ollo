import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/budget_repository.dart';
import '../domain/budget.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../transactions/presentation/widgets/category_selector.dart';

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
      _amountController.text = widget.budget!.amount.toStringAsFixed(0);
      _selectedPeriod = widget.budget!.period;
      // We need to load the category... this is async.
      // For simplicity, we'll just let the user re-select if editing, 
      // or we could load it. Let's load it.
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
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
    
    final budget = Budget()
      ..categoryId = _selectedCategory!.externalId ?? _selectedCategory!.id.toString()
      ..amount = amount
      ..period = _selectedPeriod
      ..startDate = DateTime.now(); // Or keep existing if editing?

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
        title: Text(widget.budget == null ? 'New Budget' : 'Edit Budget', style: AppTextStyles.h2),
        actions: [
          TextButton(
            onPressed: _saveBudget,
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
              // Amount Input
              Text('Limit Amount', style: AppTextStyles.bodySmall),
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
                        style: AppTextStyles.h2,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Enter amount' : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Period Selector
              Text('Period', style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildPeriodTab('Weekly', BudgetPeriod.weekly)),
                    Expanded(child: _buildPeriodTab('Monthly', BudgetPeriod.monthly)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Category Selector
              Text('Category', style: AppTextStyles.bodySmall),
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
                    label: const Text('Delete Budget', style: TextStyle(color: Colors.red)),
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Budget?'),
        content: const Text('Are you sure you want to delete this budget?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && widget.budget != null) {
      await ref.read(budgetRepositoryProvider).deleteBudget(widget.budget!.id);
      if (mounted) {
        context.pop();
      }
    }
  }
}
