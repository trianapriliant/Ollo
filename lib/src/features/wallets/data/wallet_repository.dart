import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/wallet.dart';

abstract class WalletRepository {
  Future<void> addWallet(Wallet wallet);
  Future<List<Wallet>> getAllWallets();
  Stream<List<Wallet>> watchWallets();
  Future<Wallet?> getWallet(String id);
}

class InMemoryWalletRepository implements WalletRepository {
  final List<Wallet> _data = [];
  final _controller = StreamController<List<Wallet>>.broadcast();

  InMemoryWalletRepository() {
    _data.add(Wallet()
      ..id = 'cash_default'
      ..name = 'Cash'
      ..balance = 0.0
      ..iconPath = 'money' // Placeholder
      ..type = WalletType.cash);
    _controller.add(List.from(_data));
  }

  @override
  Future<void> addWallet(Wallet wallet) async {
    final index = _data.indexWhere((w) => w.id == wallet.id);
    if (index != -1) {
      _data[index] = wallet; // Update existing
    } else {
      _data.add(wallet); // Add new
    }
    _controller.add(List.from(_data));
  }

  @override
  Future<Wallet?> getWallet(String id) async {
    try {
      return _data.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Wallet>> getAllWallets() async {
    return List.from(_data);
  }

  @override
  Stream<List<Wallet>> watchWallets() async* {
    yield List.from(_data);
    yield* _controller.stream;
  }
}

final walletRepositoryProvider = FutureProvider<WalletRepository>((ref) async {
  return InMemoryWalletRepository();
});
