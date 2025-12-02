import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/domain/wallet.dart';
import '../../categories/domain/category.dart';
import '../../budget/domain/budget.dart';
import '../../profile/domain/user_profile.dart';
import '../../recurring/domain/recurring_transaction.dart';
import '../../savings/domain/saving_goal.dart';
import '../../savings/domain/saving_log.dart';
import '../../bills/domain/bill.dart';
import '../../bills/domain/bill.dart';
import '../../wishlist/domain/wishlist.dart';
import '../../debts/domain/debt.dart';
import '../../cards/domain/card.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [TransactionSchema, WalletSchema, CategorySchema, BudgetSchema, UserProfileSchema, RecurringTransactionSchema, SavingGoalSchema, SavingLogSchema, BillSchema, WishlistSchema, DebtSchema, BankCardSchema],
    directory: dir.path,
  );

  // Seed initial data if empty
  if (await isar.wallets.count() == 0) {
    await _seedWallets(isar);
  }
  
  if (await isar.categorys.count() == 0) {
    await _seedCategories(isar);
  }

  return isar;
});

Future<void> _seedWallets(Isar isar) async {
  final cashWallet = Wallet()
    ..externalId = 'cash_default'
    ..name = 'Cash'
    ..balance = 0.0
    ..iconPath = 'money'
    ..type = WalletType.cash;

  await isar.writeTxn(() async {
    await isar.wallets.put(cashWallet);
  });
}

Future<void> _seedCategories(Isar isar) async {
  final categories = [
    // Expenses
    Category(
      externalId: 'food',
      name: 'Food',
      iconPath: 'fastfood',
      type: CategoryType.expense,
      colorValue: Colors.orange.value,
      subCategories: [
        SubCategory(id: 'breakfast', name: 'Breakfast', iconPath: 'bakery_dining'),
        SubCategory(id: 'lunch', name: 'Lunch', iconPath: 'lunch_dining'),
        SubCategory(id: 'dinner', name: 'Dinner', iconPath: 'dinner_dining'),
        SubCategory(id: 'snacks', name: 'Snacks', iconPath: 'icecream'),
        SubCategory(id: 'drinks', name: 'Drinks', iconPath: 'coffee'),
      ],
    ),
    Category(
      externalId: 'transport',
      name: 'Transport',
      iconPath: 'directions_bus',
      type: CategoryType.expense,
      colorValue: Colors.blue.value,
      subCategories: [
        SubCategory(id: 'bus', name: 'Bus', iconPath: 'directions_bus'),
        SubCategory(id: 'train', name: 'Train', iconPath: 'train'),
        SubCategory(id: 'taxi', name: 'Taxi', iconPath: 'local_taxi'),
        SubCategory(id: 'fuel', name: 'Fuel', iconPath: 'local_gas_station'),
      ],
    ),
     Category(
      externalId: 'shopping',
      name: 'Shopping',
      iconPath: 'shopping_bag',
      type: CategoryType.expense,
      colorValue: Colors.purple.value,
      subCategories: [
        SubCategory(id: 'clothes', name: 'Clothes', iconPath: 'checkroom'),
        SubCategory(id: 'electronics', name: 'Electronics', iconPath: 'devices'),
        SubCategory(id: 'groceries', name: 'Groceries', iconPath: 'local_grocery_store'),
      ],
    ),
    Category(
      externalId: 'entertainment',
      name: 'Entertainment',
      iconPath: 'movie',
      type: CategoryType.expense,
      colorValue: Colors.red.value,
      subCategories: [
        SubCategory(id: 'movies', name: 'Movies', iconPath: 'movie'),
        SubCategory(id: 'games', name: 'Games', iconPath: 'sports_esports'),
        SubCategory(id: 'streaming', name: 'Streaming', iconPath: 'live_tv'),
        SubCategory(id: 'events', name: 'Events', iconPath: 'event'),
      ],
    ),
    // Income
    Category(
      externalId: 'salary',
      name: 'Salary',
      iconPath: 'attach_money',
      type: CategoryType.income,
      colorValue: Colors.green.value,
      subCategories: [
        SubCategory(id: 'monthly', name: 'Monthly', iconPath: 'calendar_today'),
        SubCategory(id: 'bonus', name: 'Bonus', iconPath: 'star'),
      ],
    ),
    Category(
      externalId: 'business',
      name: 'Business',
      iconPath: 'store',
      type: CategoryType.income,
      colorValue: Colors.blue.value,
      subCategories: [
        SubCategory(id: 'sales', name: 'Sales', iconPath: 'sell'),
        SubCategory(id: 'services', name: 'Services', iconPath: 'design_services'),
      ],
    ),
  ];

  await isar.writeTxn(() async {
    await isar.categorys.putAll(categories);
  });
}
