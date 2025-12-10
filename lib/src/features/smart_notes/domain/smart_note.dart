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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'walletId': walletId,
      'items': items?.map((e) => e.toJson()).toList(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'notes': notes,
      'transactionId': transactionId,
    };
  }

  factory SmartNote.fromJson(Map<String, dynamic> json) {
    return SmartNote(
      title: json['title'] as String,
      walletId: json['walletId'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SmartNoteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      notes: json['notes'] as String?,
      transactionId: json['transactionId'] as int?,
    )..id = json['id'] as int;
  }

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'isDone': isDone,
    };
  }

  factory SmartNoteItem.fromJson(Map<String, dynamic> json) {
    return SmartNoteItem(
      name: json['name'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      isDone: json['isDone'] as bool? ?? false,
    );
  }
}
