import 'package:isar/isar.dart';

part 'wallet.g.dart';

@collection
class Wallet {
  Id id = Isar.autoIncrement;

  // We can use a unique index for ID if we want to keep string IDs, 
  // but Isar prefers int IDs. For simplicity, let's use autoIncrement 
  // and add a separate string identifier if needed for logic, 
  // OR just use the int ID everywhere.
  // However, the current app uses String IDs (e.g. 'cash_default').
  // To minimize refactoring, let's keep a String 'customId' field 
  // and index it, or just rely on Isar's int ID and refactor the app to use int IDs?
  // Refactoring to int IDs is safer for Isar. 
  // But let's check how many places use String IDs.
  // Actually, Isar supports fastHash for String IDs if we really want.
  // Let's stick to autoIncrement for simplicity and add a 'key' field if needed.
  // Wait, the InMemory repo used String IDs. 
  // Let's change the app to use String IDs mapped to Isar's fastHash 
  // OR just add a 'String? externalId' field.
  
  // For now, let's use fastHash for the ID to keep String compatibility
  // or just switch to int. Switching to int might break more things.
  // Let's try to keep String ID by hashing it.
  
  String? externalId; // To store 'cash_default' etc.

  late String name;

  late double balance;

  late String iconPath;

  @Enumerated(EnumType.name)
  late WalletType type;
}

enum WalletType {
  bank,
  ewallet,
  cash,
  creditCard,
  exchange,
  other,
}
