import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/transactions/domain/transaction.dart';
import '../features/wallets/domain/wallet.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TransactionSchema, WalletSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

final isarProvider = FutureProvider<Isar>((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  return isarService.db;
});
