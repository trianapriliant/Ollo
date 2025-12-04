import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/data/isar_provider.dart';
import '../domain/debt.dart';

final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final isar = ref.watch(isarProvider).valueOrNull;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return DebtRepository(isar);
});

final debtListProvider = StreamProvider<List<Debt>>((ref) {
  final repository = ref.watch(debtRepositoryProvider);
  return repository.watchDebts();
});

class DebtRepository {
  final Isar _isar;

  DebtRepository(this._isar);

  Future<void> addDebt(Debt debt) async {
    await _isar.writeTxn(() async {
      await _isar.debts.put(debt);
    });
  }

  Future<void> updateDebt(Debt debt) async {
    await _isar.writeTxn(() async {
      await _isar.debts.put(debt);
    });
  }

  Future<void> deleteDebt(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.debts.delete(id);
    });
  }

  Future<List<Debt>> getAllDebts() async {
    return await _isar.debts.where().sortByDueDate().findAll();
  }

  Stream<List<Debt>> watchDebts() {
    return _isar.debts.where().sortByDueDate().watch(fireImmediately: true);
  }

  Stream<List<Debt>> watchDebtsByType(DebtType type) {
    return _isar.debts.filter().typeEqualTo(type).sortByDueDate().watch(fireImmediately: true);
  }
  Future<Debt?> getDebtByTransactionId(int transactionId) async {
    return await _isar.debts
        .filter()
        .transactionIdEqualTo(transactionId)
        .findFirst();
  }
}
