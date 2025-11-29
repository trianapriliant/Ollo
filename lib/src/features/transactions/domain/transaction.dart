// import 'package:isar/isar.dart';
// part 'transaction.g.dart';

enum TransactionType { income, expense, transfer }

class Transaction {
  String? id;

  late String title;

  late double amount;

  late DateTime date;

  late TransactionType type;

  late String? note;

  String? walletId;
  String? destinationWalletId; // For transfers
  String? categoryId;

  // Helper getters
  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
  bool get isTransfer => type == TransactionType.transfer;
}
