import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/presentation/transaction_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../domain/category_data.dart';

final statisticsProvider = FutureProvider.family<List<CategoryData>, bool>((ref, isExpense) async {
  final transactions = await ref.watch(transactionListProvider.future);
  final categories = await ref.watch(categoryListProvider(isExpense ? CategoryType.expense : CategoryType.income).future);

  // 1. Filter transactions by type (Income/Expense)
  final filteredTransactions = transactions.where((t) => t.isExpense == isExpense).toList();

  if (filteredTransactions.isEmpty) return [];

  // 2. Calculate total amount
  final totalAmount = filteredTransactions.fold(0.0, (sum, t) => sum + t.amount);

  if (totalAmount == 0) return [];

  // 3. Group by Category
  final Map<String, double> categoryTotals = {};
  for (var t in filteredTransactions) {
    if (t.categoryId != null) {
      categoryTotals[t.categoryId!] = (categoryTotals[t.categoryId!] ?? 0) + t.amount;
    }
  }

  // 4. Create CategoryData list
  final List<CategoryData> data = [];
  for (var entry in categoryTotals.entries) {
    final categoryId = entry.key;
    final amount = entry.value;
    final percentage = (amount / totalAmount) * 100;

    // Find category details
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => categories.first, // Fallback (should ideally handle unknown category)
    );

    data.add(CategoryData(
      categoryId: categoryId,
      categoryName: category.name,
      amount: amount,
      percentage: percentage,
      color: category.color,
      iconPath: category.iconPath,
    ));
  }

  // 5. Sort by amount descending
  data.sort((a, b) => b.amount.compareTo(a.amount));

  return data;
});

class MonthlyData {
  final DateTime month;
  final double income;
  final double expense;

  MonthlyData({required this.month, required this.income, required this.expense});
}

final monthlyStatisticsProvider = FutureProvider<List<MonthlyData>>((ref) async {
  final transactions = await ref.watch(transactionListProvider.future);
  
  // Get last 6 months
  final now = DateTime.now();
  final List<MonthlyData> data = [];

  for (int i = 5; i >= 0; i--) {
    final monthStart = DateTime(now.year, now.month - i, 1);
    final monthEnd = DateTime(now.year, now.month - i + 1, 0);

    final monthTransactions = transactions.where((t) {
      return t.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
             t.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
    }).toList();

    double income = 0;
    double expense = 0;

    for (var t in monthTransactions) {
      if (t.isExpense) {
        expense += t.amount;
      } else {
        income += t.amount;
      }
    }

    data.add(MonthlyData(month: monthStart, income: income, expense: expense));
  }

  return data;
});

class DailyData {
  final int day;
  final double income;
  final double expense;

  DailyData({required this.day, required this.income, required this.expense});
}

final dailyStatisticsProvider = FutureProvider<List<DailyData>>((ref) async {
  final transactions = await ref.watch(transactionListProvider.future);
  
  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);
  final monthEnd = DateTime(now.year, now.month + 1, 0);
  final daysInMonth = monthEnd.day;

  final List<DailyData> data = [];

  // Filter for current month
  final monthTransactions = transactions.where((t) {
    return t.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
           t.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
  }).toList();

  for (int day = 1; day <= daysInMonth; day++) {
    final dayTransactions = monthTransactions.where((t) => t.date.day == day);
    
    double income = 0;
    double expense = 0;

    for (var t in dayTransactions) {
      if (t.isExpense) {
        expense += t.amount;
      } else {
        income += t.amount;
      }
    }
    
    data.add(DailyData(day: day, income: income, expense: expense));
  }

  return data;
});
