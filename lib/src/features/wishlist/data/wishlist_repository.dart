import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/wishlist.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final isar = ref.watch(isarProvider).valueOrNull;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return WishlistRepository(isar);
});

class WishlistRepository {
  final Isar _isar;

  WishlistRepository(this._isar);

  Future<void> addWishlist(Wishlist wishlist) async {
    await _isar.writeTxn(() async {
      await _isar.wishlists.put(wishlist);
    });
  }

  Future<void> updateWishlist(Wishlist wishlist) async {
    await _isar.writeTxn(() async {
      await _isar.wishlists.put(wishlist);
    });
  }

  Future<void> deleteWishlist(int id) async {
    await _isar.writeTxn(() async {
      await _isar.wishlists.delete(id);
    });
  }

  Stream<List<Wishlist>> watchAllWishlists() {
    return _isar.wishlists.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  Future<List<Wishlist>> getAllWishlists() async {
    return await _isar.wishlists.where().sortByCreatedAtDesc().findAll();
  }
  Future<Wishlist?> getWishlistByTransactionId(int transactionId) async {
    return await _isar.wishlists
        .filter()
        .transactionIdEqualTo(transactionId)
        .findFirst();
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.wishlists.clear();
    });
  }

  Future<void> importAll(List<Wishlist> wishlists) async {
    await _isar.writeTxn(() async {
      await _isar.wishlists.putAll(wishlists);
    });
  }
}
