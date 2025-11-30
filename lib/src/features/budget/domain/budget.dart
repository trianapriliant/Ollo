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
}

enum BudgetPeriod {
  weekly,
  monthly,
  yearly
}
