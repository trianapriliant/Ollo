// import 'package:isar/isar.dart';
// part 'transaction.g.dart';

class Transaction {
  String? id; // Changed from Id to String? for in-memory

  late String title;

  late double amount;

  late DateTime date;

  late bool isExpense;

  late String? note;

  String? walletId;
  String? categoryId;

  // final wallet = IsarLink<Wallet>(); // Disable link for now
}
