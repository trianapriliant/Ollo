import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/data/transaction_repository.dart';

enum TimeFilterType { day, month, year, all, custom }

class DashboardFilterState {
  final TimeFilterType filterType;
  final DateTimeRange? customRange;
  final DateTime selectedDate; // For day/month/year navigation

  DashboardFilterState({
    this.filterType = TimeFilterType.month,
    this.customRange,
    required this.selectedDate,
  });

  DashboardFilterState copyWith({
    TimeFilterType? filterType,
    DateTimeRange? customRange,
    DateTime? selectedDate,
  }) {
    return DashboardFilterState(
      filterType: filterType ?? this.filterType,
      customRange: customRange ?? this.customRange,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class DashboardFilterNotifier extends StateNotifier<DashboardFilterState> {
  DashboardFilterNotifier() : super(DashboardFilterState(selectedDate: DateTime.now()));

  void setFilterType(TimeFilterType type) {
    state = state.copyWith(filterType: type);
  }

  void setCustomRange(DateTimeRange range) {
    state = state.copyWith(filterType: TimeFilterType.custom, customRange: range);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }
}

final dashboardFilterProvider = StateNotifierProvider<DashboardFilterNotifier, DashboardFilterState>((ref) {
  return DashboardFilterNotifier();
});

// Provider for filtered transactions
// Provider for filtered transactions
final filteredTransactionsProvider = StreamProvider<List<Transaction>>((ref) async* {
  final repository = await ref.watch(transactionRepositoryProvider.future);
  final allTransactionsStream = repository.watchTransactions();
  final filterState = ref.watch(dashboardFilterProvider);

  await for (final allTransactions in allTransactionsStream) {
    yield allTransactions.where((transaction) {
      final date = transaction.date;
      final now = filterState.selectedDate;

      switch (filterState.filterType) {
        case TimeFilterType.day:
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case TimeFilterType.month:
          return date.year == now.year && date.month == now.month;
        case TimeFilterType.year:
          return date.year == now.year;
        case TimeFilterType.all:
          return true;
        case TimeFilterType.custom:
          if (filterState.customRange == null) return true;
          return date.isAfter(filterState.customRange!.start.subtract(const Duration(seconds: 1))) &&
                 date.isBefore(filterState.customRange!.end.add(const Duration(seconds: 1)));
      }
    }).toList();
  }
});

// Provider for Income/Expense Totals
final dashboardTotalsProvider = FutureProvider<Map<String, double>>((ref) async {
  final transactions = await ref.watch(filteredTransactionsProvider.future);
  
  double income = 0;
  double expense = 0;

  for (var t in transactions) {
    if (!t.isExpense) {
      income += t.amount;
    } else {
      expense += t.amount;
    }
  }

  return {'income': income, 'expense': expense};
});
