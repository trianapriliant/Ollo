import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/budget_repository.dart';
import '../domain/budget.dart';
import 'add_edit_budget_screen.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import 'widgets/budget_summary_card.dart';
import '../../../utils/icon_helper.dart';
import '../../../localization/generated/app_localizations.dart';
import '../../categories/presentation/category_localization_helper.dart';
import '../../settings/presentation/icon_pack_provider.dart';


enum BudgetSortType { none, name, amount }

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  BudgetSortType _sortType = BudgetSortType.none;

  List<Budget> _sortBudgets(List<Budget> budgets) {
    if (_sortType == BudgetSortType.none) return budgets;
    
    final sorted = List<Budget>.from(budgets);
    if (_sortType == BudgetSortType.name) {
      // We need category names for this, so we sort by categoryId for now
      sorted.sort((a, b) => a.categoryId.compareTo(b.categoryId));
    } else if (_sortType == BudgetSortType.amount) {
      sorted.sort((a, b) => b.amount.compareTo(a.amount)); // High to low
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final budgetsAsync = ref.watch(budgetListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(AppLocalizations.of(context)!.budgetsTitle, style: AppTextStyles.h2),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'home') {
                context.go('/home');
              }
              if (value == 'sort_name') {
                setState(() => _sortType = BudgetSortType.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.sortByName),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
              if (value == 'sort_amount') {
                setState(() => _sortType = BudgetSortType.amount);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.sortByAmount),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'sort_name',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _sortType == BudgetSortType.name 
                            ? AppColors.primary.withOpacity(0.2) 
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.sort_by_alpha, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.sortByName, style: AppTextStyles.bodyMedium),
                    if (_sortType == BudgetSortType.name) ...[
                      const Spacer(),
                      Icon(Icons.check, size: 18, color: AppColors.primary),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'sort_amount',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _sortType == BudgetSortType.amount 
                            ? Colors.orange.withOpacity(0.2) 
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.attach_money, size: 18, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.sortByAmount, style: AppTextStyles.bodyMedium),
                    if (_sortType == BudgetSortType.amount) ...[
                      const Spacer(),
                      const Icon(Icons.check, size: 18, color: Colors.orange),
                    ],
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'home',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.home, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: budgetsAsync.when(
        data: (budgets) {
          final sortedBudgets = _sortBudgets(budgets);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const BudgetSummaryCard(),
              const SizedBox(height: 24),
              if (sortedBudgets.isEmpty) ...[
                const SizedBox(height: 48),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.noBudgetsYet, style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey)),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddEditBudgetScreen()),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.createBudget),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(AppLocalizations.of(context)!.yourBudgets, style: AppTextStyles.h2),
                const SizedBox(height: 16),
                ...sortedBudgets.map((budget) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditBudgetScreen(budget: budget),
                        ),
                      );
                    },
                    child: _BudgetCard(budget: budget),
                  ),
                )),
              ],
              const SizedBox(height: 80), // Bottom padding for FAB
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'budget_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditBudgetScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _BudgetCard extends ConsumerWidget {
  final Budget budget;

  const _BudgetCard({required this.budget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We need to fetch the category to get name/icon/color
    // And calculate spent amount
    // This might be inefficient in a list, but for now it's fine.
    // Ideally, we'd have a ViewModel or join query.
    
    return FutureBuilder<double>(
      future: ref.read(budgetRepositoryProvider).calculateSpentAmount(budget),
      builder: (context, snapshot) {
        final spent = snapshot.data ?? 0.0;
        final progress = (spent / budget.amount).clamp(0.0, 1.0);
        final remaining = budget.amount - spent;
        
        // Color based on progress
        Color progressColor = Colors.green;
        if (progress > 0.75) progressColor = Colors.orange;
        if (progress >= 1.0) progressColor = Colors.red;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Info (Placeholder name until we fetch it)
                  // To fetch category name properly, we need another FutureBuilder or provider.
                  // Let's use a Consumer for category lookup.
                  Consumer(
                    builder: (context, ref, child) {
                      final categoryRepo = ref.watch(categoryRepositoryProvider).valueOrNull;
                      if (categoryRepo == null) return const Text('Loading...');
                      
                      return FutureBuilder<Category?>(
                        future: _fetchCategory(categoryRepo, budget.categoryId),
                        builder: (context, catSnapshot) {
                          final category = catSnapshot.data;
                          final displayName = category != null 
                              ? CategoryLocalizationHelper.getLocalizedCategoryName(context, category)
                              : AppLocalizations.of(context)!.unknown;
                          return Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (category?.color ?? Colors.grey).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: IconHelper.getIconWidget(
                                  category?.iconPath ?? 'category',
                                  pack: ref.watch(iconPackProvider),
                                  color: category?.color ?? Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(displayName, style: AppTextStyles.h3),
                            ],
                          );

                        },
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      budget.period.name.toUpperCase(),
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(spent)} / ${NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(budget.amount)}',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                remaining >= 0 
                  ? '${NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(remaining)} remaining' 
                  : 'Over budget by ${NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(remaining.abs())}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: remaining >= 0 ? Colors.grey : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Category?> _fetchCategory(CategoryRepository repo, String id) async {
    // This is a bit hacky because we don't have getById(String) easily exposed
    // But we can reuse the logic we used elsewhere or add a method to repo.
    // For now, let's just fetch all and find. Optimizable later.
    final expenses = await repo.getCategories(CategoryType.expense);
    try {
      return expenses.firstWhere((c) => (c.externalId ?? c.id.toString()) == id);
    } catch (_) {
      return null;
    }
  }


}
