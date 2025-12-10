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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'iconPath': iconPath,
      'colorValue': colorValue,
      'type': type.name,
      'targetDate': targetDate?.toIso8601String(),
      'lockedUntil': lockedUntil?.toIso8601String(),
      'interestRate': interestRate,
    };
  }

  factory SavingGoal.fromJson(Map<String, dynamic> json) {
    return SavingGoal(
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      iconPath: json['iconPath'] as String?,
      colorValue: json['colorValue'] as int?,
      type: SavingType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SavingType.standard,
      ),
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      lockedUntil: json['lockedUntil'] != null ? DateTime.parse(json['lockedUntil']) : null,
      interestRate: (json['interestRate'] as num?)?.toDouble(),
    )..id = json['id'] as int;
  }
}
