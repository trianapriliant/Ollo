import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/smart_note.dart';

final smartNoteRepositoryProvider = Provider<SmartNoteRepository>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return SmartNoteRepository(isar);
});

final smartNoteListProvider = StreamProvider<List<SmartNote>>((ref) {
  final repository = ref.watch(smartNoteRepositoryProvider);
  return repository.watchNotes();
});

class SmartNoteRepository {
  final Isar _isar;

  SmartNoteRepository(this._isar);

  Stream<List<SmartNote>> watchNotes() {
    // Sort by: Not completed first, then by creation date desc
    return _isar.smartNotes.where().sortByIsCompleted().thenByCreatedAtDesc().watch(fireImmediately: true);
  }

  Future<void> addNote(SmartNote note) async {
    await _isar.writeTxn(() async {
      await _isar.smartNotes.put(note);
    });
  }

  Future<void> updateNote(SmartNote note) async {
    await _isar.writeTxn(() async {
      await _isar.smartNotes.put(note);
    });
  }

  Future<void> deleteNote(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.smartNotes.delete(id);
    });
  }

  Future<void> toggleComplete(Id id, {bool? isCompleted}) async {
    await _isar.writeTxn(() async {
      final note = await _isar.smartNotes.get(id);
      if (note != null) {
        note.isCompleted = isCompleted ?? !note.isCompleted;
        await _isar.smartNotes.put(note);
      }
    });
  }
}
