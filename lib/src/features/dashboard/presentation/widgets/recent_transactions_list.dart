import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../../../wallets/data/wallet_repository.dart';
import '../../../wallets/domain/wallet.dart';
import '../../../transactions/domain/transaction.dart';
import '../../../categories/data/category_repository.dart';
import '../../../categories/domain/category.dart';
import '../dashboard_filter_provider.dart';
import 'package:ollo/src/utils/icon_helper.dart';

final walletsListProvider = FutureProvider<List<Wallet>>((ref) async {
  final repo = await ref.watch(walletRepositoryProvider.future);
  return repo.getAllWallets();
});

final allCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = await ref.watch(categoryRepositoryProvider.future);
  final expenseCategories = await repo.getCategories(CategoryType.expense);
  final incomeCategories = await repo.getCategories(CategoryType.income);
  return [...expenseCategories, ...incomeCategories];
});

class RecentTransactionsList extends ConsumerWidget {
  final List<Transaction> transactions;
  
  const RecentTransactionsList({super.key, required this.transactions});

  String? _getSubCategoryIcon(Transaction transaction, Category? category) {
    final subId = transaction.subCategoryId;
    
    // 1. Try to find fresh icon from Category (Source of Truth)
    if (subId != null && category != null) {
      final subs = category.subCategories;
      if (subs != null) {
        for (final s in subs) {
          if (s.id == subId) {
            return s.iconPath;
          }
        }
      }
    }

    // 2. Fallback to stored icon (Snapshot)
    if (transaction.subCategoryIcon != null) return transaction.subCategoryIcon;
    
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final transactionsAsync = ref.watch(filteredTransactionsProvider); // Removed
    final currency = ref.watch(currencyProvider);
    final walletsAsync = ref.watch(walletsListProvider);
    final wallets = walletsAsync.valueOrNull ?? [];
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    // Directly use the passed transactions list
    if (transactions.isEmpty) {
      return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada transaksi",
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ayo mulai catat pengeluaran dan pemasukanmu agar keuangan lebih rapi! 🚀",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          );
        }

        final groupedTransactions = _groupTransactions(transactions);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Transactions', style: AppTextStyles.h2),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedTransactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final group = groupedTransactions[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateHeader(group.date, group.dailyTotal, currency),
                    const SizedBox(height: 12),
                    ...group.transactions.map((transaction) {
                      final walletName = wallets.firstWhere(
                        (w) => w.id.toString() == transaction.walletId || w.externalId == transaction.walletId, 
                        orElse: () => Wallet()..name = 'Unknown'
                      ).name;
                      
                      // Find category and subcategory
                      Category? category;
                      
                      if (transaction.categoryId != null) {
                         if (transaction.categoryId == 'bills') {
                           category = Category(
                             externalId: 'bills', 
                             name: 'Bills', 
                             iconPath: 'receipt_long', 
                             type: CategoryType.expense, 
                             colorValue: Colors.orange.value
                           );
                         } else if (transaction.categoryId == 'wishlist') {
                           category = Category(
                             externalId: 'wishlist', 
                             name: 'Wishlist', 
                             iconPath: 'favorite', 
                             type: CategoryType.expense, 
                             colorValue: Colors.pink.value
                           );
                         } else if (transaction.categoryId == 'debt') {
                           category = Category(
                             externalId: 'debt', 
                             name: 'Debt', 
                             iconPath: 'handshake', 
                             type: CategoryType.expense, 
                             colorValue: Colors.purple.value
                           );
                         } else {
                           category = categories.firstWhere(
                             (c) => (c.externalId ?? c.id.toString()) == transaction.categoryId, 
                             orElse: () => Category(
                               name: 'Unknown', 
                               iconPath: 'help', 
                               type: CategoryType.expense, 
                               colorValue: Colors.grey.value
                             )
                           );
                         }
                      }

                      final isSystem = transaction.type == TransactionType.system;
                      
                      // Check if it's a Debt Income (Borrowed or Received Payment)
                      final isDebtIncome = isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('received payment'));
                      
                      // Check if it's a Savings Withdraw (Income to Wallet)
                      final isSavingsWithdraw = isSystem && transaction.title.toLowerCase().contains('withdraw from');
                      
                      // System defaults to expense, UNLESS it's a debt income OR savings withdraw
                      final isExpense = (transaction.isExpense || isSystem) && !isDebtIncome && !isSavingsWithdraw;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            context.push('/transaction-detail', extra: transaction);
                          },
                          child: _buildActivityItem(
                            transaction.title,
                            walletName,
                            transaction.amount,
                            category,
                            _getSubCategoryIcon(transaction, category), // Pass sub-category icon
                            isExpense,
                            currency,
                            transaction.note,
                            transaction.date,
                            isSystem: isSystem,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ],
        );
  }

  List<_TransactionGroup> _groupTransactions(List<Transaction> transactions) {
    final groups = <DateTime, _TransactionGroup>{};

    for (var transaction in transactions) {
      final dateKey = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (!groups.containsKey(dateKey)) {
        groups[dateKey] = _TransactionGroup(date: dateKey, transactions: [], dailyTotal: 0);
      }
      groups[dateKey]!.transactions.add(transaction);
      
      final isSystem = transaction.type == TransactionType.system;
      final isDebtIncome = isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('received payment'));
      final isSavingsWithdraw = isSystem && transaction.title.toLowerCase().contains('withdraw from');
      
      if ((transaction.isExpense || isSystem) && !isDebtIncome && !isSavingsWithdraw) {
        groups[dateKey]!.dailyTotal -= transaction.amount;
      } else {
        groups[dateKey]!.dailyTotal += transaction.amount;
      }
    }

    final sortedGroups = groups.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date desc

    return sortedGroups;
  }

  Widget _buildDateHeader(DateTime date, double dailyTotal, Currency currency) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    String dateLabel = DateFormat('dd MMM yyyy').format(date);

    final isPositive = dailyTotal >= 0;
    final formattedTotal = '${isPositive ? "+" : ""}${currency.format(dailyTotal.abs())}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateLabel,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
        Text(
          formattedTotal,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title, 
    String walletName, 
    double amount, 
    Category? category, 
    String? subCategoryIcon, // New parameter
    bool isExpense, 
    Currency currency,
    String? note,
    DateTime date, {
    bool isSystem = false,
  }) {
    // Determine if it's a Wishlist, Bill, Debt, or Savings transaction based on Category ID or Title
    final isWishlist = (category?.externalId == 'wishlist') || (isSystem && title.toLowerCase().contains('wishlist'));
    final isBill = (category?.externalId == 'bills') || (isSystem && title.toLowerCase().contains('bill'));
    final isDebt = (category?.externalId == 'debt') || (isSystem && (title.toLowerCase().contains('borrowed') || title.toLowerCase().contains('lent') || title.toLowerCase().contains('debt') || title.toLowerCase().contains('received payment')));
    final isSavings = isSystem && (title.toLowerCase().contains('deposit to') || title.toLowerCase().contains('withdraw from') || title.toLowerCase().contains('savings'));

    final iconPath = subCategoryIcon ?? category?.iconPath;

    final iconData = isBill 
        ? Icons.receipt_long_rounded
        : (isWishlist 
            ? Icons.favorite_rounded
            : (isDebt 
                ? Icons.handshake_rounded
                : (isSavings 
                    ? Icons.savings_rounded
                    : (iconPath != null ? IconHelper.getIcon(iconPath) : Icons.help_outline))));
        
    final iconColor = isBill 
        ? Colors.orange
        : (isWishlist 
            ? Colors.pinkAccent
            : (isDebt 
                ? Colors.purple
                : (isSavings 
                    ? Colors.blue
                    : (category?.color ?? AppColors.primary))));
        
    final backgroundColor = isBill 
        ? Colors.orange.withOpacity(0.1)
        : (isWishlist 
            ? Colors.pinkAccent.withOpacity(0.1)
            : (isDebt 
                ? Colors.purple.withOpacity(0.1)
                : (isSavings 
                    ? Colors.blue.withOpacity(0.1)
                    : (category?.color.withOpacity(0.1) ?? AppColors.accentBlue))));
        
    final timeStr = DateFormat('HH:mm').format(date);
    
    String systemNote = '';
    if (isWishlist) systemNote = ' - Wishlist Purchase';
    if (isBill) systemNote = ' - Bill Payment';
    if (isDebt) systemNote = ' - Debt Transaction';
    if (isSavings) systemNote = ' - Savings Transaction';
    
    final noteStr = isSystem 
        ? systemNote
        : (note != null && note.isNotEmpty ? ' - $note' : '');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(iconData, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title, 
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeStr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$walletName$noteStr', 
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isExpense ? "-" : "+"}${currency.format(amount)}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: isExpense ? Colors.red[400] : Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionGroup {
  final DateTime date;
  final List<Transaction> transactions;
  double dailyTotal;

  _TransactionGroup({required this.date, required this.transactions, required this.dailyTotal});
}
