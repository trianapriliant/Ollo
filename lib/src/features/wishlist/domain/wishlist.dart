import 'package:isar/isar.dart';

part 'wishlist.g.dart';

@collection
class Wishlist {
  Id id = Isar.autoIncrement;

  late String title;
  late double price;
  
  DateTime? targetDate;
  String? imagePath;
  String? linkUrl;
  int? transactionId;
  
  bool isCompleted;
  DateTime? createdAt;

  Wishlist({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.price,
    this.targetDate,
    this.imagePath,
    this.linkUrl,
    this.transactionId,
    this.isCompleted = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'targetDate': targetDate?.toIso8601String(),
      'imagePath': imagePath,
      'linkUrl': linkUrl,
      'transactionId': transactionId,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      imagePath: json['imagePath'] as String?,
      linkUrl: json['linkUrl'] as String?,
      transactionId: json['transactionId'] as int?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    )..id = json['id'] as int;
  }
}
