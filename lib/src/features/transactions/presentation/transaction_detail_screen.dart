import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';
import '../../../utils/icon_helper.dart';
import '../../bills/data/bill_repository.dart';

final walletsListProvider = FutureProvider<List<Wallet>>((ref) async {
  final repo = await ref.watch(walletRepositoryProvider.future);
  return repo.getAllWallets();
});

class TransactionDetailScreen extends ConsumerWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencySymbol = ref.watch(currencyProvider).symbol;
    
    // For transfer, we might not have a category, or we can show a default "Transfer" category
    final categoryAsync = ref.watch(categoryListProvider(
      transaction.type == TransactionType.expense ? CategoryType.expense : CategoryType.income
    ));
    final walletsAsync = ref.watch(walletsListProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text('Detail Transaksi', style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAmountSection(currencySymbol),
                  const SizedBox(height: 32),
                  _buildDetailItem('Judul', transaction.title),
                  _buildDivider(),
                  if (transaction.type != TransactionType.transfer) ...[
                    _buildDetailItem('Kategori', _getCategoryName(categoryAsync, transaction.categoryId)),
                    _buildDivider(),
                  ],
                  _buildDetailItem('Wallet', _getWalletName(walletsAsync, transaction.walletId)),
                  if (transaction.type == TransactionType.transfer && transaction.destinationWalletId != null) ...[
                     _buildDivider(),
                     _buildDetailItem('To Wallet', _getWalletName(walletsAsync, transaction.destinationWalletId)),
                  ],
                  _buildDivider(),
                  _buildDetailItem('Tanggal', DateFormat('dd MMM yyyy').format(transaction.date)),
                  _buildDivider(),
                  _buildDetailItem('Jam', DateFormat('HH:mm').format(transaction.date)),
                  if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                    _buildDivider(),
                    _buildDetailItem('Catatan', transaction.note!),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildAmountSection(String currencySymbol) {
    final isExpense = transaction.type == TransactionType.expense;
    final isTransfer = transaction.type == TransactionType.transfer;
    
    Color color;
    IconData icon;
    String label;
    String prefix;

    if (isTransfer) {
      color = Colors.blue;
      icon = Icons.swap_horiz;
      label = 'Transfer';
      prefix = '';
    } else if (isExpense || transaction.type == TransactionType.system) {
      color = Colors.red;
      icon = Icons.arrow_upward;
      label = transaction.type == TransactionType.system ? 'System (Wishlist)' : 'Pengeluaran';
      prefix = '-';
    } else {
      color = Colors.green;
      icon = Icons.arrow_downward;
      label = 'Pemasukan';
      prefix = '+';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 40,
            color: color,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '$prefix$currencySymbol ${transaction.amount.toStringAsFixed(0)}',
          style: AppTextStyles.h1.copyWith(
            color: color,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[200], thickness: 1);
  }

  Widget _buildBottomButtons(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Delete Button (Small)
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Transaksi?'),
                    content: const Text('Apakah Anda yakin ingin menghapus transaksi ini? Saldo wallet akan dikembalikan.'),
                    actions: [
                      TextButton(onPressed: () => context.pop(false), child: const Text('Batal')),
                      TextButton(
                        onPressed: () => context.pop(true), 
                        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  // Delete logic
                  // 1. Revert balance
                  final walletRepo = await ref.read(walletRepositoryProvider.future);
                  
                  // Source Wallet
                  final wallet = await walletRepo.getWallet(transaction.walletId!);
                  if (wallet != null) {
                    if (transaction.type == TransactionType.expense || transaction.type == TransactionType.transfer) {
                      wallet.balance += transaction.amount;
                    } else {
                      wallet.balance -= transaction.amount;
                    }
                    await walletRepo.addWallet(wallet);
                  }

                  // Destination Wallet (for Transfer)
                  if (transaction.type == TransactionType.transfer && transaction.destinationWalletId != null) {
                    final destWallet = await walletRepo.getWallet(transaction.destinationWalletId!);
                    if (destWallet != null) {
                      destWallet.balance -= transaction.amount; // Revert addition
                      await walletRepo.addWallet(destWallet);
                    }
                  }

                  // 2. Delete transaction
                  final transactionRepo = await ref.read(transactionRepositoryProvider.future);
                  await transactionRepo.deleteTransaction(transaction.id); 

                  if (context.mounted) {
                    context.pop(); // Close detail screen
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(Icons.delete_outline),
            ),
          ),
          const SizedBox(width: 16),
          // Edit Button (Large, 2:1 ratio)
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (transaction.type == TransactionType.system) {
                  // Handle System Transactions (Bills, Wishlist)
                  if (transaction.title.toLowerCase().contains('bill')) {
                    // Try to find associated Bill
                    final billRepo = ref.read(billRepositoryProvider);
                    final bill = await billRepo.getBillByTransactionId(transaction.id);
                    
                    if (context.mounted) {
                      if (bill != null) {
                        context.push('/bills/edit', extra: bill);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bill data not found')),
                        );
                      }
                    }
                  } else if (transaction.title.toLowerCase().contains('wishlist')) {
                    // Try to find associated Wishlist
                    // We need to import wishlist repository first
                    // For now, just show message or implement if wishlist edit is ready
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Editing Wishlist transaction is coming soon')),
                      );
                  } else {
                     // Fallback for other system types
                     context.push('/add-transaction', extra: transaction); 
                  }
                } else {
                  // Normal Transaction
                  context.push('/add-transaction', extra: transaction); 
                }
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(AsyncValue<List<Category>> categoryAsync, String? categoryId) {
    if (transaction.type == TransactionType.system) {
      return 'System';
    }
    if (categoryId == null) return '-';
    return categoryAsync.when(
      data: (categories) {
        final category = categories.firstWhere(
          (c) => (c.externalId ?? c.id.toString()) == categoryId, 
          orElse: () => Category(
            name: 'Unknown', 
            iconPath: 'help', 
            type: CategoryType.expense, 
            colorValue: Colors.grey.value
          )
        );
        return category.name;
      },
      loading: () => 'Loading...',
      error: (_, __) => 'Error',
    );
  }

  String _getWalletName(AsyncValue<List<Wallet>> walletsAsync, String? walletId) {
    return walletsAsync.when(
      data: (wallets) {
        final wallet = wallets.firstWhere(
          (w) => w.id.toString() == walletId || w.externalId == walletId, 
          orElse: () => Wallet()..name = 'Unknown'
        );
        return wallet.name;
      },
      loading: () => 'Loading...',
      error: (_, __) => 'Error',
    );
  }
}
