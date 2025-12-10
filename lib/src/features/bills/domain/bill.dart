import 'package:isar/isar.dart';

part 'bill.g.dart';

enum BillStatus {
  unpaid,
  paid,
  overdue,
}

@collection
class Bill {
  Id id = Isar.autoIncrement;

  late String title;
  late double amount;
  late DateTime dueDate;
  late String categoryId;
  String? walletId;
  String? note;

  @enumerated
  late BillStatus status;

  DateTime? paidAt;
  
  // Link to recurring template if auto-generated
  int? recurringTransactionId;
  
  // Link to payment transaction
  int? transactionId;

  Bill({
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.categoryId,
    this.walletId,
    this.note,
    this.status = BillStatus.unpaid,
    this.paidAt,
    this.recurringTransactionId,
    this.transactionId,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'categoryId': categoryId,
      'walletId': walletId,
      'note': note,
      'status': status.name,
      'paidAt': paidAt?.toIso8601String(),
      'recurringTransactionId': recurringTransactionId,
      'transactionId': transactionId,
    };
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      categoryId: json['categoryId'] as String,
      walletId: json['walletId'] as String?,
      note: json['note'] as String?,
      status: BillStatus.values.firstWhere((e) => e.name == json['status']),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      recurringTransactionId: json['recurringTransactionId'] as int?,
      transactionId: json['transactionId'] as int?,
    )..id = json['id'] as int;
  }
}
