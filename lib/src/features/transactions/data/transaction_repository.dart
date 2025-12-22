import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction.dart';

import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../../wallets/domain/wallet.dart';

abstract class TransactionRepository {
  Future<int> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(Id id);
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsByCategoryId(String categoryId);
  Future<List<Transaction>> getTransactionsBySubCategoryId(String subCategoryId);
  Future<void> clearAllTransactions();
  Future<void> importTransactions(List<Transaction> transactions);
  Stream<List<Transaction>> watchTransactions();
}

final transactionRepositoryProvider = FutureProvider<TransactionRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarTransactionRepository(isar);
});

final transactionStreamProvider = StreamProvider<List<Transaction>>((ref) async* {
  final repository = await ref.watch(transactionRepositoryProvider.future);
  yield* repository.watchTransactions();
});

class IsarTransactionRepository implements TransactionRepository {
  final Isar isar;

  IsarTransactionRepository(this.isar);

  @override
  Future<int> addTransaction(Transaction transaction) async {
    return await isar.writeTxn(() async {
      final id = await isar.transactions.put(transaction);
      
      // Update Wallet Balance
      // Update Wallet Balance
      if (transaction.walletId != null) {
        final wallet = await isar.wallets.filter().idEqualTo(int.tryParse(transaction.walletId!) ?? -1).or().externalIdEqualTo(transaction.walletId!).findFirst();
        
        if (wallet != null) {
          if (transaction.type == TransactionType.income) {
            wallet.balance += transaction.amount;
          } else {
            // Expense & Transfer (Source)
            wallet.balance -= transaction.amount;
          }
          await isar.wallets.put(wallet);
        }
      }

      // Update Destination Wallet (for Transfers)
      if (transaction.type == TransactionType.transfer && transaction.destinationWalletId != null) {
        final destWallet = await isar.wallets.filter().idEqualTo(int.tryParse(transaction.destinationWalletId!) ?? -1).or().externalIdEqualTo(transaction.destinationWalletId!).findFirst();
        
        if (destWallet != null) {
           destWallet.balance += transaction.amount;
           await isar.wallets.put(destWallet);
        }
      }
      return id;
    });
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    // Note: Complex handling needed for balance update on edit. 
    // Simplified for now: assuming Amount changes are handled separately or rarely. 
    // Ideally, we should diff with old transaction or revert old and apply new.
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  @override
  Future<void> deleteTransaction(Id id) async {
    await isar.writeTxn(() async {
      final transaction = await isar.transactions.get(id);
      if (transaction != null) {
        // Revert Wallet Balance
        if (transaction.walletId != null) {
          final wallet = await isar.wallets.filter().idEqualTo(int.tryParse(transaction.walletId!) ?? -1).or().externalIdEqualTo(transaction.walletId!).findFirst();
          
          if (wallet != null) {
            if (transaction.type == TransactionType.income) {
               wallet.balance -= transaction.amount;
            } else {
               wallet.balance += transaction.amount;
            }
            await isar.wallets.put(wallet);
          }
        }
        // Revert Destination Wallet for Transfers
        if (transaction.type == TransactionType.transfer && transaction.destinationWalletId != null) {
            final destWallet = await isar.wallets.filter()
                .idEqualTo(int.tryParse(transaction.destinationWalletId!) ?? -1)
                .or()
                .externalIdEqualTo(transaction.destinationWalletId!)
                .findFirst();
            
            if (destWallet != null) {
               destWallet.balance -= transaction.amount;
               await isar.wallets.put(destWallet);
            }
        }

        await isar.transactions.delete(id);
      }
    });
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return isar.transactions.where().sortByDateDesc().findAll();
  }

  @override
  Future<List<Transaction>> getTransactionsByCategoryId(String categoryId) async {
    return isar.transactions.filter().categoryIdEqualTo(categoryId).findAll();
  }

  @override
  Future<List<Transaction>> getTransactionsBySubCategoryId(String subCategoryId) async {
    return isar.transactions.filter().subCategoryIdEqualTo(subCategoryId).findAll();
  }

  @override
  Future<void> clearAllTransactions() async {
    await isar.writeTxn(() async {
      await isar.transactions.clear();
    });
  }

  @override
  Future<void> importTransactions(List<Transaction> transactions) async {
    await isar.writeTxn(() async {
      await isar.transactions.putAll(transactions);
    });
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return isar.transactions.where().sortByDateDesc().watch(fireImmediately: true);
  }
}


