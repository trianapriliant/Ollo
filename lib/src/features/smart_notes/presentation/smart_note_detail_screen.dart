import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/presentation/wallet_provider.dart';
import '../data/smart_note_repository.dart';
import '../domain/smart_note.dart';

class SmartNoteDetailScreen extends ConsumerStatefulWidget {
  final SmartNote note;

  const SmartNoteDetailScreen({super.key, required this.note});

  @override
  ConsumerState<SmartNoteDetailScreen> createState() => _SmartNoteDetailScreenState();
}

class _SmartNoteDetailScreenState extends ConsumerState<SmartNoteDetailScreen> {
  late SmartNote _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  double get _totalChecked {
    if (_note.items == null) return 0;
    return _note.items!
        .where((i) => i.isDone)
        .fold(0, (sum, i) => sum + (i.amount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(_note.title, style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
               context.push('/smart-notes/edit', extra: _note);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header / Wallet Info
          if (_note.walletId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildWalletInfo(ref, _note.walletId!),
            ),
          
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _note.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = _note.items![index];
                return CheckboxListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isDone ? TextDecoration.lineThrough : null,
                      color: item.isDone ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: item.amount != null
                      ? Text(
                          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.amount),
                          style: TextStyle(
                            color: item.isDone ? Colors.grey : Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                  value: item.isDone,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                       // We need to mutate the actual list in the object
                       // Since items is a list of objects, modifying the object works, 
                       // but for Riverpod/Isar we need to save eventually.
                       // For local state during screen life, this is fine.
                       item.isDone = val ?? false;
                    });
                    _saveProgress();
                  },
                  secondary: Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Colors.grey[100],
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Icon(
                       Icons.shopping_bag_outlined, 
                       color: item.isDone ? Colors.grey : Colors.teal
                     ),
                  ),
                );
              },
            ),
          ),
          
          // Bottom Action
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(AppLocalizations.of(context)!.checkedTotal, style: const TextStyle(color: Colors.grey)),
                       Text(
                         NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_totalChecked),
                         style: AppTextStyles.h2.copyWith(color: Colors.teal),
                       ),
                     ],
                   ),
                   const SizedBox(height: 16),
                   SizedBox(
                     width: double.infinity,
                     height: 56,
                     child: ElevatedButton(
                       onPressed: _note.isCompleted ? null : _processTransaction,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.teal,
                         disabledBackgroundColor: Colors.grey[300],
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       ),
                       child: Text(
                         _note.isCompleted ? AppLocalizations.of(context)!.completed : AppLocalizations.of(context)!.payAndFinish,
                         style: AppTextStyles.bodyLarge.copyWith(
                           color: Colors.white, 
                           fontWeight: FontWeight.bold
                         ),
                       ),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletInfo(WidgetRef ref, String walletId) {
    final walletsAsync = ref.watch(walletListProvider);
    return walletsAsync.when(
      data: (wallets) {
        final wallet = wallets.firstWhere(
           (w) => (w.externalId ?? w.id.toString()) == walletId,
           orElse: () => wallets.first
        );
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.teal),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.payingWith, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(wallet.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_,__) => const SizedBox.shrink(),
    );
  }

  Future<void> _saveProgress() async {
    // Save checkpoint so if user leaves and comes back, checkboxes are remembered
    await ref.read(smartNoteRepositoryProvider).updateNote(_note);
  }

  Future<void> _processTransaction() async {
    if (_totalChecked == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noItemsChecked)),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment Icon with gradient background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.payment_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                AppLocalizations.of(context)!.confirmPayment,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Amount Display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_totalChecked),
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                AppLocalizations.of(context)!.confirmPaymentMessage(NumberFormat.decimalPattern('id').format(_totalChecked)),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.teal.withOpacity(0.4),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      // Create Transaction
      final transaction = Transaction.create(
        title: 'Bundle: ${_note.title}',
        amount: _totalChecked,
        type: TransactionType.expense,
        categoryId: 'notes', 
        date: DateTime.now(),
        note: 'Items: ${_getCheckedItemNames()}',
        walletId: _note.walletId,
      );
      
      final repo = await ref.read(transactionRepositoryProvider.future);
      final tid = await repo.addTransaction(transaction);
      
      // Update Note
      _note.isCompleted = true;
      _note.transactionId = tid;
      await ref.read(smartNoteRepositoryProvider).updateNote(_note);
      
      if (mounted) {
        setState(() {}); // refresh UI
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.smartNoteTransactionRecorded)),
        );
        context.pop(); // Go back to list
      }
    }
  }
  
  String _getCheckedItemNames() {
    return _note.items!
       .where((i) => i.isDone)
       .map((i) => i.name)
       .join(', ');
  }
}
