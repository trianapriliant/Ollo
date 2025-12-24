import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/category.dart';

import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories(CategoryType type);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<List<Category>> getAllCategories();

  Future<void> deleteCategory(Id id);
  Future<void> clearAllCategories();
  Future<void> importCategories(List<Category> categories);
}

class IsarCategoryRepository implements CategoryRepository {
  final Isar isar;

  IsarCategoryRepository(this.isar);

  @override
  Future<List<Category>> getCategories(CategoryType type) async {
    return isar.categorys.filter().typeEqualTo(type).findAll();
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return isar.categorys.where().findAll();
  }

  @override
  Future<void> addCategory(Category category) async {
    await isar.writeTxn(() async {
      await isar.categorys.put(category);
    });
  }

  @override
  Future<void> updateCategory(Category category) async {
    await isar.writeTxn(() async {
      await isar.categorys.put(category);
    });
  }

  @override
  Future<void> deleteCategory(Id id) async {
    await isar.writeTxn(() async {
      await isar.categorys.delete(id);
    });
  }

  @override
  Future<void> clearAllCategories() async {
    await isar.writeTxn(() async {
      await isar.categorys.clear();
    });
  }

  @override
  Future<void> importCategories(List<Category> categories) async {
    await isar.writeTxn(() async {
      await isar.categorys.putAll(categories);
    });
  }
}

final categoryRepositoryProvider = FutureProvider<CategoryRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarCategoryRepository(isar);
});

final categoryListProvider = FutureProvider.family<List<Category>, CategoryType>((ref, type) async {
  final repository = await ref.watch(categoryRepositoryProvider.future);
  final categories = await repository.getCategories(type);
  
  // Custom sort order for expense categories (Friend before Personal)
  if (type == CategoryType.expense) {
    const expenseOrder = [
      'food', 'transport', 'shopping', 'housing', 'entertainment',
      'health', 'education', 'friend', 'personal', 'financial', 'family'
    ];
    categories.sort((a, b) {
      final aIndex = expenseOrder.indexOf(a.externalId ?? '');
      final bIndex = expenseOrder.indexOf(b.externalId ?? '');
      if (aIndex != -1 && bIndex != -1) return aIndex.compareTo(bIndex);
      if (aIndex != -1) return -1;
      if (bIndex != -1) return 1;
      return a.name.compareTo(b.name);
    });
  }
  
  // Custom sort order for income categories
  if (type == CategoryType.income) {
    const incomeOrder = ['salary', 'business', 'investments', 'gifts', 'other'];
    categories.sort((a, b) {
      final aIndex = incomeOrder.indexOf(a.externalId ?? '');
      final bIndex = incomeOrder.indexOf(b.externalId ?? '');
      if (aIndex != -1 && bIndex != -1) return aIndex.compareTo(bIndex);
      if (aIndex != -1) return -1;
      if (bIndex != -1) return 1;
      return a.name.compareTo(b.name);
    });
  }
  
  return categories;
});

final allCategoriesStreamProvider = StreamProvider<List<Category>>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield* isar.categorys.where().watch(fireImmediately: true);
});
