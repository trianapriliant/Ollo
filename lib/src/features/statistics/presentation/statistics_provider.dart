import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../dashboard/presentation/transaction_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../domain/category_data.dart';
import '../../savings/data/saving_repository.dart';
import '../../savings/domain/saving_log.dart';
import '../../transactions/domain/transaction.dart';

enum TimeRange { month, year }

class StatisticsFilter {
  final bool isExpense;
  final TimeRange timeRange;
  final DateTime date;

  StatisticsFilter({required this.isExpense, required this.timeRange, required this.date});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsFilter &&
          runtimeType == other.runtimeType &&
          isExpense == other.isExpense &&
          timeRange == other.timeRange &&
          date.year == other.date.year &&
          date.month == other.date.month;

  @override
  int get hashCode => Object.hash(isExpense, timeRange, date.year, date.month);
}

final statisticsProvider = FutureProvider.autoDispose.family<List<CategoryData>, StatisticsFilter>((ref, filter) async {
  final transactions = await ref.watch(transactionListProvider.future);
  final categories = await ref.watch(categoryListProvider(filter.isExpense ? CategoryType.expense : CategoryType.income).future);

  // 1. Calculate Date Range (Standardized with InsightProvider)
  DateTime start, end;
  if (filter.timeRange == TimeRange.month) {
    start = DateTime(filter.date.year, filter.date.month, 1);
    end = DateTime(filter.date.year, filter.date.month + 1, 0, 23, 59, 59, 999);
  } else {
    start = DateTime(filter.date.year, 1, 1);
    end = DateTime(filter.date.year, 12, 31, 23, 59, 59, 999);
  }

  final filteredTransactions = transactions.where((t) {
    // STRICT FILTER w/ SAVINGS EXCLUSION
    if (filter.isExpense) {
      if (t.type == TransactionType.expense) {
         // keep
      } else if (t.type == TransactionType.system && t.categoryId != 'savings') {
         // keep
      } else {
        return false;
      }
    } else {
      if (t.type != TransactionType.income) return false;
    }

    // Use range check (Standardized)
    // t.date is likely UTC/Raw. start/end are Local.
    // Dart comparison handles this, or we rely on the implementation that works in InsightProvider.
    return t.date.isAfter(start.subtract(const Duration(milliseconds: 1))) && 
           t.date.isBefore(end.add(const Duration(milliseconds: 1)));
  }).toList();

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
      (c) => (c.externalId ?? c.id.toString()) == categoryId,
      orElse: () {
        // Fallback for system or unknown categories
        return Category(
          externalId: categoryId,
          name: _formatCategoryName(categoryId),
          iconPath: categoryId, // Use ID as icon path for system mapping
          type: filter.isExpense ? CategoryType.expense : CategoryType.income,
          colorValue: Colors.grey.value,
          subCategories: [],
        );
      },
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

String _formatCategoryName(String id) {
  // Capitalize first letter
  if (id.isEmpty) return 'Unknown';
  return id[0].toUpperCase() + id.substring(1);
}

class InsightData {
  final String message;
  final bool isGood; // e.g. expense down is good, income up is good
  final double percentageChange;

  InsightData({required this.message, required this.isGood, required this.percentageChange});
}

final insightProvider = FutureProvider.autoDispose.family<InsightData?, StatisticsFilter>((ref, filter) async {
  final transactions = await ref.watch(transactionListProvider.future);
  
  final now = filter.date;
  DateTime currentStart, currentEnd, previousStart, previousEnd;

  if (filter.timeRange == TimeRange.month) {
    currentStart = DateTime(now.year, now.month, 1);
    currentEnd = DateTime(now.year, now.month + 1, 0);
    previousStart = DateTime(now.year, now.month - 1, 1);
    previousEnd = DateTime(now.year, now.month, 0);
  } else {
    currentStart = DateTime(now.year, 1, 1);
    currentEnd = DateTime(now.year, 12, 31);
    previousStart = DateTime(now.year - 1, 1, 1);
    previousEnd = DateTime(now.year - 1, 12, 31);
  }

  double calculateTotal(DateTime start, DateTime end) {
    return transactions
        .where((t) {
             // STRICT FILTER w/ SAVINGS EXCLUSION
            if (filter.isExpense) {
               bool isValidExpense = t.type == TransactionType.expense || (t.type == TransactionType.system && t.categoryId != 'savings');
               if (!isValidExpense) return false;
            } else {
               if (t.type != TransactionType.income) return false;
            }
            return t.date.isAfter(start.subtract(const Duration(seconds: 1))) && 
                   t.date.isBefore(end.add(const Duration(seconds: 1)));
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  final currentTotal = calculateTotal(currentStart, currentEnd);
  final previousTotal = calculateTotal(previousStart, previousEnd);

  if (previousTotal == 0) return null;

  final change = currentTotal - previousTotal;
  final percentage = (change / previousTotal) * 100;
  
  String message;
  bool isGood;

  if (filter.isExpense) {
    if (percentage < 0) {
      message = 'Expenses down ${percentage.abs().toStringAsFixed(1)}% from last ${filter.timeRange == TimeRange.month ? "month" : "year"}';
      isGood = true;
    } else {
      message = 'Expenses up ${percentage.abs().toStringAsFixed(1)}% from last ${filter.timeRange == TimeRange.month ? "month" : "year"}';
      isGood = false;
    }
  } else {
    if (percentage > 0) {
      message = 'Income up ${percentage.abs().toStringAsFixed(1)}% from last ${filter.timeRange == TimeRange.month ? "month" : "year"}';
      isGood = true;
    } else {
      message = 'Income down ${percentage.abs().toStringAsFixed(1)}% from last ${filter.timeRange == TimeRange.month ? "month" : "year"}';
      isGood = false;
    }
  }

  return InsightData(message: message, isGood: isGood, percentageChange: percentage);
});

class MonthlyData {
  final DateTime month;
  final double income;
  final double expense;

  MonthlyData({required this.month, required this.income, required this.expense});
}

final monthlyStatisticsProvider = FutureProvider.family<List<MonthlyData>, DateTime>((ref, date) async {
  final transactions = await ref.watch(transactionListProvider.future);
  
  // Get all months for the selected year
  final List<MonthlyData> data = [];

  for (int i = 1; i <= 12; i++) {
    final monthStart = DateTime(date.year, i, 1);
    final monthEnd = DateTime(date.year, i + 1, 0);

    final monthTransactions = transactions.where((t) {
      return t.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
             t.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
    }).toList();

    double income = 0;
    double expense = 0;

    for (var t in monthTransactions) {
      if (t.type == TransactionType.expense) {
        expense += t.amount;
      } else if (t.type == TransactionType.system && t.categoryId != 'savings') {
        expense += t.amount; // Include System bills/debt, exclude Savings
      } else if (t.type == TransactionType.income) {
        income += t.amount;
      }
      // Explicitly ignore transfer
    }

    data.add(MonthlyData(month: monthStart, income: income, expense: expense));
  }

  return data;
});

class DailyData {
  final int day;
  final double income;
  final double expense;
  final double savings;

  DailyData({required this.day, required this.income, required this.expense, required this.savings});
}

final dailyStatisticsProvider = FutureProvider.family<List<DailyData>, DateTime>((ref, date) async {
  final transactions = await ref.watch(transactionListProvider.future);
  // Watch the savingLog stream for reactive updates when logs change
  final savingLogs = await ref.watch(savingLogListProvider.future);
  
  final monthStart = DateTime(date.year, date.month, 1);
  final monthEnd = DateTime(date.year, date.month + 1, 0);
  final daysInMonth = monthEnd.day;

  final List<DailyData> data = [];

  // Filter transactions for selected month
  final monthTransactions = transactions.where((t) {
    return t.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
           t.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
  }).toList();

  // Filter saving logs for selected month
  final monthSavingLogs = savingLogs.where((l) {
    return l.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
           l.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
  }).toList();

  for (int day = 1; day <= daysInMonth; day++) {
    final dayTransactions = monthTransactions.where((t) => t.date.day == day);
    final daySavingLogs = monthSavingLogs.where((l) => l.date.day == day);
    
    double income = 0;
    double expense = 0;
    double savings = 0;

    for (var t in dayTransactions) {
      if (t.type == TransactionType.expense) {
        expense += t.amount;
      } else if (t.type == TransactionType.system && t.categoryId != 'savings') {
        expense += t.amount; // Include System bills/debt, exclude Savings
      } else if (t.type == TransactionType.income) {
        income += t.amount;
      }
       // Explicitly ignore transfer 
    }

    for (var l in daySavingLogs) {
      if (l.type == SavingLogType.deposit) {
        savings += l.amount;
      } else if (l.type == SavingLogType.withdraw) {
        savings -= l.amount;
      }
    }
    
    data.add(DailyData(day: day, income: income, expense: expense, savings: savings));
  }

  return data;
});

class WeeklyData {
  final int week;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;

  WeeklyData({
    required this.week,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });
}

final weeklyStatisticsProvider = FutureProvider.family<List<WeeklyData>, StatisticsFilter>((ref, filter) async {
  final transactions = await ref.watch(transactionListProvider.future);
  
  final year = filter.date.year;
  final yearStart = DateTime(year, 1, 1);
  final yearEnd = DateTime(year, 12, 31, 23, 59, 59);

  // Filter for the year and type
  final yearTransactions = transactions.where((t) {
      if (filter.isExpense) {
         if (t.type == TransactionType.expense || (t.type == TransactionType.system && t.categoryId != 'savings')) {
            // keep
         } else {
           return false;
         }
      } else {
         if (t.type != TransactionType.income) return false;
      }
      return t.date.year == year;
  }).toList();

  final Map<int, double> weekTotals = {};
  
  // Initialize map for 53 weeks (max potential)
  for (int i = 1; i <= 53; i++) {
    weekTotals[i] = 0.0;
  }

  for (var t in yearTransactions) {
    // Determine week number based on day of year
    // This aligns with our grid generation logic: Week 1 = Jan 1-7, Week 2 = Jan 8-14, etc.
    final dayOfYear = int.parse(DateFormat('D').format(t.date));
    final weekNum = ((dayOfYear - 1) / 7).floor() + 1;
    
    if (weekNum <= 53) {
      weekTotals[weekNum] = (weekTotals[weekNum] ?? 0) + t.amount;
    }
  }

  final List<WeeklyData> data = [];
  
  // Generate data list
  for (int i = 1; i <= 53; i++) {
     // Calculate approximation of start/end date for the week
     // This is rough estimation but enough for UI tooltip
     // ISO weeks are complicated, but for display:
     // Jan 1 + (week-1)*7 days
     DateTime weekStart = DateTime(year, 1, 1).add(Duration(days: (i - 1) * 7));
     if (weekStart.year > year) break; // Don't go into next year
     DateTime weekEnd = weekStart.add(const Duration(days: 6));
     
     // Correct the first week start to Jan 1? 
     // DateFormat 'w' logic is simpler. 
     // Let's just pass the week number and calculated dates.
     
     data.add(WeeklyData(
       week: i, 
       amount: weekTotals[i] ?? 0, 
       startDate: weekStart, 
       endDate: weekEnd
     ));
  }

  return data;
});
