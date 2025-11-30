import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/wallet.dart';

import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';

abstract class WalletRepository {
  Future<void> addWallet(Wallet wallet);
  Future<void> updateWallet(Wallet wallet);
  Future<List<Wallet>> getAllWallets();
  Stream<List<Wallet>> watchWallets();
  Future<Wallet?> getWallet(String id);
}

class IsarWalletRepository implements WalletRepository {
  final Isar isar;

  IsarWalletRepository(this.isar);

  @override
  Future<void> addWallet(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
  }

  @override
  Future<void> updateWallet(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
  }

  @override
  Future<Wallet?> getWallet(String id) async {
    // Try to parse as int (Isar ID)
    final intId = int.tryParse(id);
    if (intId != null) {
      return isar.wallets.get(intId);
    }
    // Otherwise try to find by externalId (e.g. 'cash_default')
    return isar.wallets.filter().externalIdEqualTo(id).findFirst();
  }

  @override
  Future<List<Wallet>> getAllWallets() async {
    return isar.wallets.where().findAll();
  }

  @override
  Stream<List<Wallet>> watchWallets() {
    return isar.wallets.where().watch(fireImmediately: true);
  }
}

final walletRepositoryProvider = FutureProvider<WalletRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarWalletRepository(isar);
});
