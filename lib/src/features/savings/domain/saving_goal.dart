import 'package:isar/isar.dart';

part 'saving_goal.g.dart';

enum SavingType { standard, emergency, deposito }

@collection
class SavingGoal {
  Id id = Isar.autoIncrement;

  late String name;
  late double targetAmount;
  late double currentAmount;
  
  String? iconPath; // e.g. 'flight', 'home'
  int? colorValue; // Store color as int
  
  @Enumerated(EnumType.name)
  late SavingType type;
  
  DateTime? targetDate;
  
  // For Deposito/Emergency
  DateTime? lockedUntil;
  double? interestRate; // Annual interest rate in percentage (e.g. 4.0)

  SavingGoal({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.iconPath,
    this.colorValue,
    this.type = SavingType.standard,
    this.targetDate,
    this.lockedUntil,
    this.interestRate,
  });
}
