import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'category.g.dart';

enum CategoryType { income, expense }

@embedded
class SubCategory {
  String? id;
  String? name;
  String? iconPath;

  SubCategory({
    this.id,
    this.name,
    this.iconPath,
  });
}

@collection
class Category {
  Id id = Isar.autoIncrement;

  String? externalId; // For predefined IDs like 'food'

  late String name;
  late String iconPath;

  @Enumerated(EnumType.name)
  late CategoryType type;

  // Isar doesn't support Color directly, store as int
  int? colorValue;

  @ignore
  Color get color => Color(colorValue ?? 0xFF000000);
  
  @ignore
  set color(Color c) => colorValue = c.value;

  List<SubCategory>? subCategories;

  Category({
    this.externalId,
    required this.name,
    required this.iconPath,
    required this.type,
    required this.colorValue,
    this.subCategories,
  });
}
