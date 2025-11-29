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
    
    final categoryAsync = ref.watch(categoryListProvider(transaction.isExpense ? CategoryType.expense : CategoryType.income));
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
                  _buildDetailItem('Kategori', _getCategoryName(categoryAsync, transaction.categoryId)),
                  _buildDivider(),
                  _buildDetailItem('Wallet', _getWalletName(walletsAsync, transaction.walletId)),
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: transaction.isExpense ? AppColors.accentPurple.withOpacity(0.2) : AppColors.accentBlue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            transaction.isExpense ? Icons.arrow_upward : Icons.arrow_downward,
            size: 40,
            color: transaction.isExpense ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${transaction.isExpense ? "-" : "+"}$currencySymbol ${transaction.amount.toStringAsFixed(0)}',
          style: AppTextStyles.h1.copyWith(
            color: transaction.isExpense ? Colors.red : Colors.green,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          transaction.isExpense ? 'Pengeluaran' : 'Pemasukan',
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
                  final wallet = await walletRepo.getWallet(transaction.walletId!);
                  if (wallet != null) {
                    if (transaction.isExpense) {
                      wallet.balance += transaction.amount;
                    } else {
                      wallet.balance -= transaction.amount;
                    }
                    await walletRepo.addWallet(wallet);
                  }

                  // 2. Delete transaction
                  final transactionRepo = await ref.read(transactionRepositoryProvider.future);
                  await transactionRepo.deleteTransaction(transaction.id.toString()); // Ensure ID type match

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
              onPressed: () {
                context.push('/add-transaction', extra: transaction); 
                // Note: We need to update app_router to handle passing Transaction object to AddTransactionScreen
                // Currently it expects bool. We need to adjust it.
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
    return categoryAsync.when(
      data: (categories) {
        final category = categories.firstWhere(
          (c) => c.id == categoryId, 
          orElse: () => Category(id: 'unknown', name: 'Unknown', iconPath: 'help', type: CategoryType.expense, color: Colors.grey, subCategories: [])
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
          (w) => w.id == walletId, 
          orElse: () => Wallet()..name = 'Unknown'
        );
        return wallet.name;
      },
      loading: () => 'Loading...',
      error: (_, __) => 'Error',
    );
  }
}
