import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';

class QuickRecordRepository {
  final Ref ref;

  QuickRecordRepository(this.ref);

  Future<List<Category>> getAllCategories() async {
    // Read the FutureProvider here
    final categoryRepo = await ref.read(categoryRepositoryProvider.future);
    return await categoryRepo.getAllCategories();
  }

  Future<List<Wallet>> getAllWallets() async {
    final walletRepo = await ref.read(walletRepositoryProvider.future);
    return await walletRepo.getAllWallets();
  }
}

final quickRecordRepositoryProvider = Provider<QuickRecordRepository>((ref) {
  return QuickRecordRepository(ref);
});
