import 'package:isar/isar.dart';

part 'saving_log.g.dart';

enum SavingLogType { deposit, withdraw, interest }

@collection
class SavingLog {
  Id id = Isar.autoIncrement;

  late int savingGoalId; // Link to SavingGoal
  late double amount;
  
  @Enumerated(EnumType.name)
  late SavingLogType type;
  
  late DateTime date;
  
  String? note;

  SavingLog({
    this.id = Isar.autoIncrement,
    required this.savingGoalId,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });
}
