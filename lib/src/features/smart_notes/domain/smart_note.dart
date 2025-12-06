import 'package:isar/isar.dart';

part 'smart_note.g.dart';

@collection
class SmartNote {
  Id id = Isar.autoIncrement;

  late String title; // "List Title" e.g. "Monthly Groceries"
  
  String? walletId; // Link to wallet
  
  List<SmartNoteItem>? items;
  
  // Computed total
  double get totalAmount {
    if (items == null) return 0;
    return items!.fold(0, (sum, item) => sum + (item.amount ?? 0));
  }

  bool isCompleted = false; // Fully processed/done
  
  late DateTime createdAt;
  
  DateTime? deadline;
  
  String? notes; // Additional description

  SmartNote({
    required this.title,
    this.walletId,
    this.items,
    this.isCompleted = false,
    required this.createdAt,
    this.deadline,
    this.notes,
    this.transactionId,
  });

  int? transactionId; // ID of the created transaction (for the whole bundle)
}

@embedded
class SmartNoteItem {
  late String name;
  double? amount;
  bool isDone;

  SmartNoteItem({
    this.name = '',
    this.amount,
    this.isDone = false,
  });
}
