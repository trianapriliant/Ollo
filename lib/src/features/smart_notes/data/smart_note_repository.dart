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

  Future<void> toggleComplete(Id id, {bool? isCompleted, int? transactionId}) async {
    await _isar.writeTxn(() async {
      final note = await _isar.smartNotes.get(id);
      if (note != null) {
        note.isCompleted = isCompleted ?? !note.isCompleted;
        if (transactionId != null) {
          note.transactionId = transactionId;
        } else if (note.isCompleted == false) {
           // If unchecking, we might want to clear the transaction ID if we are deleting it
           // But the logic in UI will handle deletion. 
           // We can optionally clear it here if passed as null explicitly? 
           // For now, let's just update if provided.
           // Actually, if we uncheck, we should probably clear it.
           // Let's rely on the UI passing null or a specific value? 
           // No, let's keep it simple: if transactionId is passed, set it.
           // If we want to clear it, we might need another mechanism or pass 0?
           // Let's just add the setter for now.
        }
        // If unchecking, we should clear the transaction ID
        if (note.isCompleted == false) {
          note.transactionId = null;
        }
        await _isar.smartNotes.put(note);
      }
    });
  }
}
