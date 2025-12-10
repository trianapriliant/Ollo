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
    this.createBillOnly = false,
  });

  bool createBillOnly;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'walletId': walletId,
      'note': note,
      'frequency': frequency.name,
      'startDate': startDate.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
      'isActive': isActive,
      'createBillOnly': createBillOnly,
    };
  }

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) {
    return RecurringTransaction(
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      walletId: json['walletId'] as String,
      note: json['note'] as String?,
      frequency: RecurringFrequency.values.firstWhere((e) => e.name == json['frequency']),
      startDate: DateTime.parse(json['startDate'] as String),
      nextDueDate: DateTime.parse(json['nextDueDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createBillOnly: json['createBillOnly'] as bool? ?? false,
    )..id = json['id'] as int;
  }
}
