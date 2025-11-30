import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/data/transaction_repository.dart';

enum TimeFilterType { day, week, month, year, all }

class DashboardFilterState {
  final TimeFilterType filterType;
  final DateTime selectedDate; // For navigation

  DashboardFilterState({
    this.filterType = TimeFilterType.month,
    required this.selectedDate,
  });

  DashboardFilterState copyWith({
    TimeFilterType? filterType,
    DateTime? selectedDate,
  }) {
    return DashboardFilterState(
      filterType: filterType ?? this.filterType,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class DashboardFilterNotifier extends StateNotifier<DashboardFilterState> {
  DashboardFilterNotifier() : super(DashboardFilterState(selectedDate: DateTime.now()));

  void setFilterType(TimeFilterType type) {
    state = state.copyWith(filterType: type);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }
}

final dashboardFilterProvider = StateNotifierProvider<DashboardFilterNotifier, DashboardFilterState>((ref) {
  return DashboardFilterNotifier();
});

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
        case TimeFilterType.week:
          // Find start of week (Monday)
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          
          // Normalize dates to ignore time for comparison
          final tDate = DateTime(date.year, date.month, date.day);
          final sDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
          final eDate = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);
          
          return (tDate.isAtSameMomentAs(sDate) || tDate.isAfter(sDate)) && 
                 (tDate.isAtSameMomentAs(eDate) || tDate.isBefore(eDate));
        case TimeFilterType.month:
          return date.year == now.year && date.month == now.month;
        case TimeFilterType.year:
          return date.year == now.year;
        case TimeFilterType.all:
          return true;
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
