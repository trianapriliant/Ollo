import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction.dart';

import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(Id id);
  Future<List<Transaction>> getAllTransactions();
  Stream<List<Transaction>> watchTransactions();
}

class IsarTransactionRepository implements TransactionRepository {
  final Isar isar;

  IsarTransactionRepository(this.isar);

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  @override
  Future<void> deleteTransaction(Id id) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(id);
    });
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return isar.transactions.where().sortByDateDesc().findAll();
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return isar.transactions.where().sortByDateDesc().watch(fireImmediately: true);
  }
}

final transactionRepositoryProvider = FutureProvider<TransactionRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarTransactionRepository(isar);
});

final transactionStreamProvider = StreamProvider<List<Transaction>>((ref) async* {
  final repository = await ref.watch(transactionRepositoryProvider.future);
  yield* repository.watchTransactions();
});
