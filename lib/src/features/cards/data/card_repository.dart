import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/card.dart';

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return CardRepository(isar);
});

final cardListProvider = StreamProvider<List<BankCard>>((ref) {
  final repository = ref.watch(cardRepositoryProvider);
  return repository.watchCards();
});

class CardRepository {
  final Isar _isar;

  CardRepository(this._isar);

  Stream<List<BankCard>> watchCards() {
    return _isar.bankCards.where().sortByIsPinnedDesc().thenByName().watch(fireImmediately: true);
  }

  Future<void> addCard(BankCard card) async {
    await _isar.writeTxn(() async {
      await _isar.bankCards.put(card);
    });
  }

  Future<void> updateCard(BankCard card) async {
    await _isar.writeTxn(() async {
      await _isar.bankCards.put(card);
    });
  }

  Future<void> deleteCard(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.bankCards.delete(id);
    });
  }

  Future<void> togglePin(Id id) async {
    await _isar.writeTxn(() async {
      final card = await _isar.bankCards.get(id);
      if (card != null) {
        card.isPinned = !card.isPinned;
        await _isar.bankCards.put(card);
      }
    });
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.bankCards.clear();
    });
  }

  Future<void> importAll(List<BankCard> cards) async {
    await _isar.writeTxn(() async {
      await _isar.bankCards.putAll(cards);
    });
  }
}
