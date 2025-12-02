import 'package:isar/isar.dart';

part 'debt.g.dart';

enum DebtType {
  lending,   // I lent money (Owed to me)
  borrowing, // I borrowed money (I owe)
}

enum DebtStatus {
  active,
  paid,
  overdue,
}

@collection
class Debt {
  Id id = Isar.autoIncrement;

  late String personName;
  late double amount;
  double paidAmount = 0;
  
  @enumerated
  late DebtType type;

  @enumerated
  late DebtStatus status;

  late DateTime dueDate;
  DateTime? createdAt;
  
  String? note;
  
  // Link to wallet for initial transaction
  String? walletId;
  
  // Link to the initial transaction record
  int? transactionId;

  // History of payments/installments
  List<DebtHistory> history = [];

  Debt({
    required this.personName,
    required this.amount,
    required this.type,
    required this.dueDate,
    this.paidAmount = 0,
    this.status = DebtStatus.active,
    this.note,
    this.walletId,
    this.createdAt,
    this.history = const [],
  });

  double get remainingAmount => amount - paidAmount;
  bool get isPaid => remainingAmount <= 0;
}

@embedded
class DebtHistory {
  DateTime? date;
  double? amount;
  String? note;

  DebtHistory({
    this.date,
    this.amount,
    this.note,
  });
}
