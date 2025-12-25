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

class SmartNotesScreen extends ConsumerWidget {
  const SmartNotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(smartNoteListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.smartNotesTitle, style: AppTextStyles.h2),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: notesAsync.when(
        data: (notes) {
          final activeNotes = notes.where((n) => !n.isCompleted).toList();
          final completedNotes = notes.where((n) => n.isCompleted).toList();
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (activeNotes.isEmpty && completedNotes.isEmpty)
                _buildEmptyState(AppLocalizations.of(context)!.emptySmartNotesMessage, Icons.shopping_basket_outlined),
                
              if (activeNotes.isNotEmpty) ...[
                Text(AppLocalizations.of(context)!.activeTab, style: AppTextStyles.h3),
                const SizedBox(height: 12),
                ...activeNotes.map((note) => _SmartNoteCard(note: note)),
              ],

              if (completedNotes.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(AppLocalizations.of(context)!.historyTitle, style: AppTextStyles.h3.copyWith(color: Colors.grey)),
                const SizedBox(height: 12),
                ...completedNotes.map((note) => _SmartNoteCard(note: note)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.errorMessage(err.toString()))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'notes_fab',
        onPressed: () => context.push('/smart-notes/add'),
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(AppLocalizations.of(context)!.addSmartNote, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 100),
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _SmartNoteCard extends ConsumerStatefulWidget {
  final SmartNote note;

  const _SmartNoteCard({required this.note});

  @override
  ConsumerState<_SmartNoteCard> createState() => _SmartNoteCardState();
}

class _SmartNoteCardState extends ConsumerState<_SmartNoteCard> {
  late SmartNote _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }
  
  // Update local state when widget.note changes (e.g. from stream update)
  @override
  void didUpdateWidget(_SmartNoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.id != widget.note.id || oldWidget.note.items?.length != widget.note.items?.length) {
       _note = widget.note;
    }
  }

  double get _totalChecked {
    if (_note.items == null) return 0;
    return _note.items!
        .where((i) => i.isDone)
        .fold(0, (sum, i) => sum + (i.amount ?? 0));
  }
  
  double get _totalAmount {
     if (_note.items == null) return 0;
     return _note.items!.fold(0, (sum, i) => sum + (i.amount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _note.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.04),
             blurRadius: 16,
             offset: const Offset(0, 4),
           ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.grey[100] : Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_circle_outline : Icons.shopping_basket,
                    color: isCompleted ? Colors.grey : Colors.teal,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _note.title,
                        style: AppTextStyles.h3.copyWith(
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                       '${DateFormat('d MMM yyyy').format(_note.createdAt)}  •  ${_note.items?.length ?? 0} Items',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onSelected: (val) {
                    if (val == 'edit') {
                      context.push('/smart-notes/edit', extra: _note);
                    } else if (val == 'delete') {
                      _deleteNote();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context)!.edit)),
                    PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Items List
          if (_note.items != null && _note.items!.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _note.items!.length,
              separatorBuilder: (_,__) => Divider(height: 1, indent: 64, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                final item = _note.items![index];
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.teal,
                  enabled: !isCompleted,
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isDone ? TextDecoration.lineThrough : null,
                      color: item.isDone ? Colors.grey : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: item.amount != null
                    ? Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.amount), style: TextStyle(fontSize: 12, color: Colors.grey[600]))
                    : null,
                  value: item.isDone,
                  onChanged: (val) {
                    setState(() {
                      item.isDone = val ?? false;
                    });
                     // Save immediately
                    ref.read(smartNoteRepositoryProvider).updateNote(_note);
                  },
                );
              },
            )
          else 
            Padding(
               padding: const EdgeInsets.all(24),
               child: Text(AppLocalizations.of(context)!.noItemsInBundle, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            ),

          const Divider(height: 1),

          // Footer Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                if (_note.walletId != null)
                   _buildWalletInfo(ref, _note.walletId!),
                const Spacer(),
                if (!isCompleted)
                  ElevatedButton(
                    onPressed: _totalChecked > 0 ? _processTransaction : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      disabledBackgroundColor: Colors.teal.withOpacity(0.3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.payAmount(NumberFormat.decimalPattern('id').format(_totalChecked)),
                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  )
                else
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(AppLocalizations.of(context)!.paidAndCompleted, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _undoTransaction,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(AppLocalizations.of(context)!.undoPay, style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
              ],
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
        return Row(
          children: [
            Icon(Icons.account_balance_wallet, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(wallet.name, style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_,__) => const SizedBox.shrink(),
    );
  }

  Future<void> _deleteNote() async {
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.deleteSmartNoteTitle,
                  style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
                        ),
                        child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                          ref.read(smartNoteRepositoryProvider).deleteNote(_note.id);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          shadowColor: Colors.red.withOpacity(0.4),
                        ),
                        child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(fontWeight: FontWeight.w600)),
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

  Future<void> _processTransaction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.teal.shade400, Colors.teal.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.payment_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.confirmPayment, style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_totalChecked), style: AppTextStyles.h2.copyWith(color: Colors.teal, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.confirmPaymentMessage(NumberFormat.decimalPattern('id').format(_totalChecked)), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300))),
                      child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4, shadowColor: Colors.teal.withOpacity(0.4)),
                      child: Text(AppLocalizations.of(context)!.confirm, style: const TextStyle(fontWeight: FontWeight.w600)),
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
      final transaction = Transaction.create(
        title: 'Bundle: ${_note.title}',
        amount: _totalChecked,
        type: TransactionType.expense,
        categoryId: 'notes', 
        date: DateTime.now(),
        note: 'Items: ${_note.items!.where((i) => i.isDone).map((i) => i.name).join(', ')}',
        walletId: _note.walletId,
      );
      
      final repo = await ref.read(transactionRepositoryProvider.future);
      final tid = await repo.addTransaction(transaction);
      
      _note.isCompleted = true;
      _note.transactionId = tid;
      await ref.read(smartNoteRepositoryProvider).updateNote(_note);
      
      if (mounted) {
         setState(() {});
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.paymentSuccess)));
      }
    }
  }

  Future<void> _undoTransaction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.undo_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.undoPaymentTitle, style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.undoPaymentConfirm, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300))),
                      child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4, shadowColor: Colors.orange.withOpacity(0.4)),
                      child: Text(AppLocalizations.of(context)!.undoAndReopen, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && _note.transactionId != null) {
      try {
        final repo = await ref.read(transactionRepositoryProvider.future);
        await repo.deleteTransaction(_note.transactionId!);
      } catch (e) {
        // Transaction might already be deleted manually, proceed to open note.
      }
      
      _note.isCompleted = false;
      _note.transactionId = null;
      await ref.read(smartNoteRepositoryProvider).updateNote(_note);
      
      if (mounted) {
         setState(() {});
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.purchaseReopened)));
      }
    }
  }
}
