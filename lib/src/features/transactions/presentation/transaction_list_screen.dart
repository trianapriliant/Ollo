import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
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
          title: Text(AppLocalizations.of(context)!.transactions, style: AppTextStyles.h2),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.expense),
              Tab(text: AppLocalizations.of(context)!.income),
              Tab(text: AppLocalizations.of(context)!.transfer),
              Tab(text: AppLocalizations.of(context)!.system),
            ],
          ),
        ),
        body: transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noTransactionsFound));
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
          error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.error(err.toString()))),
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
      return Center(child: Text(AppLocalizations.of(context)!.noTransactionsInCategory));
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
