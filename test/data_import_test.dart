import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ollo/src/features/profile/application/data_import_service.dart';
import 'package:ollo/src/features/transactions/data/transaction_repository.dart';
import 'package:ollo/src/features/wallets/data/wallet_repository.dart';
import 'package:ollo/src/features/categories/data/category_repository.dart';
import 'package:ollo/src/features/wallets/domain/wallet.dart';
import 'package:ollo/src/features/transactions/domain/transaction.dart';
import 'package:ollo/src/features/categories/domain/category.dart';
import 'package:isar/isar.dart';

// Fake Transaction Repository
class FakeTransactionRepository implements TransactionRepository {
  final List<Transaction> transactions = [];

  @override
  Future<int> addTransaction(Transaction transaction) async {
    transactions.add(transaction);
    return transactions.length;
  }

  @override
  Future<void> clearAllTransactions() async => transactions.clear();

  @override
  Future<void> deleteTransaction(Id id) async {}

  @override
  Future<List<Transaction>> getAllTransactions() async => transactions;

  @override
  Future<void> importTransactions(List<Transaction> transactions) async {
    this.transactions.addAll(transactions);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {}

  @override
  Stream<List<Transaction>> watchTransactions() {
    return Stream.value(transactions);
  }
}

// Fake Wallet Repository
class FakeWalletRepository implements WalletRepository {
  final List<Wallet> wallets = [
    Wallet.create(name: 'Cash', balance: 1000, colorValue: 0, iconPath: 'cash', externalId: 'cash_default'),
    Wallet.create(name: 'Bank', balance: 5000, colorValue: 0, iconPath: 'bank', externalId: 'bank_account'),
  ];

  @override
  Future<void> addWallet(Wallet wallet) async {
    wallets.add(wallet);
  }

  @override
  Future<void> updateWallet(Wallet wallet) async {
     // Find and replace
     final index = wallets.indexWhere((w) => w.id == wallet.id);
     if (index != -1) {
       wallets[index] = wallet;
     }
  }

  @override
  Future<void> deleteWallet(int id) async {
    wallets.removeWhere((w) => w.id == id);
  }

  @override
  Future<List<Wallet>> getAllWallets() async => wallets;

  @override
  Future<Wallet?> getWallet(String id) async {
    try {
      return wallets.firstWhere((w) => w.externalId == id || w.id.toString() == id);
    } catch (_) {
      return null;
    }
  }
  
  @override
  Future<void> clearAllWallets() async => wallets.clear();
  
  @override
  Future<void> importWallets(List<Wallet> wallets) async => this.wallets.addAll(wallets);

  @override
  Stream<List<Wallet>> watchWallets() {
    return Stream.value(wallets);
  }
}

void main() {
  test('DataImportService should parse valid CSV content correctly', () async {
    // Setup Fakes
    final fakeTransactionRepo = FakeTransactionRepository();
    final fakeWalletRepo = FakeWalletRepository();
    
    // Setup Mock Categories
    final categories = [
      Category(name: 'Food', iconPath: 'fastfood', type: CategoryType.expense, colorValue: 0, externalId: 'food'),
      Category(name: 'Salary', iconPath: 'work', type: CategoryType.income, colorValue: 0, externalId: 'salary'),
      Category(name: 'Financial', iconPath: 'attach_money', type: CategoryType.expense, colorValue: 0, externalId: 'financial'), // For fees
    ];

    final container = ProviderContainer(
      overrides: [
        transactionRepositoryProvider.overrideWith((ref) => Future.value(fakeTransactionRepo)),
        walletRepositoryProvider.overrideWith((ref) => Future.value(fakeWalletRepo)),
        allCategoriesStreamProvider.overrideWith((ref) => Stream.value(categories)),
      ],
    );

    final service = container.read(dataImportServiceProvider);

    final csvContent = '''
Date,Type,Amount,Title,Wallet,Destination,Category,SubCategory,Note,Fee
2023-10-01,Expense,50000,Lunch,Cash,,Food,,Team Lunch,
2023-10-02,Income,10000000,Salary,Bank,,Salary,,Monthly Salary,
2023-10-03,Transfer,500000,Topup,Bank,Cash,,,,2500
''';

    final result = await service.importCsvContent(csvContent);

    expect(result['success'], 3);
    expect(result['failed'], 0);

    // Verify Transactions
    expect(fakeTransactionRepo.transactions.length, 4); // 3 + 1 Fee

    final lunch = fakeTransactionRepo.transactions[0];
    expect(lunch.title, 'Lunch');
    expect(lunch.amount, 50000);
    expect(lunch.type, TransactionType.expense);
    expect(lunch.walletId, 'cash_default');

    final salary = fakeTransactionRepo.transactions[1];
    expect(salary.title, 'Salary');
    expect(salary.amount, 10000000);
    expect(salary.type, TransactionType.income);
    expect(salary.walletId, 'bank_account');
    
    final transfer = fakeTransactionRepo.transactions[2];
    expect(transfer.title, 'Topup');
    expect(transfer.amount, 500000);
    expect(transfer.type, TransactionType.transfer);
    expect(transfer.walletId, 'bank_account'); // Source
    // Destination check requires looking at logic, but we mocked repository so specific ISAR logic isn't run, 
    // but the transaction object sent to repo should have destWalletId
    // Note: My FakeWalletRepository uses generated IDs which might be tricky if I didn't set them manually? 
    // Wallet.create sets id to Isar.autoIncrement which is not usable without Isar instance?
    // Actually Wallet.create doesn't set ID, it's auto-increment.
    // However, I used externalId for lookup which is safe.

    final fee = fakeTransactionRepo.transactions[3];
    expect(fee.title, 'Transfer Fee (Topup)');
    expect(fee.amount, 2500);
    expect(fee.type, TransactionType.expense);
  });
}
