import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/category_repository.dart';
import '../domain/category.dart';

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
              _getIconData(category.iconPath),
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.subdirectory_arrow_right, size: 16, color: Colors.grey[400]),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIconData(sub.iconPath ?? 'category'),
                            size: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(sub.name ?? 'Unnamed', style: AppTextStyles.bodyMedium),
                      ],
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

  IconData _getIconData(String iconPath) {
    switch (iconPath) {
      case 'fastfood': return Icons.fastfood;
      case 'directions_bus': return Icons.directions_bus;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'movie': return Icons.movie;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'receipt': return Icons.receipt;
      case 'more_horiz': return Icons.more_horiz;
      case 'attach_money': return Icons.attach_money;
      case 'store': return Icons.store;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'trending_up': return Icons.trending_up;
      // Add more as needed
      default: return Icons.category;
    }
  }
}

class _SystemCategoryList extends StatelessWidget {
  const _SystemCategoryList();

  @override
  Widget build(BuildContext context) {
    // Static list of system categories
    final systemCategories = [
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
