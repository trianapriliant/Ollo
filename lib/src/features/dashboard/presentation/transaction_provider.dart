import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';

final transactionListProvider = StreamProvider<List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider).value;
  if (repository == null) return const Stream.empty();
  return repository.watchTransactions();
});

