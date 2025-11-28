import 'package:flutter/material.dart';

enum CategoryType { income, expense }

class SubCategory {
  final String id;
  final String name;
  final String iconPath;

  SubCategory({
    required this.id,
    required this.name,
    required this.iconPath,
  });
}

class Category {
  final String id;
  final String name;
  final String iconPath; // Using string for now, can be mapped to IconData or SVG
  final CategoryType type;
  final Color color;
  final List<SubCategory> subCategories;

  Category({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.type,
    required this.color,
    this.subCategories = const [],
  });
}
