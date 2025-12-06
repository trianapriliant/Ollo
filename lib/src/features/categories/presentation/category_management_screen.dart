import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/category_repository.dart';
import '../domain/category.dart';
import '../../../utils/icon_helper.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends ConsumerState<CategoryManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update FAB visibility
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text('Categories', style: AppTextStyles.h2),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Expense'),
            Tab(text: 'Income'),
            Tab(text: 'System'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoryList(type: CategoryType.expense),
          _CategoryList(type: CategoryType.income),
          const _SystemCategoryList(),
        ],
      ),
      floatingActionButton: _tabController.index == 2 
          ? null 
          : FloatingActionButton(
              onPressed: () {
                context.push('/categories/add');
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}

class _CategoryList extends ConsumerWidget {
  final CategoryType type;

  const _CategoryList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider(type));

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return Center(child: Text('No categories found', style: AppTextStyles.bodyMedium));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(category: category);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final subCategories = category.subCategories ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconHelper.getIcon(category.iconPath),
              color: category.color,
            ),
          ),
          title: Text(
            category.name,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${subCategories.length} sub-categories',
            style: AppTextStyles.bodySmall,
          ),
          children: [
            const Divider(),
            if (subCategories.isNotEmpty) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final sub = subCategories[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8, bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.03), // Subtle background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          child: Icon(
                            IconHelper.getIcon(sub.iconPath ?? 'category'),
                            size: 16,
                            color: category.color.withOpacity(0.8), // Inherit parent color theme
                          ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            sub.name ?? 'Unnamed', 
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to edit category (which handles sub-categories)
                      context.pushNamed(
                        'edit_category',
                        pathParameters: {'id': category.id.toString()},
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit Category'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Removed _getIconData method as it's replaced by IconHelper
}

class _SystemCategoryList extends StatelessWidget {
  const _SystemCategoryList();

  @override
  Widget build(BuildContext context) {
    // Static list of system categories
    // Static list of system categories
    final systemCategories = [
      {
        'name': 'Transfer',
        'icon': Icons.swap_horiz_rounded,
        'color': Colors.indigo,
        'description': 'Fund transfers between wallets',
      },
      {
        'name': 'Recurring',
        'icon': Icons.update_rounded,
        'color': Colors.blueGrey,
        'description': 'Automated recurring transactions',
      },
      {
        'name': 'Wishlist',
        'icon': Icons.favorite_rounded,
        'color': Colors.pinkAccent,
        'description': 'Automated transactions from Wishlist purchases',
      },
      {
        'name': 'Bills',
        'icon': Icons.receipt_long_rounded,
        'color': Colors.orange,
        'description': 'Automated transactions from Bill payments',
      },
      {
        'name': 'Debts',
        'icon': Icons.handshake_rounded,
        'color': Colors.purple,
        'description': 'Automated transactions from Debt/Loan records',
      },
      {
        'name': 'Savings',
        'icon': Icons.savings_rounded,
        'color': Colors.blue,
        'description': 'Automated transactions from Savings deposits/withdrawals',
      },
      {
        'name': 'Bundled Notes',
        'icon': Icons.shopping_basket_rounded,
        'color': Colors.teal,
        'description': 'Automated transactions from Smart Bundles',
      },
      {
        'name': 'Reimburse',
        'icon': Icons.currency_exchange,
        'color': Colors.orangeAccent,
        'description': 'Reimbursement tracking system',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: systemCategories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = systemCategories[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category['icon'] as IconData,
                color: category['color'] as Color,
              ),
            ),
            title: Text(
              category['name'] as String, 
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)
            ),
            subtitle: Text(
              category['description'] as String, 
              style: AppTextStyles.bodySmall
            ),
            trailing: const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('System Category', style: AppTextStyles.h3),
                  content: const Text(
                    'This category is managed by the system and cannot be edited or deleted manually.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
