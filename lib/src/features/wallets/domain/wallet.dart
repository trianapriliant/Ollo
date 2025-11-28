// import 'package:isar/isar.dart';
// part 'wallet.g.dart';

class Wallet {
  String? id; // Changed from Id to String?

  late String name;

  late double balance;

  late String iconPath;

  late WalletType type; // Removed @Enumerated
}

enum WalletType {
  bank,
  ewallet,
  cash,
  other,
}
