import '../../categories/domain/category.dart';

class CategorySelectionItem {
  final Category category;
  final SubCategory? subCategory;

  CategorySelectionItem({required this.category, this.subCategory});

  String get name => subCategory?.name ?? category.name;
  String get id => (subCategory?.id ?? category.id).toString();
  String get iconPath => subCategory?.iconPath ?? category.iconPath;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategorySelectionItem &&
        other.category.id == category.id &&
        other.subCategory?.id == subCategory?.id &&
        (other.subCategory == null) == (subCategory == null);
  }

  @override
  int get hashCode => Object.hash(category.id, subCategory?.id, subCategory == null);
}
