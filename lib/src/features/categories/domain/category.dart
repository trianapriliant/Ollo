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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
    };
  }

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      iconPath: json['iconPath'] as String?,
    );
  }
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'externalId': externalId,
      'name': name,
      'iconPath': iconPath,
      'type': type.name,
      'colorValue': colorValue,
      'subCategories': subCategories?.map((s) => s.toJson()).toList(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      externalId: json['externalId'] as String?,
      name: json['name'] as String,
      iconPath: json['iconPath'] as String,
      type: CategoryType.values.firstWhere(
        (e) => e.name == (json['type'] as String),
        orElse: () => CategoryType.expense,
      ),
      colorValue: json['colorValue'] as int?,
      subCategories: (json['subCategories'] as List<dynamic>?)
          ?.map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..id = json['id'] as int;
  }
}

extension SubCategoryExtension on SubCategory {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
    };
  }
  
  static SubCategory fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      iconPath: json['iconPath'] as String?,
    );
  }
}
