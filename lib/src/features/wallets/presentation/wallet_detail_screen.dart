import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../dashboard/presentation/widgets/recent_transactions_list.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../data/wallet_repository.dart';
import '../domain/wallet.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../common_widgets/wallet_icon.dart';
import 'wallet_provider.dart';
import 'add_wallet_screen.dart';

class WalletDetailScreen extends ConsumerWidget {
  final Wallet wallet;

  const WalletDetailScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final transactionsAsync = ref.watch(transactionStreamProvider);
    final walletsAsync = ref.watch(walletListProvider);

    // Get the latest wallet data from the provider
    final currentWallet = walletsAsync.valueOrNull?.firstWhere(
      (w) => w.id == wallet.id,
      orElse: () => wallet,
    ) ?? wallet;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(currentWallet.name, style: AppTextStyles.h3),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'update_balance') {
                _showUpdateBalanceDialog(context, ref, currentWallet);
              } else if (value == 'edit_wallet') {
                // Navigate to AddWalletScreen in edit mode
                // We need to pass the wallet object. 
                // Since AddWalletScreen is not a named route with extra param support in standard go_router setup usually (unless we add it),
                // we might need to push it directly or register a new route.
                // Let's assume we can push the widget directly for simplicity or use extra if registered.
                // Checking AppRouter... actually let's just push the widget to avoid route registration hassle for now, 
                // OR better, use the existing /add-wallet route but we need to pass extra.
                // Let's check AppRouter to see if /add-wallet accepts extra.
                // If not, I'll just push MaterialPageRoute for now to be safe and quick.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddWalletScreen(walletToEdit: currentWallet)),
                );
              } else if (value == 'delete_wallet') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Wallet?'),
                    content: Text('Are you sure you want to delete "${currentWallet.name}"? This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => context.pop(false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => context.pop(true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final repository = await ref.read(walletRepositoryProvider.future);
                  await repository.deleteWallet(currentWallet.id);
                  if (context.mounted) {
                    context.pop(); // Pop detail screen
                  }
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'update_balance',
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Update Balance'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'edit_wallet',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Edit Wallet'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete_wallet',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Wallet', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Wallet Header
            Center(
              child: Column(
                children: [
                  WalletIcon(
                    iconPath: currentWallet.iconPath,
                    size: 64,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.currentBalance,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currency.format(currentWallet.balance),
                    style: AppTextStyles.amountLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Transactions List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: transactionsAsync.when(
                data: (allTransactions) {
                  // Filter transactions for this wallet
                  final walletTransactions = allTransactions
                      .where((t) => t.walletId == (wallet.externalId ?? wallet.id.toString()))
                      .toList();
                  
                  return RecentTransactionsList(transactions: walletTransactions);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showUpdateBalanceDialog(BuildContext context, WidgetRef ref, Wallet wallet) {
    final controller = TextEditingController(text: wallet.balance.toStringAsFixed(0));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Balance', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'New Balance',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixText: '${ref.read(currencyProvider).symbol} ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newBalance = double.tryParse(controller.text);
              if (newBalance != null) {
                final updatedWallet = wallet..balance = newBalance;
                final repository = await ref.read(walletRepositoryProvider.future);
                await repository.updateWallet(updatedWallet);
                if (context.mounted) {
                  context.pop();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
