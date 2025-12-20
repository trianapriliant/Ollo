/// Base class for Smart Pattern Matching
class CategoryPattern {
  final List<String> mainKeywords;
  final Map<String, List<String>> subCategoryKeywords;

  const CategoryPattern({
    this.mainKeywords = const [],
    this.subCategoryKeywords = const {},
  });
}
