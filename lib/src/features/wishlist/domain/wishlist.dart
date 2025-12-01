import 'package:isar/isar.dart';

part 'wishlist.g.dart';

@collection
class Wishlist {
  Id id = Isar.autoIncrement;

  late String title;
  late double price;
  
  DateTime? targetDate;
  String? imagePath;
  
  bool isCompleted;
  DateTime? createdAt;

  Wishlist({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.price,
    this.targetDate,
    this.imagePath,
    this.isCompleted = false,
    this.createdAt,
  });
}
