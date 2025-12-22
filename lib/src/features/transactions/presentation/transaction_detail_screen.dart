import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/modern_confirm_dialog.dart';
import '../../settings/presentation/currency_provider.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';
import '../../../utils/icon_helper.dart';
import '../../bills/data/bill_repository.dart';
import '../../wishlist/data/wishlist_repository.dart';
import '../../debts/data/debt_repository.dart';
import '../../categories/presentation/category_localization_helper.dart';

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
        title: Text(AppLocalizations.of(context)!.transactionDetail, style: AppTextStyles.h3),
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
                  _buildAmountSection(context, currencySymbol),
                  const SizedBox(height: 32),
                  _buildDetailItem(AppLocalizations.of(context)!.title, transaction.title),
                  _buildDivider(),
                  if (transaction.type != TransactionType.transfer) ...[
                    _buildDetailItem(AppLocalizations.of(context)!.category, _getCategoryName(context, categoryAsync, transaction.categoryId)),
                    _buildDivider(),
                  ],
                   _buildDetailItem(AppLocalizations.of(context)!.wallet, _getFormattedWalletName(walletsAsync)),
                  _buildDivider(),
                  _buildDetailItem(AppLocalizations.of(context)!.date, DateFormat('dd MMMM yyyy').format(transaction.date)),
                  _buildDivider(),
                  _buildDetailItem(AppLocalizations.of(context)!.time, DateFormat('HH:mm').format(transaction.date)),
                  _buildDivider(),
                  if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                    _buildDetailItem(AppLocalizations.of(context)!.note, transaction.note!),
                    _buildDivider(),
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

  Widget _buildAmountSection(BuildContext context, String currencySymbol) {
    final isExpense = transaction.type == TransactionType.expense;
    final isTransfer = transaction.type == TransactionType.transfer;
    
    Color color;
    IconData icon;
    String label;
    String prefix;

    if (isTransfer) {
      color = Colors.blue;
      icon = Icons.swap_horiz;
      label = AppLocalizations.of(context)!.transfer;
      prefix = '';
    } else if (isExpense || transaction.type == TransactionType.system) {
      color = Colors.red;
      icon = Icons.arrow_upward;
      label = transaction.type == TransactionType.system ? '${AppLocalizations.of(context)!.system} (Wishlist)' : AppLocalizations.of(context)!.expense;
      prefix = '-';
    } else {
      color = Colors.green;
      icon = Icons.arrow_downward;
      label = AppLocalizations.of(context)!.income;
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
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
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
                  final confirm = await showModernConfirmDialog(
                    context: context,
                    title: AppLocalizations.of(context)!.deleteTransaction,
                    message: AppLocalizations.of(context)!.deleteTransactionConfirm,
                    confirmText: AppLocalizations.of(context)!.delete,
                    cancelText: AppLocalizations.of(context)!.cancel,
                    type: ConfirmDialogType.delete,
                  );

                if (confirm == true) {
                  // Delete transaction (Repository handles balance reversal)
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
                          SnackBar(content: Text(AppLocalizations.of(context)!.billDataNotFound)),
                        );
                      }
                    }
                  } else if (transaction.title.toLowerCase().contains('wishlist')) {
                    // Try to find associated Wishlist
                    final wishlistRepo = ref.read(wishlistRepositoryProvider);
                    final wishlist = await wishlistRepo.getWishlistByTransactionId(transaction.id);
                    
                    if (context.mounted) {
                      if (wishlist != null) {
                        context.push('/wishlist/edit', extra: wishlist);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.wishlistDataNotFound)),
                        );
                      } 
                    }
                  } else if (transaction.title.toLowerCase().contains('borrowed') || transaction.title.toLowerCase().contains('lent')) {
                     // Try to find associated Debt
                     final debtRepo = ref.read(debtRepositoryProvider);
                     final debt = await debtRepo.getDebtByTransactionId(transaction.id);
                     
                     if (context.mounted) {
                       if (debt != null) {
                         context.push('/debts/edit', extra: debt);
                       } else {
                         // Fallback if not found (maybe created before we started linking)
                         context.push('/add-transaction', extra: transaction);
                       }
                     }
                  } else {
                     // Fallback for other system types
                     context.push('/add-transaction', extra: transaction); 
                  }
                } else if (transaction.type == TransactionType.reimbursement) {
                    // Reimbursements are edited via AddReimburseScreen, but currently we just allow basic edit or show message
                     // For now, let's treat them as normal transactions for editing (or redirect to reimburse add screen if we adapt it)
                     // But strictly speaking, we didn't make an EditReimburseScreen.
                     // Let's just go to add-transaction for now, as it can handle basic edits, OR show a message.
                     ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.editReimbursementNotSupported)),
                      );
                } else {
                  // Normal Transaction
                  context.push('/add-transaction', extra: transaction); 
                }
              },
              icon: const Icon(Icons.edit_outlined),
              label: Text(AppLocalizations.of(context)!.edit),
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
          
          // Mark as Completed Button (For Pending Reimbursement)
          if (transaction.type == TransactionType.reimbursement && transaction.status == TransactionStatus.pending) ...[
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () async {
                   final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.markCompleted),
                      content: Text(AppLocalizations.of(context)!.markCompletedConfirm),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)!.confirm, style: const TextStyle(color: Colors.green))),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final repo = await ref.read(transactionRepositoryProvider.future);
                    transaction.status = TransactionStatus.completed;
                    await repo.updateTransaction(transaction);
                    if (context.mounted) {
                      context.pop();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.markCompleted),
              ),
            ),
          ],
        ],
      ),
    );
  }



  String _getCategoryName(BuildContext context, AsyncValue<List<Category>> categoryAsync, String? categoryId) {
    final l10n = AppLocalizations.of(context)!;
    
    // Handle System Categories explicitly
    if (categoryId == 'notes' || categoryId == 'note') return l10n.smartNotesTitle;
    if (categoryId == 'bills' || categoryId == 'bill') return l10n.bills; 
    if (categoryId == 'wishlist') return l10n.wishlist;
    if (categoryId == 'debt' || categoryId == 'debts') return l10n.debts;
    if (categoryId == 'saving' || categoryId == 'savings') return l10n.sysCatSavings;

    if (transaction.type == TransactionType.reimbursement) {
      return l10n.sysCatReimburse;
    }
    if (transaction.type == TransactionType.system) {
      return l10n.system;
    }
    if (categoryId == null) return '-';
    
    return categoryAsync.when(
      data: (categories) {
        try {
          final category = categories.firstWhere(
            (c) => (c.externalId ?? c.id.toString()) == categoryId
          );
          
          final catName = CategoryLocalizationHelper.getLocalizedCategoryName(context, category);
          
          if (transaction.subCategoryId != null) {
             // Try to find object
             final sub = category.subCategories?.cast<SubCategory?>().firstWhere(
               (s) => s?.id == transaction.subCategoryId, 
               orElse: () => null
             );
             
             if (sub != null) {
                return '$catName - ${CategoryLocalizationHelper.getLocalizedSubCategoryName(context, sub)}';
             }

             // Fallback if object not found but ID exists (deleted/legacy)
             final dummySub = SubCategory(id: transaction.subCategoryId, name: transaction.subCategoryName);
             final subName = CategoryLocalizationHelper.getLocalizedSubCategoryName(context, dummySub);
             if (subName.isNotEmpty) { // If it found a localization key
                 return '$catName - $subName';
             }
          }
          
          // Fallback to snapshot name if strictly no ID match found
          if (transaction.subCategoryName != null) {
             return '$catName - ${transaction.subCategoryName}';
          }

          return catName;
        } catch (e) {
          // Category not found (deleted?)
          // Try snapshot
          if (transaction.subCategoryName != null) {
            return transaction.subCategoryName!;
          }
          return 'Unknown';
        }
      },
      loading: () => l10n.loading,
      error: (_, __) => l10n.error('Loading category'),
    );
  }


  String _getFormattedWalletName(AsyncValue<List<Wallet>> walletsAsync) {
    return walletsAsync.when(
      data: (wallets) {
        final walletName = _getWalletName((wallets), transaction.walletId);
        
        if (transaction.type == TransactionType.transfer && transaction.destinationWalletId != null) {
           final destName = _getWalletName((wallets), transaction.destinationWalletId);
           return '$walletName ➔ $destName';
        }
        
        return walletName;
      },
      loading: () => 'Loading...',
      error: (_, __) => 'Error',
    );
  }

  String _getWalletName(List<Wallet> wallets, String? walletId) {
    if (walletId == null) return '-';
    final wallet = wallets.firstWhere(
      (w) => w.id.toString() == walletId || w.externalId == walletId, 
      orElse: () => Wallet()..name = 'Unknown'
    );
    return wallet.name;
  }
}
