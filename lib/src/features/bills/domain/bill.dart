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
  });
}
