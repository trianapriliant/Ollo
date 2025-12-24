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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'amount': amount,
      'paidAmount': paidAmount,
      'type': type.name,
      'status': status.name,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'note': note,
      'walletId': walletId,
      'transactionId': transactionId,
      'history': history.map((h) => h.toJson()).toList(),
    };
  }

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      personName: json['personName'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: DebtType.values.firstWhere((e) => e.name == json['type']),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      status: DebtStatus.values.firstWhere((e) => e.name == json['status']),
      note: json['note'] as String?,
      walletId: json['walletId'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => DebtHistory.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    )
    ..id = json['id'] as int
    ..transactionId = json['transactionId'] as int?;
  }
}

@embedded
class DebtHistory {
  DateTime? date;
  double? amount;
  String? note;
  int? transactionId; // Link to the transaction for this payment

  DebtHistory({
    this.date,
    this.amount,
    this.note,
    this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'amount': amount,
      'note': note,
      'transactionId': transactionId,
    };
  }

  factory DebtHistory.fromJson(Map<String, dynamic> json) {
    return DebtHistory(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      amount: (json['amount'] as num?)?.toDouble(),
      note: json['note'] as String?,
      transactionId: json['transactionId'] as int?,
    );
  }
}
