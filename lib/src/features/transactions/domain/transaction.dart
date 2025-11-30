import 'package:isar/isar.dart';

part 'transaction.g.dart';

enum TransactionType { income, expense, transfer }

@collection
class Transaction {
  Id id = Isar.autoIncrement; // Auto-increment ID for Isar

  late String title;

  late double amount;

  late DateTime date;

  @Enumerated(EnumType.name)
  late TransactionType type;

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
    this.note,
    this.walletId,
    this.destinationWalletId,
    this.categoryId,
  });

  // Helper getters (ignored by Isar)
  @ignore
  bool get isExpense => type == TransactionType.expense;
  @ignore
  bool get isIncome => type == TransactionType.income;
  @ignore
  bool get isTransfer => type == TransactionType.transfer;
}
