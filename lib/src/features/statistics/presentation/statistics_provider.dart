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
