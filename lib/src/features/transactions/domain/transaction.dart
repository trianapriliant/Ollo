import 'package:isar/isar.dart';

part 'transaction.g.dart';

enum TransactionType { income, expense, transfer, system, reimbursement }

enum TransactionStatus { pending, completed }

@collection
class Transaction {
  Id id = Isar.autoIncrement; // Auto-increment ID for Isar

  late String title;

  late double amount;

  late DateTime date;

  @Enumerated(EnumType.name)
  late TransactionType type;
  
  @Enumerated(EnumType.name)
  TransactionStatus status = TransactionStatus.completed; // Default to completed for existing types

  late String? note;

  String? walletId;
  String? destinationWalletId; // For transfers
  String? categoryId;



  // Default constructor for Isar and existing code
  Transaction();

  // Named constructor for convenient creation
  Transaction.create({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.status = TransactionStatus.completed,
    this.note,
    this.walletId,
    this.destinationWalletId,
    this.categoryId,
    this.subCategoryId,
    this.subCategoryName,
    this.subCategoryIcon,
  });

  String? subCategoryId;
  String? subCategoryName;
  String? subCategoryIcon;

  // Helper getters (ignored by Isar)
  @ignore
  bool get isExpense => type == TransactionType.expense;
  @ignore
  bool get isIncome => type == TransactionType.income;
  @ignore
  bool get isTransfer => type == TransactionType.transfer;
  @ignore
  bool get isSystem => type == TransactionType.system;
  @ignore
  bool get isReimbursement => type == TransactionType.reimbursement;
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'status': status.name,
      'note': note,
      'walletId': walletId,
      'destinationWalletId': destinationWalletId,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
      'subCategoryIcon': subCategoryIcon,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction.create(
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.name == (json['type'] as String),
        orElse: () => TransactionType.expense,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String),
        orElse: () => TransactionStatus.completed,
      ),
      note: json['note'] as String?,
      walletId: json['walletId'] as String?,
      destinationWalletId: json['destinationWalletId'] as String?,
      categoryId: json['categoryId'] as String?,
      subCategoryId: json['subCategoryId'] as String?,
      subCategoryName: json['subCategoryName'] as String?,
      subCategoryIcon: json['subCategoryIcon'] as String?,
    )..id = json['id'] as int;
  }
}
