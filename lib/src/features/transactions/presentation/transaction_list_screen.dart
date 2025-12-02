import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_text_styles.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/presentation/widgets/transaction_list_item.dart';

import '../../transactions/domain/transaction.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionStreamProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transactions', style: AppTextStyles.h2),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
              Tab(text: 'Transfer'),
              Tab(text: 'System'),
            ],
          ),
        ),
        body: transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Center(child: Text('No transactions found'));
            }

            final expenseTransactions = transactions.where((t) => t.type == TransactionType.expense).toList();
            final incomeTransactions = transactions.where((t) => t.type == TransactionType.income).toList();
            final transferTransactions = transactions.where((t) => t.type == TransactionType.transfer).toList();
            final systemTransactions = transactions.where((t) => t.type == TransactionType.system).toList();

            return TabBarView(
              children: [
                _TransactionList(transactions: expenseTransactions),
                _TransactionList(transactions: incomeTransactions),
                _TransactionList(transactions: transferTransactions),
                _TransactionList(transactions: systemTransactions),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions in this category'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionListItem(transaction: transaction);
      },
    );
  }
}
