import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/saving_goal.dart';
import '../domain/saving_log.dart';

abstract class SavingRepository {
  Future<void> addSavingGoal(SavingGoal goal);
  Future<void> updateSavingGoal(SavingGoal goal);
  Future<void> deleteSavingGoal(Id id);
  Stream<List<SavingGoal>> watchSavingGoals();
  Future<List<SavingGoal>> getSavingGoals();
  Future<SavingGoal?> getSavingGoal(Id id);
  
  // Logs
  Future<void> addLog(SavingLog log);
  Future<List<SavingLog>> getLogsForGoal(int goalId);
  Future<List<SavingLog>> getAllLogs();
  Stream<List<SavingLog>> watchAllLogs();
  Future<void> clearAll();
  Future<void> importAll(List<SavingGoal> goals, List<SavingLog> logs);
}

class IsarSavingRepository implements SavingRepository {
  final Isar isar;

  IsarSavingRepository(this.isar);

  @override
  Future<void> addSavingGoal(SavingGoal goal) async {
    await isar.writeTxn(() async {
      await isar.savingGoals.put(goal);
    });
  }

  @override
  Future<void> updateSavingGoal(SavingGoal goal) async {
    await isar.writeTxn(() async {
      await isar.savingGoals.put(goal);
    });
  }

  @override
  Future<void> deleteSavingGoal(Id id) async {
    await isar.writeTxn(() async {
      await isar.savingGoals.delete(id);
    });
  }

  @override
  Stream<List<SavingGoal>> watchSavingGoals() {
    return isar.savingGoals.where().watch(fireImmediately: true);
  }

  @override
  Future<List<SavingGoal>> getSavingGoals() async {
    return isar.savingGoals.where().findAll();
  }

  @override
  Future<SavingGoal?> getSavingGoal(Id id) async {
    return isar.savingGoals.get(id);
  }

  @override
  Future<void> addLog(SavingLog log) async {
    await isar.writeTxn(() async {
      await isar.savingLogs.put(log);
    });
  }

  @override
  Future<List<SavingLog>> getLogsForGoal(int goalId) async {
    return isar.savingLogs.filter().savingGoalIdEqualTo(goalId).findAll();
  }

  @override
  Future<List<SavingLog>> getAllLogs() async {
    return isar.savingLogs.where().findAll();
  }

  @override
  Stream<List<SavingLog>> watchAllLogs() {
    return isar.savingLogs.where().watch(fireImmediately: true);
  }

  @override
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.savingLogs.clear();
      await isar.savingGoals.clear();
    });
  }

  @override
  Future<void> importAll(List<SavingGoal> goals, List<SavingLog> logs) async {
    await isar.writeTxn(() async {
      await isar.savingGoals.putAll(goals);
      await isar.savingLogs.putAll(logs);
    });
  }
}

final savingRepositoryProvider = Provider<IsarSavingRepository>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return IsarSavingRepository(isar);
});

final savingListProvider = StreamProvider<List<SavingGoal>>((ref) {
  final repo = ref.watch(savingRepositoryProvider);
  return repo.watchSavingGoals();
});

final savingLogListProvider = StreamProvider<List<SavingLog>>((ref) {
  final repo = ref.watch(savingRepositoryProvider);
  return repo.watchAllLogs();
});
