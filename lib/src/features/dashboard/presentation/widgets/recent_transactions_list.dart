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
import '../../../wallets/presentation/wallet_provider.dart';
import '../../../../localization/generated/app_localizations.dart';
import 'package:ollo/src/features/transactions/data/transaction_repository.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../categories/presentation/category_localization_helper.dart';
import '../../../settings/domain/transaction_color_theme.dart';

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

  String? _getSubCategoryName(Transaction transaction, Category? category) {
    final subId = transaction.subCategoryId;
    
    // 1. Try to find fresh name from Category (Source of Truth)
    if (subId != null && category != null) {
      final subs = category.subCategories;
      if (subs != null) {
        for (final s in subs) {
          if (s.id == subId) {
            return s.name;
          }
        }
      }
    }

    // 2. Fallback to stored name (Snapshot)
    if (transaction.subCategoryName != null) return transaction.subCategoryName;
    
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final transactionsAsync = ref.watch(filteredTransactionsProvider); // Removed
    final currency = ref.watch(currencyProvider);
    final walletsAsync = ref.watch(walletListProvider);
    final wallets = walletsAsync.valueOrNull ?? [];
    final categoriesAsync = ref.watch(allCategoriesStreamProvider);
    final categories = categoriesAsync.valueOrNull ?? [];
    final colorTheme = ref.watch(colorPaletteProvider);

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
                    AppLocalizations.of(context)!.noTransactions,
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.startRecording,
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
            Text(AppLocalizations.of(context)!.recentTransactions, style: AppTextStyles.h2),
            const SizedBox(height: 8), // Reduced from 16
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
                    _buildDateHeader(context, group.date, group.dailyTotal, currency, colorTheme),
                    const SizedBox(height: 12),
                    ...group.transactions.map((transaction) {
                      String walletName;
                      if (transaction.type == TransactionType.reimbursement && transaction.walletId == null) {
                        walletName = AppLocalizations.of(context)!.reimburse;
                      } else {
                        final sourceWallet = wallets.firstWhere(
                          (w) => w.id.toString() == transaction.walletId || w.externalId == transaction.walletId, 
                          orElse: () => Wallet()..name = AppLocalizations.of(context)!.unknown
                        ).name;
                        
                        if (transaction.type == TransactionType.transfer && transaction.destinationWalletId != null) {
                            final destWallet = wallets.firstWhere(
                                (w) => w.id.toString() == transaction.destinationWalletId || w.externalId == transaction.destinationWalletId,
                                orElse: () => Wallet()..name = AppLocalizations.of(context)!.unknown
                            ).name;
                            walletName = '$sourceWallet ➔ $destWallet';
                        } else {
                            walletName = sourceWallet;
                        }
                      }
                      
                      // Find category and subcategory
                      Category? category;
                      
                      if (transaction.categoryId != null) {
                         if (transaction.categoryId == 'bills') {
                           category = Category(
                             externalId: 'bills', 
                             name: AppLocalizations.of(context)!.bills, 
                             iconPath: 'receipt_long', 
                             type: CategoryType.expense, 
                             colorValue: Colors.orange.value
                           );
                         } else if (transaction.categoryId == 'wishlist') {
                           category = Category(
                             externalId: 'wishlist', 
                             name: AppLocalizations.of(context)!.wishlist, 
                             iconPath: 'favorite', 
                             type: CategoryType.expense, 
                             colorValue: Colors.pink.value
                           );
                         } else if (transaction.categoryId == 'debt') {
                           category = Category(
                             externalId: 'debt', 
                             name: AppLocalizations.of(context)!.debts, 
                             iconPath: 'handshake', 
                             type: CategoryType.expense, 
                             colorValue: Colors.purple.value
                           );
                         } else if (['notes', 'note', 'Smart Notes', 'Smart Note', 'smart notes', 'smart note'].contains(transaction.categoryId)) {
                           category = Category(
                             externalId: 'notes', 
                             name: AppLocalizations.of(context)!.smartNotesTitle, 
                             iconPath: 'edit_note', 
                             type: CategoryType.expense, 
                             colorValue: Colors.teal.value
                           );
                         } else {
                           category = categories.firstWhere(
                             (c) => (c.externalId ?? c.id.toString()) == transaction.categoryId, 
                             orElse: () => Category(
                               name: AppLocalizations.of(context)!.unknown, 
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

                      // --- New Localization Logic ---
                      
                      // Find SubCategory object if exists
                      SubCategory? subCategory;
                      if (category != null && transaction.subCategoryId != null && category.subCategories != null) {
                         try {
                           subCategory = category.subCategories!.firstWhere((s) => s.id == transaction.subCategoryId);
                         } catch (_) {}
                      }

                      // Determine Display Title (Localization Logic)
                      String displayTitle = transaction.title;
                      
                      if (subCategory != null) {
                        // If title matches the original subcategory name (likely English/Default), use localized name
                        if (transaction.title.toLowerCase() == (subCategory.name ?? '').toLowerCase()) {
                          displayTitle = CategoryLocalizationHelper.getLocalizedSubCategoryName(context, subCategory);
                        }
                      } else if (category != null) {
                        // If title matches the original category name, use localized name
                        if (transaction.title.toLowerCase() == (category.name ?? '').toLowerCase()) {
                          displayTitle = CategoryLocalizationHelper.getLocalizedCategoryName(context, category);
                        }
                      }

                      // Check for Transfer Fee
                      if (category?.externalId == 'financial' && 
                          (subCategory?.id == 'fees' || subCategory?.id == 'fee') && 
                          (transaction.note != null && transaction.note!.startsWith('Fee for transfer'))) {
                          displayTitle = AppLocalizations.of(context)!.transferFee;
                      }

                      // Check for Balance Adjustment
                      if (category?.externalId == 'system' && 
                          subCategory?.id == 'adjustment' &&
                          transaction.title == 'Balance Adjustment') {
                          displayTitle = AppLocalizations.of(context)!.adjustmentTitle;
                      }

                      // Check for Transfer
                      if (transaction.type == TransactionType.transfer) {
                          displayTitle = AppLocalizations.of(context)!.transferTransaction;
                      }
                      
                      // -------------------------------

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Slidable(
                              key: ValueKey(transaction.id),
                              startActionPane: ActionPane(
                                motion: const BehindMotion(),
                                extentRatio: 0.25,
                                dismissible: DismissiblePane(
                                  onDismissed: () {
                                    ref.read(transactionRepositoryProvider).value!.deleteTransaction(transaction.id);
                                  },
                                  confirmDismiss: () async {
                                    return await _showDeleteConfirmation(context) ?? false;
                                  },
                                ),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      final confirmed = await _showDeleteConfirmation(context);
                                      if (confirmed == true) {
                                        ref.read(transactionRepositoryProvider).value!.deleteTransaction(transaction.id);
                                      }
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      context.push('/add-transaction', extra: transaction);
                                    },
                                    backgroundColor: const Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                            child: GestureDetector(
                              onTap: () {
                                context.push('/transaction-detail', extra: transaction);
                              },
                                child: _buildActivityItem(
                                context,
                                displayTitle,
                                walletName,
                                transaction.amount,
                                category,
                                _getSubCategoryIcon(transaction, category),
                                _getSubCategoryName(transaction, category),
                                isExpense,
                                currency,
                                transaction.note,
                                transaction.date,
                                colorTheme,
                                isSystem: isSystem,
                                isReimbursement: transaction.type == TransactionType.reimbursement,
                                isTransfer: transaction.type == TransactionType.transfer,
                              ),
                            ),
                          ), // Slidable
                        ), // ClipRRect
                      ), // Container
                    ); // Padding
                    }).toList(),
                  ],
                );
              },
            ),
          ],
        );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: const Text('Are you sure you want to delete this transaction? This action cannot be undone.'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
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
      final isReimbursement = transaction.type == TransactionType.reimbursement;
      final isTransfer = transaction.type == TransactionType.transfer; // Check Transfer
      final isDebtIncome = isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('received payment'));
      final isSavingsWithdraw = isSystem && transaction.title.toLowerCase().contains('withdraw from');
      
      if (isReimbursement || isTransfer) { // Use isTransfer here
        // Reimbursement and Transfer do not affect daily total
      } else if ((transaction.isExpense || isSystem) && !isDebtIncome && !isSavingsWithdraw) {
        groups[dateKey]!.dailyTotal -= transaction.amount;
      } else {
        groups[dateKey]!.dailyTotal += transaction.amount;
      }
    }

    final sortedGroups = groups.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date desc

    return sortedGroups;
  }

  Widget _buildDateHeader(BuildContext context, DateTime date, double dailyTotal, Currency currency, TransactionTheme theme) {
    final now = DateTime.now();
    // ignore: unused_local_variable
    final today = DateTime(now.year, now.month, now.day);

    String dateLabel = DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString()).format(date);

    final isPositive = dailyTotal >= 0;
    final formattedTotal = '${isPositive ? "+" : "-"}${currency.format(dailyTotal.abs())}';

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
            color: isPositive ? theme.incomeColor : theme.expenseColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title, 
    String walletName, 
    double amount, 
    Category? category, 
    String? subCategoryIcon, 
    String? subCategoryName, // New parameter
    bool isExpense, 
    Currency currency,
    String? note,
    DateTime date, 
    TransactionTheme theme, { // New parameter
    bool isSystem = false,
    bool isReimbursement = false,
    bool isTransfer = false, // New parameter
  }) {
    // Determine if it's a Wishlist, Bill, Debt, or Savings transaction based on Category ID or Title
    final isWishlist = (category?.externalId == 'wishlist') || (isSystem && title.toLowerCase().contains('wishlist'));
    final isBill = (category?.externalId == 'bills') || (isSystem && title.toLowerCase().contains('bill'));
    final isDebt = (category?.externalId == 'debt') || (isSystem && (title.toLowerCase().contains('borrowed') || title.toLowerCase().contains('lent') || title.toLowerCase().contains('debt') || title.toLowerCase().contains('received payment')));
    final isSavings = (isSystem && (title.toLowerCase().contains('deposit to') || title.toLowerCase().contains('withdraw from') || title.toLowerCase().contains('savings'))) || title.toLowerCase().contains('savings');
    // final isTransfer = title.toLowerCase().contains('transfer'); // Use passed param

    final iconPath = subCategoryIcon ?? category?.iconPath;

    final iconData = isReimbursement 
        ? Icons.currency_exchange
        : (isBill 
            ? Icons.receipt_long_rounded
            : (isWishlist 
                ? Icons.favorite_rounded
                : (isDebt 
                    ? Icons.handshake_rounded
                    : (isSavings 
                        ? Icons.savings_rounded
                        : (isTransfer 
                            ? Icons.swap_horiz
                            : (iconPath != null ? IconHelper.getIcon(iconPath) : Icons.help_outline))))));
        
    final iconColor = isReimbursement
        ? Colors.orangeAccent
        : (isBill 
            ? Colors.orange
            : (isWishlist 
                ? Colors.pinkAccent
                : (isDebt 
                    ? Colors.purple
                    : (isSavings 
                        ? Colors.blue
                        : (isTransfer 
                            ? Colors.indigo 
                            : (category?.color ?? AppColors.primary))))));
        
    final backgroundColor = isReimbursement
        ? Colors.orangeAccent.withOpacity(0.1)
        : (isBill 
            ? Colors.orange.withOpacity(0.1)
            : (isWishlist 
                ? Colors.pinkAccent.withOpacity(0.1)
                : (isDebt 
                    ? Colors.purple.withOpacity(0.1)
                    : (isSavings 
                        ? Colors.blue.withOpacity(0.1)
                        : (isTransfer 
                            ? Colors.indigo.withOpacity(0.1)
                            : (category?.color.withOpacity(0.1) ?? AppColors.accentBlue))))));
        
    final timeStr = DateFormat('HH:mm').format(date);
    
    String systemNote = '';
    if (isWishlist) systemNote = ' - ${AppLocalizations.of(context)!.wishlistPurchase}';
    if (isBill) systemNote = ' - ${AppLocalizations.of(context)!.billPayment}';
    if (isDebt) systemNote = ' - ${AppLocalizations.of(context)!.debtTransaction}';
    if (isSavings) systemNote = ' - ${AppLocalizations.of(context)!.savingsTransaction}';
    if (isTransfer) systemNote = ' - ${AppLocalizations.of(context)!.transferTransaction}';
    if (isReimbursement) systemNote = ' - ${AppLocalizations.of(context)!.reimburse}';
    
    // ignore: unused_local_variable
    final noteStr = isSystem || isReimbursement || isTransfer
        ? systemNote
        : (note != null && note.isNotEmpty ? ' - $note' : '');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                        '$walletName', // noteStr removed here to avoid duplication if walletName is long? Or maybe user wants it? User said "Wallet used"
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
            isTransfer ? '~${currency.format(amount)}' : '${isExpense ? "-" : "+"}${currency.format(amount)}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: isTransfer ? theme.transferColor : (isExpense ? theme.expenseColor : theme.incomeColor),
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
