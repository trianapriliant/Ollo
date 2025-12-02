import 'package:isar/isar.dart';

part 'card.g.dart';

enum CardType {
  bank,
  eWallet,
  other,
}

@collection
class BankCard {
  Id id = Isar.autoIncrement;

  late String name; // e.g., "BCA", "GoPay"
  late String number; // Account number
  late String holderName; // Account holder name
  
  int color = 0xFF2196F3; // Default blue

  @enumerated
  late CardType type;

  double? balance; // Optional for future use

  BankCard({
    required this.name,
    required this.number,
    required this.holderName,
    required this.type,
    this.color = 0xFF2196F3,
    this.balance,
  });
}
