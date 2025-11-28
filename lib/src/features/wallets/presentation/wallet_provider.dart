import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/wallet_repository.dart';
import '../domain/wallet.dart';

final walletListProvider = StreamProvider<List<Wallet>>((ref) {
  final repository = ref.watch(walletRepositoryProvider).valueOrNull;
  if (repository == null) return const Stream.empty();
  return repository.watchWallets();
});

final totalBalanceProvider = Provider<AsyncValue<double>>((ref) {
  final walletsAsync = ref.watch(walletListProvider);
  return walletsAsync.whenData((wallets) => wallets.fold(0, (sum, w) => sum + w.balance));
});
