import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/recurring_transaction.dart';

abstract class RecurringRepository {
  Future<List<RecurringTransaction>> getAllRecurringTransactions();
  Future<List<RecurringTransaction>> getActiveRecurringTransactions();
  Future<void> addRecurringTransaction(RecurringTransaction transaction);
  Future<void> updateRecurringTransaction(RecurringTransaction transaction);
  Future<void> deleteRecurringTransaction(int id);
  Future<double> calculateMonthlyCommitment();
  Future<void> clearAll();
  Future<void> importAll(List<RecurringTransaction> transactions);
}

class IsarRecurringRepository implements RecurringRepository {
  final Isar isar;

  IsarRecurringRepository(this.isar);

  @override
  Future<List<RecurringTransaction>> getAllRecurringTransactions() async {
    return await isar.recurringTransactions.where().findAll();
  }

  @override
  Future<List<RecurringTransaction>> getActiveRecurringTransactions() async {
    return await isar.recurringTransactions.filter().isActiveEqualTo(true).findAll();
  }

  @override
  Future<void> addRecurringTransaction(RecurringTransaction transaction) async {
    await isar.writeTxn(() async {
      await isar.recurringTransactions.put(transaction);
    });
  }

  @override
  Future<void> updateRecurringTransaction(RecurringTransaction transaction) async {
    await isar.writeTxn(() async {
      await isar.recurringTransactions.put(transaction);
    });
  }

  @override
  Future<void> deleteRecurringTransaction(int id) async {
    await isar.writeTxn(() async {
      await isar.recurringTransactions.delete(id);
    });
  }

  @override
  Future<double> calculateMonthlyCommitment() async {
    final activeTransactions = await getActiveRecurringTransactions();
    double totalMonthly = 0;

    for (var tx in activeTransactions) {
      switch (tx.frequency) {
        case RecurringFrequency.daily:
          totalMonthly += tx.amount * 30;
          break;
        case RecurringFrequency.weekly:
          totalMonthly += tx.amount * 4;
          break;
        case RecurringFrequency.monthly:
          totalMonthly += tx.amount;
          break;
        case RecurringFrequency.yearly:
          totalMonthly += tx.amount / 12;
          break;
      }
    }
    return totalMonthly;
  }

  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.recurringTransactions.clear();
    });
  }

  Future<void> importAll(List<RecurringTransaction> transactions) async {
    await isar.writeTxn(() async {
      await isar.recurringTransactions.putAll(transactions);
    });
  }
}

final recurringRepositoryProvider = Provider<RecurringRepository>((ref) {
  final isar = ref.watch(isarProvider).valueOrNull;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return IsarRecurringRepository(isar);
});

final recurringListProvider = StreamProvider<List<RecurringTransaction>>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  
  // Yield initial
  yield await isar.recurringTransactions.where().findAll();

  // Watch changes
  await for (final _ in isar.recurringTransactions.watchLazy()) {
    yield await isar.recurringTransactions.where().findAll();
  }
});
