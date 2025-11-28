import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories(CategoryType type);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}

class InMemoryCategoryRepository implements CategoryRepository {
  final List<Category> _categories = [
    // Expenses
    Category(
      id: 'food',
      name: 'Food',
      iconPath: 'fastfood',
      type: CategoryType.expense,
      color: Colors.orange,
      subCategories: [
        SubCategory(id: 'breakfast', name: 'Breakfast', iconPath: 'bakery_dining'),
        SubCategory(id: 'lunch', name: 'Lunch', iconPath: 'lunch_dining'),
        SubCategory(id: 'dinner', name: 'Dinner', iconPath: 'dinner_dining'),
        SubCategory(id: 'snacks', name: 'Snacks', iconPath: 'icecream'),
        SubCategory(id: 'drinks', name: 'Drinks', iconPath: 'coffee'),
      ],
    ),
    Category(
      id: 'transport',
      name: 'Transport',
      iconPath: 'directions_bus',
      type: CategoryType.expense,
      color: Colors.blue,
      subCategories: [
        SubCategory(id: 'bus', name: 'Bus', iconPath: 'directions_bus'),
        SubCategory(id: 'train', name: 'Train', iconPath: 'train'),
        SubCategory(id: 'taxi', name: 'Taxi', iconPath: 'local_taxi'),
        SubCategory(id: 'fuel', name: 'Fuel', iconPath: 'local_gas_station'),
      ],
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      iconPath: 'shopping_bag',
      type: CategoryType.expense,
      color: Colors.purple,
      subCategories: [
        SubCategory(id: 'clothes', name: 'Clothes', iconPath: 'checkroom'),
        SubCategory(id: 'electronics', name: 'Electronics', iconPath: 'devices'),
        SubCategory(id: 'groceries', name: 'Groceries', iconPath: 'local_grocery_store'),
      ],
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      iconPath: 'movie',
      type: CategoryType.expense,
      color: Colors.red,
      subCategories: [
        SubCategory(id: 'movies', name: 'Movies', iconPath: 'movie'),
        SubCategory(id: 'games', name: 'Games', iconPath: 'sports_esports'),
        SubCategory(id: 'streaming', name: 'Streaming', iconPath: 'live_tv'),
        SubCategory(id: 'events', name: 'Events', iconPath: 'event'),
      ],
    ),
    Category(
      id: 'health',
      name: 'Health',
      iconPath: 'medical_services',
      type: CategoryType.expense,
      color: Colors.green,
      subCategories: [
        SubCategory(id: 'doctor', name: 'Doctor', iconPath: 'medical_services'),
        SubCategory(id: 'pharmacy', name: 'Pharmacy', iconPath: 'local_pharmacy'),
        SubCategory(id: 'sports', name: 'Sports', iconPath: 'fitness_center'),
      ],
    ),
    Category(
      id: 'education',
      name: 'Education',
      iconPath: 'school',
      type: CategoryType.expense,
      color: Colors.indigo,
      subCategories: [
        SubCategory(id: 'books', name: 'Books', iconPath: 'menu_book'),
        SubCategory(id: 'courses', name: 'Courses', iconPath: 'school'),
      ],
    ),
    Category(
      id: 'bills',
      name: 'Bills',
      iconPath: 'receipt',
      type: CategoryType.expense,
      color: Colors.brown,
      subCategories: [
        SubCategory(id: 'electricity', name: 'Electricity', iconPath: 'lightbulb'),
        SubCategory(id: 'water', name: 'Water', iconPath: 'water_drop'),
        SubCategory(id: 'internet', name: 'Internet', iconPath: 'wifi'),
        SubCategory(id: 'rent', name: 'Rent', iconPath: 'home'),
      ],
    ),
    Category(
      id: 'other_expense',
      name: 'Other',
      iconPath: 'more_horiz',
      type: CategoryType.expense,
      color: Colors.grey,
      subCategories: [
        SubCategory(id: 'charity', name: 'Charity', iconPath: 'volunteer_activism'),
        SubCategory(id: 'misc', name: 'Misc', iconPath: 'more_horiz'),
      ],
    ),

    // Income
    Category(
      id: 'salary',
      name: 'Salary',
      iconPath: 'attach_money',
      type: CategoryType.income,
      color: Colors.green,
      subCategories: [
        SubCategory(id: 'monthly', name: 'Monthly', iconPath: 'calendar_today'),
        SubCategory(id: 'bonus', name: 'Bonus', iconPath: 'star'),
      ],
    ),
    Category(
      id: 'business',
      name: 'Business',
      iconPath: 'store',
      type: CategoryType.income,
      color: Colors.blue,
      subCategories: [
        SubCategory(id: 'sales', name: 'Sales', iconPath: 'sell'),
        SubCategory(id: 'services', name: 'Services', iconPath: 'design_services'),
      ],
    ),
    Category(
      id: 'gift',
      name: 'Gift',
      iconPath: 'card_giftcard',
      type: CategoryType.income,
      color: Colors.pink,
      subCategories: [
        SubCategory(id: 'birthday', name: 'Birthday', iconPath: 'cake'),
        SubCategory(id: 'holiday', name: 'Holiday', iconPath: 'celebration'),
      ],
    ),
    Category(
      id: 'investment',
      name: 'Investment',
      iconPath: 'trending_up',
      type: CategoryType.income,
      color: Colors.teal,
      subCategories: [
        SubCategory(id: 'dividends', name: 'Dividends', iconPath: 'pie_chart'),
        SubCategory(id: 'crypto', name: 'Crypto', iconPath: 'currency_bitcoin'),
      ],
    ),
    Category(
      id: 'other_income',
      name: 'Other',
      iconPath: 'more_horiz',
      type: CategoryType.income,
      color: Colors.grey,
      subCategories: [
        SubCategory(id: 'refund', name: 'Refund', iconPath: 'replay'),
        SubCategory(id: 'misc', name: 'Misc', iconPath: 'more_horiz'),
      ],
    ),
  ];

  @override
  Future<List<Category>> getCategories(CategoryType type) async {
    return _categories.where((c) => c.type == type).toList();
  }

  @override
  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return InMemoryCategoryRepository();
});

final categoryListProvider = FutureProvider.family<List<Category>, CategoryType>((ref, type) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategories(type);
});
