import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/category.dart';

import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories(CategoryType type);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(Id id);
}

class IsarCategoryRepository implements CategoryRepository {
  final Isar isar;

  IsarCategoryRepository(this.isar);

  @override
  Future<List<Category>> getCategories(CategoryType type) async {
    return isar.categorys.filter().typeEqualTo(type).findAll();
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
}

final categoryRepositoryProvider = FutureProvider<CategoryRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarCategoryRepository(isar);
});

final categoryListProvider = FutureProvider.family<List<Category>, CategoryType>((ref, type) async {
  final repository = await ref.watch(categoryRepositoryProvider.future);
  return repository.getCategories(type);
});

final allCategoriesStreamProvider = StreamProvider<List<Category>>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield* isar.categorys.where().watch(fireImmediately: true);
});
