import 'package:isar/isar.dart';

part 'smart_note.g.dart';

@collection
class SmartNote {
  Id id = Isar.autoIncrement;

  late String title; // e.g. "Beli Telur"
  
  double? amount; // e.g. 25000
  
  String? walletId; // Link to wallet (externalId or id.toString())
  
  String? categoryId; // Link to category
  
  bool isCompleted = false;
  
  late DateTime createdAt;
  
  DateTime? deadline;
  
  String? notes; // Additional notes

  SmartNote({
    required this.title,
    this.amount,
    this.walletId,
    this.categoryId,
    this.isCompleted = false,
    required this.createdAt,
    this.deadline,
    this.notes,
  });
}
