import 'package:isar/isar.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  late String categoryId; // Links to Category.externalId or id.toString()
  
  late double amount; // Budget limit
  
  late DateTime startDate;

  @Enumerated(EnumType.name)
  late BudgetPeriod period;

  // Helper to track spending (not stored in DB, calculated at runtime)
  @ignore
  double spentAmount = 0.0;
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'amount': amount,
      'startDate': startDate.toIso8601String(),
      'period': period.name,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget()
      ..id = json['id'] as int
      ..categoryId = json['categoryId'] as String
      ..amount = (json['amount'] as num).toDouble()
      ..startDate = DateTime.parse(json['startDate'] as String)
      ..period = BudgetPeriod.values.firstWhere((e) => e.name == json['period']);
  }

  Budget();
}

enum BudgetPeriod {
  weekly,
  monthly,
  yearly
}
