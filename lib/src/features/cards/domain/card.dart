import 'package:isar/isar.dart';

part 'card.g.dart';

enum CardType {
  bank,
  eWallet,
  other,
}

enum CardCategory {
  main,
  backup,
  freelance,
  business,
  other,
}

enum CardAccountType {
  personal,
  business,
}

@collection
class BankCard {
  Id id = Isar.autoIncrement;

  late String name; // e.g., "BCA", "GoPay"
  late String number; // Account number
  late String holderName; // Account holder name
  
  int color = 0xFF2196F3; // Default blue

  @enumerated
  late CardType type; // Provider type (Bank/E-Wallet)

  @enumerated
  CardCategory category = CardCategory.main;

  @enumerated
  CardAccountType accountType = CardAccountType.personal;

  String? label; // e.g. "Tabungan Nikah"
  String? branch; // e.g. "KCP Sudirman"
  bool isPinned = false;
  String? qrCodePath;

  double? balance; // Optional for future use

  BankCard({
    required this.name,
    required this.number,
    required this.holderName,
    required this.type,
    this.color = 0xFF2196F3,
    this.balance,
    this.category = CardCategory.main,
    this.accountType = CardAccountType.personal,
    this.label,
    this.branch,
    this.isPinned = false,
    this.qrCodePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'holderName': holderName,
      'type': type.name,
      'color': color,
      'balance': balance,
      'category': category.name,
      'accountType': accountType.name,
      'label': label,
      'branch': branch,
      'isPinned': isPinned,
      'qrCodePath': qrCodePath,
    };
  }

  factory BankCard.fromJson(Map<String, dynamic> json) {
    return BankCard(
      name: json['name'] as String,
      number: json['number'] as String,
      holderName: json['holderName'] as String,
      type: CardType.values.firstWhere((e) => e.name == json['type']),
      color: json['color'] as int? ?? 0xFF2196F3,
      balance: (json['balance'] as num?)?.toDouble(),
      category: CardCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => CardCategory.main,
      ),
      accountType: CardAccountType.values.firstWhere(
        (e) => e.name == json['accountType'],
        orElse: () => CardAccountType.personal,
      ),
      label: json['label'] as String?,
      branch: json['branch'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      qrCodePath: json['qrCodePath'] as String?,
    )..id = json['id'] as int;
  }
}
