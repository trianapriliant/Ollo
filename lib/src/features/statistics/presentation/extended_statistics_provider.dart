import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/presentation/transaction_provider.dart';
import '../../transactions/domain/transaction.dart';
import 'statistics_provider.dart';

// --- 1. Comparative Analysis Provider ---

class ComparativeData {
  final List<double> currentPeriodData;
  final List<double> previousPeriodData;
  final double currentTotal;
  final double previousTotal;
  final double percentageChange;

  ComparativeData({
    required this.currentPeriodData,
    required this.previousPeriodData,
    required this.currentTotal,
    required this.previousTotal,
    required this.percentageChange,
  });
}

final comparativeStatisticsProvider = FutureProvider.autoDispose.family<ComparativeData?, StatisticsFilter>((ref, filter) async {
  final transactions = await ref.watch(transactionListProvider.future);
  
  final now = filter.date;
  DateTime currentStart, currentEnd, previousStart, previousEnd;

  if (filter.timeRange == TimeRange.week) {
    // Weekly view: compare days (7 days)
    final weekday = now.weekday;
    currentStart = now.subtract(Duration(days: weekday - 1));
    currentStart = DateTime(currentStart.year, currentStart.month, currentStart.day);
    currentEnd = currentStart.add(const Duration(days: 6));
    previousStart = currentStart.subtract(const Duration(days: 7));
    previousEnd = previousStart.add(const Duration(days: 6));
  } else if (filter.timeRange == TimeRange.month) {
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

  // Helper to filter and aggregate by day (for weekly/monthly view)
  List<double> getDailyTotals(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    final List<double> dailyTotals = List.filled(days, 0.0);

    final periodTransactions = transactions.where((t) {
      if (filter.isExpense) {
          bool isValidExpense = t.type == TransactionType.expense || (t.type == TransactionType.system && t.categoryId != 'savings');
          if (!isValidExpense) return false;
      } else {
          if (t.type != TransactionType.income) return false;
      }
      final tDate = t.date.toLocal();
      return tDate.isAfter(start.subtract(const Duration(seconds: 1))) && 
             tDate.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();

    for (var t in periodTransactions) {
      final dayIndex = t.date.difference(start).inDays;
      if (dayIndex >= 0 && dayIndex < days) {
        dailyTotals[dayIndex] += t.amount;
      }
    }
    return dailyTotals;
  }

  // Helper to filter and aggregate by month (for yearly view)
  List<double> getMonthlyTotals(int year) {
    final List<double> monthlyTotals = List.filled(12, 0.0);
    
    final periodTransactions = transactions.where((t) {
      if (filter.isExpense) {
          bool isValidExpense = t.type == TransactionType.expense || (t.type == TransactionType.system && t.categoryId != 'savings');
          if (!isValidExpense) return false;
      } else {
          if (t.type != TransactionType.income) return false;
      }
      return t.date.year == year;
    }).toList();

    for (var t in periodTransactions) {
      final monthIndex = t.date.month - 1; // 0-based
      monthlyTotals[monthIndex] += t.amount;
    }
    return monthlyTotals;
  }

  List<double> currentData;
  List<double> previousData;

  if (filter.timeRange == TimeRange.week) {
    // Weekly view: compare days (7 days)
    currentData = getDailyTotals(currentStart, currentEnd);
    previousData = getDailyTotals(previousStart, previousEnd);
  } else if (filter.timeRange == TimeRange.month) {
    // Monthly view: compare days
    currentData = getDailyTotals(currentStart, currentEnd);
    previousData = getDailyTotals(previousStart, previousEnd);
  } else {
    // Yearly view: compare months
    currentData = getMonthlyTotals(now.year);
    previousData = getMonthlyTotals(now.year - 1);
  }

  final currentTotal = currentData.fold(0.0, (sum, val) => sum + val);
  final previousTotal = previousData.fold(0.0, (sum, val) => sum + val);

  if (previousTotal == 0 && currentTotal == 0) return null;

  double percentage = 0.0;
  if (previousTotal != 0) {
    percentage = ((currentTotal - previousTotal) / previousTotal) * 100;
  } else if (currentTotal > 0) {
    percentage = 100.0;
  }

  return ComparativeData(
    currentPeriodData: currentData,
    previousPeriodData: previousData,
    currentTotal: currentTotal,
    previousTotal: previousTotal,
    percentageChange: percentage,
  );
});


// --- 2. Top Spenders (Merchants) Provider ---

class MerchantData {
  final String name;
  final double amount;
  final int count;

  MerchantData({required this.name, required this.amount, required this.count});
}

final topMerchantsProvider = FutureProvider.autoDispose.family<List<MerchantData>, StatisticsFilter>((ref, filter) async {
  final transactions = await ref.watch(transactionListProvider.future);

  // Calculate Date Range
  DateTime start, end;
  if (filter.timeRange == TimeRange.month) {
    start = DateTime(filter.date.year, filter.date.month, 1);
    end = DateTime(filter.date.year, filter.date.month + 1, 0, 23, 59, 59, 999);
  } else {
    start = DateTime(filter.date.year, 1, 1);
    end = DateTime(filter.date.year, 12, 31, 23, 59, 59, 999);
  }

  // Filter first
   final filteredTransactions = transactions.where((t) {
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

    return t.date.isAfter(start.subtract(const Duration(milliseconds: 1))) && 
           t.date.isBefore(end.add(const Duration(milliseconds: 1)));
  }).toList();

  final Map<String, MerchantData> merchantMap = {};

  for (var t in filteredTransactions) {
    final name = t.title; // Using title as Merchant name
    if (merchantMap.containsKey(name)) {
      final existing = merchantMap[name]!;
      merchantMap[name] = MerchantData(
        name: name, 
        amount: existing.amount + t.amount, 
        count: existing.count + 1
      );
    } else {
      merchantMap[name] = MerchantData(name: name, amount: t.amount, count: 1);
    }
  }

  final List<MerchantData> sortedMerchants = merchantMap.values.toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  return sortedMerchants.take(5).toList(); // Top 5
});
