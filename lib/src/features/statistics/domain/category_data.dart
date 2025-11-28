import 'package:flutter/material.dart';

class CategoryData {
  final String categoryId;
  final String categoryName;
  final double amount;
  final double percentage;
  final Color color;
  final String iconPath;

  CategoryData({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.iconPath,
  });
}
