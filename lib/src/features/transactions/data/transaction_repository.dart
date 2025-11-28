import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Future<List<Transaction>> getAllTransactions();
  Stream<List<Transaction>> watchTransactions();
}

class InMemoryTransactionRepository implements TransactionRepository {
  final List<Transaction> _data = [];
  final _controller = StreamController<List<Transaction>>.broadcast();

  InMemoryTransactionRepository() {
    _controller.add([]);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    _data.add(transaction);
    // Sort by date desc
    _data.sort((a, b) => b.date.compareTo(a.date));
    _controller.add(List.from(_data));
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return List.from(_data);
  }

  @override
  Stream<List<Transaction>> watchTransactions() async* {
    yield List.from(_data);
    yield* _controller.stream;
  }
}

final transactionRepositoryProvider = FutureProvider<TransactionRepository>((ref) async {
  return InMemoryTransactionRepository();
});
