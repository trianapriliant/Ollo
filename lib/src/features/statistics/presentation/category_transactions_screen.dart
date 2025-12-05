import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../dashboard/presentation/transaction_provider.dart';
import '../../dashboard/presentation/widgets/recent_transactions_list.dart';
import '../../transactions/domain/transaction.dart';
import 'statistics_provider.dart';

class CategoryTransactionsScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;
  final DateTime filterDate;
  final TimeRange filterTimeRange;
  final bool isExpense;

  const CategoryTransactionsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.filterDate,
    required this.filterTimeRange,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          categoryName,
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          // Filter transactions
          final filteredTransactions = transactions.where((t) {
            // 1. Filter by Type
            if (t.isExpense != isExpense) return false;

            // 2. Filter by Category
            // Handle system categories or standard categories
            bool matchCategory = false;
            if (categoryId == 'bills') {
               matchCategory = t.categoryId == 'bills' || (t.isSystem && t.title.toLowerCase().contains('bill'));
            } else if (categoryId == 'wishlist') {
               matchCategory = t.categoryId == 'wishlist' || (t.isSystem && t.title.toLowerCase().contains('wishlist'));
            } else if (categoryId == 'debt') {
               matchCategory = t.categoryId == 'debt' || (t.isSystem && (t.title.toLowerCase().contains('borrowed') || t.title.toLowerCase().contains('lent') || t.title.toLowerCase().contains('debt') || t.title.toLowerCase().contains('received payment')));
            } else if (categoryId == 'notes') {
               matchCategory = ['notes', 'note', 'Smart Notes', 'Smart Note', 'smart notes', 'smart note'].contains(t.categoryId) || (t.isSystem && t.title.toLowerCase().contains('note'));
            } else {
               matchCategory = t.categoryId == categoryId;
            }
            
            if (!matchCategory) return false;

            // 3. Filter by Time Range
            if (filterTimeRange == TimeRange.month) {
              return t.date.year == filterDate.year && t.date.month == filterDate.month;
            } else {
              return t.date.year == filterDate.year;
            }
          }).toList();

          if (filteredTransactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No transactions found",
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // Sort by date descending
          filteredTransactions.sort((a, b) => b.date.compareTo(a.date));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: RecentTransactionsList(transactions: filteredTransactions),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
