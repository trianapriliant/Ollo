import 'package:isar/isar.dart';

part 'recurring_transaction.g.dart';

enum RecurringFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}

@collection
class RecurringTransaction {
  Id id = Isar.autoIncrement;

  double amount;
  String categoryId;
  String walletId;
  String? note;

  @enumerated
  RecurringFrequency frequency;

  DateTime startDate;
  DateTime nextDueDate;
  bool isActive;

  RecurringTransaction({
    required this.amount,
    required this.categoryId,
    required this.walletId,
    this.note,
    required this.frequency,
    required this.startDate,
    required this.nextDueDate,
    this.isActive = true,
  });
}
