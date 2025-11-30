import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/bill.dart';

class BillRepository {
  final Isar isar;

  BillRepository(this.isar);

  Future<void> addBill(Bill bill) async {
    await isar.writeTxn(() async {
      await isar.bills.put(bill);
    });
  }

  Future<void> updateBill(Bill bill) async {
    await isar.writeTxn(() async {
      await isar.bills.put(bill);
    });
  }

  Future<void> deleteBill(Id id) async {
    await isar.writeTxn(() async {
      await isar.bills.delete(id);
    });
  }

  Future<List<Bill>> getAllBills() async {
    return await isar.bills.where().findAll();
  }

  Future<List<Bill>> getUnpaidBills() async {
    return await isar.bills
        .filter()
        .statusEqualTo(BillStatus.unpaid)
        .or()
        .statusEqualTo(BillStatus.overdue)
        .sortByDueDate()
        .findAll();
  }
  
  Future<List<Bill>> getPaidBills() async {
    return await isar.bills
        .filter()
        .statusEqualTo(BillStatus.paid)
        .sortByPaidAtDesc()
        .findAll();
  }

  Stream<List<Bill>> watchUnpaidBills() {
    return isar.bills
        .filter()
        .statusEqualTo(BillStatus.unpaid)
        .or()
        .statusEqualTo(BillStatus.overdue)
        .sortByDueDate()
        .watch(fireImmediately: true);
  }
}

final billRepositoryProvider = Provider<BillRepository>((ref) {
  final isar = ref.watch(isarProvider).valueOrNull;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return BillRepository(isar);
});
