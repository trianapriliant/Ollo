import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../transaction_provider.dart';
import '../../../settings/presentation/currency_provider.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);
    final currencySymbol = ref.watch(currencyProvider).symbol;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions', style: AppTextStyles.h2),
            TextButton(
              onPressed: () {},
              child: Text('See All', style: AppTextStyles.bodyMedium),
            ),
          ],
        ),
        const SizedBox(height: 16),
        transactionsAsync.when(
          data: (transactions) {
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
            // Take only last 5 transactions for dashboard
            final recentTransactions = transactions.take(5).toList();

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                final dateStr = "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}";

                return _buildActivityItem(
                  transaction.title,
                  dateStr,
                  transaction.amount,
                  Icons.shopping_bag,
                  transaction.isExpense,
                  currencySymbol,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String date, double amount, IconData icon, bool isExpense, String currencySymbol) {
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
              color: isExpense ? AppColors.accentPurple : AppColors.accentBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(date, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isExpense ? "-" : "+"}$currencySymbol $amount',
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
