import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../domain/transaction.dart';
import '../../../../utils/icon_helper.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';

class TransactionListItem extends ConsumerWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    final isSystem = transaction.type == TransactionType.system;
    
    // Check for Bills, Wishlist, and Debt via Category ID (New Logic) OR System Type (Legacy Logic)
    final isBill = (transaction.categoryId == 'bills') || (isSystem && transaction.title.toLowerCase().contains('bill'));
    final isWishlist = (transaction.categoryId == 'wishlist') || (isSystem && transaction.title.toLowerCase().contains('wishlist'));
    final isDebt = (transaction.categoryId == 'debt') || (isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('lent') || transaction.title.toLowerCase().contains('debt') || transaction.title.toLowerCase().contains('received payment')));
    
    final isNote = (transaction.categoryId == 'notes') || (transaction.categoryId == 'note') || (transaction.categoryId == 'Smart Notes') || (transaction.categoryId == 'Smart Note') || (isSystem && transaction.title.toLowerCase().contains('note'));
    
    final isSavings = isSystem && (transaction.title.toLowerCase().contains('deposit to') || transaction.title.toLowerCase().contains('withdraw from') || transaction.title.toLowerCase().contains('savings'));

    IconData? iconData;
    Color? iconColor;
    Color? backgroundColor;

    if (isBill) {
      iconData = Icons.receipt_long_rounded;
      iconColor = Colors.orange;
      backgroundColor = Colors.orange.withOpacity(0.1);
    } else if (isWishlist) {
      iconData = Icons.favorite_rounded;
      iconColor = Colors.pinkAccent;
      backgroundColor = Colors.pinkAccent.withOpacity(0.1);
    } else if (isDebt) {
      iconData = Icons.handshake_rounded;
      iconColor = Colors.purple;
      backgroundColor = Colors.purple.withOpacity(0.1);
    } else if (isNote) {
      iconData = Icons.edit_note_rounded;
      iconColor = Colors.teal;
      backgroundColor = Colors.teal.withOpacity(0.1);
    } else if (isSystem) {
      if (isSavings) {
        iconData = Icons.savings_rounded;
        iconColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
      } else {
        // Fallback for other system types
        iconData = Icons.settings;
        iconColor = Colors.grey;
        backgroundColor = Colors.grey.withOpacity(0.1);
      }
    } else {
      // ---------------------------------------------------------
      // ICON RESOLUTION LOGIC
      // ---------------------------------------------------------
      
      // 0. Prepare Fallbacks
      final defaultIcon = transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward;
      final defaultColor = transaction.isExpense ? Colors.red : Colors.green;
      
      // 1. Fresh Lookup
      // We need to fetch the category list to find the current icon
      final categoryType = transaction.isExpense ? CategoryType.expense : CategoryType.income;
      final categoriesAsync = ref.watch(categoryListProvider(categoryType));
      final categories = categoriesAsync.valueOrNull;

      if (categories != null) {
        try {
          // Find Main Category
          final mainCategory = categories.firstWhere(
            (c) => (c.externalId ?? c.id.toString()) == transaction.categoryId
          );
          
          iconColor = mainCategory.color;
          backgroundColor = iconColor!.withOpacity(0.1);

          // Find Sub Category
          if (transaction.subCategoryId != null) {
            final sub = mainCategory.subCategories?.firstWhere(
              (s) => s.id == transaction.subCategoryId, 
              orElse: () => SubCategory() // Return empty if not found
            );
            
            if (sub != null && sub.id != null) {
              // Found active sub-category
              iconData = IconHelper.getIcon(sub.iconPath ?? mainCategory.iconPath);
            }
          }
          
          // If no sub-category icon found yet, use Main Category Icon
          if (iconData == null) {
            iconData = IconHelper.getIcon(mainCategory.iconPath);
          }
          
        } catch (e) {
          // Category not found in fresh list (deleted?)
          // Proceed to Snapshot Fallback
        }
      }

      // 2. Snapshot Fallback
      if (iconData == null && transaction.subCategoryIcon != null) {
         iconData = IconHelper.getIcon(transaction.subCategoryIcon!);
         // We might not have color if category is gone, so use default
         iconColor ??= defaultColor;
         backgroundColor ??= iconColor!.withOpacity(0.1);
      }

      // 3. Generic/Default Fallback
      iconData ??= defaultIcon;
      iconColor ??= defaultColor;
      backgroundColor ??= iconColor!.withOpacity(0.1);
    }

    // Determine if it's an expense or income for display purposes
    // System defaults to expense, but Debt can be income
    final isDebtIncome = isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('received payment'));
    final isSavingsWithdraw = isSystem && transaction.title.toLowerCase().contains('withdraw from');
    final isExpenseDisplay = (transaction.isExpense || isSystem) && !isDebtIncome && !isSavingsWithdraw;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(transaction.title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(
          isBill ? 'Bill Payment' : (isDebt ? 'Debt Transaction' : (isSavings ? 'Savings Transaction' : (isWishlist ? 'Wishlist Purchase' : dateFormat.format(transaction.date)))), 
          style: AppTextStyles.bodySmall
        ),
        trailing: Text(
          currencyFormat.format(transaction.amount),
          style: AppTextStyles.bodyLarge.copyWith(
            color: isExpenseDisplay ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => context.push('/transaction-detail', extra: transaction),
      ),
    );
  }
}
