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
import '../../smart_notes/domain/smart_note.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [TransactionSchema, WalletSchema, CategorySchema, BudgetSchema, UserProfileSchema, RecurringTransactionSchema, SavingGoalSchema, SavingLogSchema, BillSchema, WishlistSchema, DebtSchema, BankCardSchema, SmartNoteSchema],
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
      name: 'Food & Drink',
      iconPath: 'fastfood',
      type: CategoryType.expense,
      colorValue: Colors.orange.value,
      subCategories: [
        SubCategory(id: 'breakfast', name: 'Breakfast', iconPath: 'bakery_dining'),
        SubCategory(id: 'lunch', name: 'Lunch', iconPath: 'lunch_dining'),
        SubCategory(id: 'dinner', name: 'Dinner', iconPath: 'dinner_dining'),
        SubCategory(id: 'snacks', name: 'Snacks', iconPath: 'icecream'),
        SubCategory(id: 'drinks', name: 'Drinks', iconPath: 'coffee'),
        SubCategory(id: 'groceries', name: 'Groceries', iconPath: 'local_grocery_store'),
        SubCategory(id: 'delivery', name: 'Delivery', iconPath: 'delivery_dining'),
        SubCategory(id: 'alcohol', name: 'Alcohol', iconPath: 'liquor'),
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
        SubCategory(id: 'parking', name: 'Parking', iconPath: 'local_parking'),
        SubCategory(id: 'maintenance', name: 'Maintenance', iconPath: 'car_repair'),
        SubCategory(id: 'insurance_car', name: 'Insurance', iconPath: 'security'),
        SubCategory(id: 'toll', name: 'Toll', iconPath: 'toll'),
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
        SubCategory(id: 'home', name: 'Home', iconPath: 'home'),
        SubCategory(id: 'beauty', name: 'Beauty', iconPath: 'face'),
        SubCategory(id: 'gifts', name: 'Gifts', iconPath: 'card_giftcard'),
        SubCategory(id: 'software', name: 'Software', iconPath: 'developer_board'),
        SubCategory(id: 'tools', name: 'Tools', iconPath: 'build'),
      ],
    ),
    Category(
      externalId: 'housing',
      name: 'Housing',
      iconPath: 'house',
      type: CategoryType.expense,
      colorValue: Colors.brown.value,
      subCategories: [
        SubCategory(id: 'rent', name: 'Rent', iconPath: 'real_estate_agent'),
        SubCategory(id: 'mortgage', name: 'Mortgage', iconPath: 'account_balance'),
        SubCategory(id: 'utilities', name: 'Utilities', iconPath: 'lightbulb'),
        SubCategory(id: 'internet', name: 'Internet', iconPath: 'wifi'),
        SubCategory(id: 'maintenance_home', name: 'Maintenance', iconPath: 'plumbing'),
        SubCategory(id: 'furniture', name: 'Furniture', iconPath: 'chair'),
        SubCategory(id: 'services', name: 'Services', iconPath: 'cleaning_services'),
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
        SubCategory(id: 'events', name: 'Events', iconPath: 'event_seat'),
        SubCategory(id: 'hobbies', name: 'Hobbies', iconPath: 'palette'),
        SubCategory(id: 'travel', name: 'Travel', iconPath: 'flight'),
        SubCategory(id: 'music', name: 'Music', iconPath: 'music_note'),
      ],
    ),
    Category(
      externalId: 'health',
      name: 'Health',
      iconPath: 'medical_services',
      type: CategoryType.expense,
      colorValue: Colors.teal.value,
      subCategories: [
        SubCategory(id: 'doctor', name: 'Doctor', iconPath: 'medical_services'),
        SubCategory(id: 'pharmacy', name: 'Pharmacy', iconPath: 'local_pharmacy'),
        SubCategory(id: 'gym', name: 'Gym', iconPath: 'fitness_center'),
        SubCategory(id: 'insurance_health', name: 'Insurance', iconPath: 'health_and_safety'),
        SubCategory(id: 'mental_health', name: 'Mental Health', iconPath: 'self_improvement'),
        SubCategory(id: 'sports', name: 'Sports', iconPath: 'sports_soccer'),
      ],
    ),
    Category(
      externalId: 'education',
      name: 'Education',
      iconPath: 'school',
      type: CategoryType.expense,
      colorValue: Colors.indigo.value,
      subCategories: [
        SubCategory(id: 'tuition', name: 'Tuition', iconPath: 'school'),
        SubCategory(id: 'books', name: 'Books', iconPath: 'menu_book'),
        SubCategory(id: 'courses', name: 'Courses', iconPath: 'cast_for_education'),
        SubCategory(id: 'supplies', name: 'Supplies', iconPath: 'backpack'),
      ],
    ),
    Category(
      externalId: 'personal',
      name: 'Personal',
      iconPath: 'person',
      type: CategoryType.expense,
      colorValue: Colors.pinkAccent.value,
      subCategories: [
        SubCategory(id: 'haircut', name: 'Haircut', iconPath: 'content_cut'),
        SubCategory(id: 'spa', name: 'Spa', iconPath: 'spa'),
        SubCategory(id: 'cosmetics', name: 'Cosmetics', iconPath: 'brush'),
      ],
    ),
    Category(
      externalId: 'financial',
      name: 'Financial',
      iconPath: 'account_balance',
      type: CategoryType.expense,
      colorValue: Colors.blueGrey.value,
      subCategories: [
        SubCategory(id: 'taxes', name: 'Taxes', iconPath: 'receipt_long'),
        SubCategory(id: 'fees', name: 'Fees', iconPath: 'payments'),
        SubCategory(id: 'fines', name: 'Fines', iconPath: 'gavel'),
        SubCategory(id: 'insurance_life', name: 'Insurance', iconPath: 'shield'),
      ],
    ),
    Category(
      externalId: 'family',
      name: 'Family',
      iconPath: 'family_restroom',
      type: CategoryType.expense,
      colorValue: Colors.amber.value,
      subCategories: [
        SubCategory(id: 'childcare', name: 'Childcare', iconPath: 'child_care'),
        SubCategory(id: 'toys', name: 'Toys', iconPath: 'toys'),
        SubCategory(id: 'school_kids', name: 'School', iconPath: 'school'),
        SubCategory(id: 'pets', name: 'Pets', iconPath: 'pets'),
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
        SubCategory(id: 'weekly', name: 'Weekly', iconPath: 'date_range'),
        SubCategory(id: 'bonus', name: 'Bonus', iconPath: 'star'),
        SubCategory(id: 'overtime', name: 'Overtime', iconPath: 'access_time'),
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
        SubCategory(id: 'profit', name: 'Profit', iconPath: 'trending_up'),
      ],
    ),
    Category(
      externalId: 'investments',
      name: 'Investments',
      iconPath: 'trending_up',
      type: CategoryType.income,
      colorValue: Colors.teal.value,
      subCategories: [
        SubCategory(id: 'dividends', name: 'Dividends', iconPath: 'pie_chart'),
        SubCategory(id: 'interest', name: 'Interest', iconPath: 'savings'),
        SubCategory(id: 'crypto', name: 'Crypto', iconPath: 'currency_bitcoin'),
        SubCategory(id: 'stocks', name: 'Stocks', iconPath: 'show_chart'),
        SubCategory(id: 'real_estate', name: 'Real Estate', iconPath: 'domain'),
      ],
    ),
    Category(
      externalId: 'gifts_income',
      name: 'Gifts',
      iconPath: 'card_giftcard',
      type: CategoryType.income,
      colorValue: Colors.pink.value,
      subCategories: [
        SubCategory(id: 'birthday', name: 'Birthday', iconPath: 'cake'),
        SubCategory(id: 'holiday', name: 'Holiday', iconPath: 'celebration'),
        SubCategory(id: 'allowance', name: 'Allowance', iconPath: 'attach_money'),
      ],
    ),
    Category(
      externalId: 'other_income',
      name: 'Other',
      iconPath: 'more_horiz',
      type: CategoryType.income,
      colorValue: Colors.grey.value,
      subCategories: [
        SubCategory(id: 'refunds', name: 'Refunds', iconPath: 'undo'),
        SubCategory(id: 'grants', name: 'Grants', iconPath: 'school'),
        SubCategory(id: 'lottery', name: 'Lottery', iconPath: 'casino'),
        SubCategory(id: 'selling', name: 'Selling', iconPath: 'storefront'),
      ],
    ),
  ];

  await isar.writeTxn(() async {
    await isar.categorys.putAll(categories);
  });

  // 2. Force update specific categories to ensure correct icons
  final categoriesToFix = {
    'housing': 'house',
    'personal': 'person',
    'financial': 'attach_money', // Changed to attach_money for "Money" icon
    'family': 'family_restroom',
  };

  for (var entry in categoriesToFix.entries) {
    final existing = await isar.categorys.filter().externalIdEqualTo(entry.key).findFirst();
    if (existing != null) {
      // Always update, regardless of current value
      existing.iconPath = entry.value;
      await isar.writeTxn(() async {
        await isar.categorys.put(existing);
      });
      debugPrint('Force updated icon for category: ${entry.key} -> ${entry.value}');
    }
  }
}
