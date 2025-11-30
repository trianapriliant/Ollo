import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/budget.dart';
import '../../transactions/domain/transaction.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final isar = ref.watch(isarProvider).valueOrNull;
  if (isar == null) throw UnimplementedError('Isar not initialized');
  return IsarBudgetRepository(isar);
});

final budgetListProvider = StreamProvider<List<Budget>>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return repository.watchBudgets();
});

abstract class BudgetRepository {
  Future<void> addBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(Id id);
  Future<List<Budget>> getAllBudgets();
  Future<List<Budget>> getBudgetsByPeriod(BudgetPeriod period);
  Stream<List<Budget>> watchBudgets();
  
  // Calculate spent amount for a budget based on transactions
  // Calculate spent amount for a budget based on transactions
  Future<double> calculateSpentAmount(Budget budget);
  Future<double> calculateSpentAmountForRange(Budget budget, DateTime start, DateTime end);
}

class IsarBudgetRepository implements BudgetRepository {
  final Isar isar;

  IsarBudgetRepository(this.isar);

  @override
  Future<void> addBudget(Budget budget) async {
    await isar.writeTxn(() async {
      await isar.budgets.put(budget);
    });
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    await isar.writeTxn(() async {
      await isar.budgets.put(budget);
    });
  }

  @override
  Future<void> deleteBudget(Id id) async {
    await isar.writeTxn(() async {
      await isar.budgets.delete(id);
    });
  }

  @override
  Future<List<Budget>> getAllBudgets() async {
    return await isar.budgets.where().findAll();
  }

  @override
  Future<List<Budget>> getBudgetsByPeriod(BudgetPeriod period) async {
    return await isar.budgets.filter().periodEqualTo(period).findAll();
  }

  @override
  Stream<List<Budget>> watchBudgets() {
    return isar.budgets.where().watch(fireImmediately: true);
  }

  @override
  Future<double> calculateSpentAmount(Budget budget) async {
    // Determine date range based on period
    final now = DateTime.now();
    DateTime start;
    DateTime end = now;

    switch (budget.period) {
      case BudgetPeriod.weekly:
        // Start of week (Monday)
        start = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(start.year, start.month, start.day); // Reset time
        break;
      case BudgetPeriod.monthly:
        // Start of month
        start = DateTime(now.year, now.month, 1);
        break;
      case BudgetPeriod.yearly:
        // Start of year
        start = DateTime(now.year, 1, 1);
        break;
    }

    // Query transactions for this category within the date range
    final transactions = await isar.transactions
        .filter()
        .categoryIdEqualTo(budget.categoryId)
        .dateBetween(start, end)
        .typeEqualTo(TransactionType.expense)
        .findAll();

    // Sum amounts
    return transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Future<double> calculateSpentAmountForRange(Budget budget, DateTime start, DateTime end) async {
    final transactions = await isar.transactions
        .filter()
        .categoryIdEqualTo(budget.categoryId)
        .dateBetween(start, end)
        .typeEqualTo(TransactionType.expense)
        .findAll();

    return transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
  }
}
