import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../domain/transaction.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    final isSystem = transaction.type == TransactionType.system;
    final isWishlist = isSystem && transaction.title.toLowerCase().contains('wishlist');
    final isBill = isSystem && transaction.title.toLowerCase().contains('bill');
    final isDebt = isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('lent') || transaction.title.toLowerCase().contains('debt') || transaction.title.toLowerCase().contains('received payment'));

    IconData iconData;
    Color iconColor;
    Color backgroundColor;

    if (isSystem) {
      if (isBill) {
        iconData = Icons.receipt_long_rounded;
        iconColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
      } else if (isDebt) {
        iconData = Icons.handshake_rounded;
        iconColor = Colors.purple;
        backgroundColor = Colors.purple.withOpacity(0.1);
      } else {
        iconData = Icons.favorite_rounded;
        iconColor = Colors.pinkAccent;
        backgroundColor = Colors.pinkAccent.withOpacity(0.1);
      }
    } else {
      iconData = transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward;
      iconColor = transaction.isExpense ? Colors.red : Colors.green;
      backgroundColor = transaction.isExpense ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1);
    }

    // Determine if it's an expense or income for display purposes
    // System defaults to expense, but Debt can be income
    final isDebtIncome = isSystem && (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('received payment'));
    final isExpenseDisplay = (transaction.isExpense || isSystem) && !isDebtIncome;

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
          isBill ? 'Bill Payment' : (isDebt ? 'Debt Transaction' : (isWishlist ? 'Wishlist Purchase' : dateFormat.format(transaction.date))), 
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
