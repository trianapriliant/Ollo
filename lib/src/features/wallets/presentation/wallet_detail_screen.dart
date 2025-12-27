import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/modern_confirm_dialog.dart';
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
            icon: const Icon(Icons.more_vert, color: Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 50),
            onSelected: (value) async {
              if (value == 'update_balance') {
                _showUpdateBalanceDialog(context, ref, currentWallet);
              } else if (value == 'edit_wallet') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddWalletScreen(walletToEdit: currentWallet)),
                );
              } else if (value == 'delete_wallet') {
                final confirm = await showModernConfirmDialog(
                  context: context,
                  title: AppLocalizations.of(context)!.deleteWalletTitle,
                  message: AppLocalizations.of(context)!.deleteWalletConfirm(currentWallet.name),
                  confirmText: AppLocalizations.of(context)!.delete,
                  cancelText: AppLocalizations.of(context)!.cancel,
                  type: ConfirmDialogType.delete,
                );

                if (confirm == true) {
                  final repository = await ref.read(walletRepositoryProvider.future);
                  await repository.deleteWallet(currentWallet.id);
                  if (context.mounted) {
                    context.pop();
                  }
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'update_balance',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.account_balance_wallet, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.updateBalance, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'edit_wallet',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit, size: 18, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.editWallet, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete_wallet',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.delete, style: AppTextStyles.bodyMedium.copyWith(color: Colors.red)),
                  ],
                ),
              ),
            ],
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
    final formatter = NumberFormat('#,###', 'en_US');
    final controller = TextEditingController(text: formatter.format(wallet.balance.toInt()));
    final currency = ref.read(currencyProvider);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.account_balance_wallet, size: 32, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              
              // Title
              Text(
                AppLocalizations.of(context)!.updateBalance,
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 8),
              Text(
                wallet.name,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              
              // Amount Input
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [ThousandsSeparatorInputFormatter()],
                style: AppTextStyles.h2,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.newBalance,
                  prefixText: '${currency.symbol} ',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Remove commas before parsing
                        final cleanedText = controller.text.replaceAll(',', '');
                        final newBalance = double.tryParse(cleanedText);
                        if (newBalance != null) {
                          final oldBalance = wallet.balance;
                          final difference = newBalance - oldBalance;
                          
                          if (difference.abs() > 0.01) {
                            context.pop(); 
                            
                            final l10n = AppLocalizations.of(context)!;
                            
                            // Show confirmation/tracking dialog with modern style
                            final shouldRecord = await showDialog<bool>(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.sync_alt, size: 32, color: Colors.orange),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(l10n.balanceUpdateDetected, style: AppTextStyles.h3),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.recordAsTransactionDesc(currency.format(difference.abs())),
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                              child: Text(l10n.skip),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                              child: Text(l10n.record),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            
                            if (shouldRecord == true) {
                              final transactionRepo = await ref.read(transactionRepositoryProvider.future);
                              
                              final transaction = Transaction.create(
                                title: 'Balance Adjustment',
                                amount: difference.abs(),
                                type: difference > 0 ? TransactionType.income : TransactionType.expense,
                                date: DateTime.now(),
                                walletId: wallet.externalId ?? wallet.id.toString(),
                                note: 'Manual balance adjustment',
                                categoryId: 'system',
                                subCategoryId: 'adjustment',
                                subCategoryName: 'Adjustment',
                                subCategoryIcon: 'tune',
                              );
                              
                              await transactionRepo.addTransaction(transaction);
                              
                            } else {
                              final updatedWallet = wallet..balance = newBalance;
                              final repository = await ref.read(walletRepositoryProvider.future);
                              await repository.updateWallet(updatedWallet);
                            }
                            
                          } else {
                             if (context.mounted) context.pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Input formatter that adds thousand separators to numbers
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Parse and format with thousand separators
    final number = int.tryParse(digitsOnly) ?? 0;
    final formatted = _formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
