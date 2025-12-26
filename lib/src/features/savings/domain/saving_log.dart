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
  
  int? transactionId; // Link to Transaction for cascade delete

  SavingLog({
    this.id = Isar.autoIncrement,
    required this.savingGoalId,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
    this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'savingGoalId': savingGoalId,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
      'note': note,
      'transactionId': transactionId,
    };
  }

  factory SavingLog.fromJson(Map<String, dynamic> json) {
    return SavingLog(
      savingGoalId: json['savingGoalId'] as int,
      amount: (json['amount'] as num).toDouble(),
      type: SavingLogType.values.firstWhere((e) => e.name == json['type']),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
      transactionId: json['transactionId'] as int?,
    )..id = json['id'] as int;
  }
}
