import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_text_styles.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/presentation/widgets/transaction_list_item.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions', style: AppTextStyles.h2),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions found'));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionListItem(transaction: transaction);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
