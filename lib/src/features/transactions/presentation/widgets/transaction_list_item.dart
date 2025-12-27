import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../common_widgets/modern_confirm_dialog.dart';
import '../../domain/transaction.dart';
import '../../../../utils/icon_helper.dart';
import '../../../../features/settings/presentation/icon_pack_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../data/transaction_repository.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../settings/domain/transaction_color_theme.dart';

class TransactionListItem extends ConsumerWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');
    final colorTheme = ref.watch(colorPaletteProvider);

    final isSystem = transaction.type == TransactionType.system;
    
    final isBill = (transaction.categoryId == 'bills') || (isSystem && transaction.title.toLowerCase().contains('bill'));
    final isWishlist = (transaction.categoryId == 'wishlist') || (isSystem && transaction.title.toLowerCase().contains('wishlist'));
    final isDebt = (transaction.categoryId == 'debt') || (isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('lent') || transaction.title.toLowerCase().contains('debt') || transaction.title.toLowerCase().contains('received payment')));
    
    final isNote = (transaction.categoryId == 'notes') || (transaction.categoryId == 'note') || (transaction.categoryId == 'Smart Notes') || (transaction.categoryId == 'Smart Note') || (isSystem && transaction.title.toLowerCase().contains('note'));
    
    final isSavings = isSystem && (transaction.title.toLowerCase().contains('deposit to') || transaction.title.toLowerCase().contains('withdraw from') || transaction.title.toLowerCase().contains('savings'));

    final iconPack = ref.watch(iconPackProvider);

    String? dynamicIconPath;
    IconData? staticIconData;
    Color? iconColor;
    Color? backgroundColor;

    if (isBill) {
      dynamicIconPath = 'bill';
      iconColor = Colors.orange;
      backgroundColor = Colors.orange.withOpacity(0.1);
    } else if (isWishlist) {
      dynamicIconPath = 'favorite';
      iconColor = Colors.pinkAccent;
      backgroundColor = Colors.pinkAccent.withOpacity(0.1);
    } else if (isDebt) {
      dynamicIconPath = 'debts';
      iconColor = Colors.purple;
      backgroundColor = Colors.purple.withOpacity(0.1);
    } else if (isNote) {
      dynamicIconPath = 'notes';
      iconColor = Colors.teal;
      backgroundColor = Colors.teal.withOpacity(0.1);
    } else if (isSystem) {
      if (isSavings) {
        dynamicIconPath = 'savings';
        iconColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
      } else {
        dynamicIconPath = 'settings';
        iconColor = Colors.grey;
        backgroundColor = Colors.grey.withOpacity(0.1);
      }
    } else {
      // DYNAMIC DEFAULT COLORS BASED ON THEME
      final defaultIcon = transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward;
      final defaultColor = transaction.isExpense ? colorTheme.expenseColor : colorTheme.incomeColor;
      
      final categoryType = transaction.isExpense ? CategoryType.expense : CategoryType.income;
      final categoriesAsync = ref.watch(categoryListProvider(categoryType));
      final categories = categoriesAsync.valueOrNull;

      if (categories != null) {
        try {
          final mainCategory = categories.firstWhere(
            (c) => (c.externalId ?? c.id.toString()) == transaction.categoryId
          );
          
          iconColor = mainCategory.color;
          backgroundColor = iconColor!.withOpacity(0.1);

          if (transaction.subCategoryId != null) {
            final sub = mainCategory.subCategories?.firstWhere(
              (s) => s.id == transaction.subCategoryId, 
              orElse: () => SubCategory() 
            );
            
            if (sub != null && sub.id != null) {
              dynamicIconPath = sub.iconPath ?? mainCategory.iconPath;
            }
          }
          
          if (dynamicIconPath == null) {
            dynamicIconPath = mainCategory.iconPath;
          }
          
        } catch (e) {
          // Fallback
        }
      }

      if (dynamicIconPath == null && transaction.subCategoryIcon != null) {
         dynamicIconPath = transaction.subCategoryIcon!;
         iconColor ??= defaultColor;
         backgroundColor ??= iconColor!.withOpacity(0.1);
      }

      if (dynamicIconPath == null && staticIconData == null) {
          staticIconData = defaultIcon;
      }
      
      iconColor ??= defaultColor;
      backgroundColor ??= iconColor!.withOpacity(0.1);
    }

    final Widget iconWidget = dynamicIconPath != null 
        ? IconHelper.getIconWidget(dynamicIconPath, pack: iconPack, color: iconColor)
        : Icon(staticIconData ?? Icons.help_outline, color: iconColor);

    final isDebtIncome = isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('received payment'));
    final isSavingsWithdraw = isSystem && transaction.title.toLowerCase().contains('withdraw from');
    final isExpenseDisplay = (transaction.isExpense || isSystem) && !isDebtIncome && !isSavingsWithdraw;

    String displayTitle = transaction.title;
    
    // DETERMINE TEXT COLOR BASED ON TYPE AND THEME
    Color textColor;
    if (transaction.type == TransactionType.transfer) {
      displayTitle = AppLocalizations.of(context)!.transferTransaction;
      textColor = colorTheme.transferColor;
    } else if (isExpenseDisplay) {
      textColor = colorTheme.expenseColor;
    } else {
      textColor = colorTheme.incomeColor;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: backgroundColor,
              child: iconWidget,
            ),
            title: Text(displayTitle, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text(
              isBill ? 'Bill Payment' : (isDebt ? 'Debt Transaction' : (isSavings ? 'Savings Transaction' : (isWishlist ? 'Wishlist Purchase' : dateFormat.format(transaction.date)))), 
              style: AppTextStyles.bodySmall
            ),
            trailing: Text(
              currencyFormat.format(transaction.amount),
              style: AppTextStyles.bodyLarge.copyWith(
                color: textColor, // DYNAMIC COLOR
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => context.push('/transaction-detail', extra: transaction),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showModernConfirmDialog(
      context: context,
      title: 'Delete Transaction',
      message: 'Are you sure you want to delete this transaction? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      type: ConfirmDialogType.delete,
    );
  }
}
