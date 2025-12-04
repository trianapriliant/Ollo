import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
        title: Text('Smart Notes', style: AppTextStyles.h2),
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
          
          final totalPlanned = activeNotes.fold(0.0, (sum, n) => sum + (n.amount ?? 0));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.teal.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Planned',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(totalPlanned),
                        style: AppTextStyles.h1.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${activeNotes.length} items to buy',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Active Items
                Text('Shopping List', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                if (activeNotes.isEmpty)
                  _buildEmptyState('No items yet', Icons.checklist),
                ...activeNotes.map((note) => _buildNoteItem(context, ref, note)),

                if (completedNotes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Completed', style: AppTextStyles.h3.copyWith(color: Colors.grey)),
                  const SizedBox(height: 12),
                  ...completedNotes.map((note) => _buildNoteItem(context, ref, note)),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/smart-notes/add'),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNoteItem(BuildContext context, WidgetRef ref, SmartNote note) {
    final isCompleted = note.isCompleted;
    
    return Dismissible(
      key: Key(note.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Item?'),
            content: const Text('Are you sure you want to delete this item?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(smartNoteRepositoryProvider).deleteNote(note.id);
      },
      child: InkWell(
        onTap: () => context.push('/smart-notes/edit', extra: note),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                value: isCompleted,
                activeColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (val) => _handleCheck(context, ref, note, val),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    if (note.amount != null || note.walletId != null)
                      const SizedBox(height: 4),
                    Row(
                      children: [
                        if (note.amount != null)
                          Text(
                            NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(note.amount),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? Colors.grey : Colors.teal,
                            ),
                          ),
                        if (note.amount != null && note.walletId != null)
                          Text(' • ', style: TextStyle(color: Colors.grey[400])),
                        if (note.walletId != null)
                          _buildWalletBadge(ref, note.walletId!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletBadge(WidgetRef ref, String walletId) {
    final walletsAsync = ref.watch(walletListProvider);
    return walletsAsync.when(
      data: (wallets) {
        final wallet = wallets.firstWhere(
          (w) => (w.externalId ?? w.id.toString()) == walletId,
          orElse: () => wallets.first, // Fallback
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_balance_wallet, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                wallet.name,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: Colors.grey[700]),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _handleCheck(BuildContext context, WidgetRef ref, SmartNote note, bool? value) async {
    if (value == null) return;

    if (value && !note.isCompleted && note.amount != null && note.amount! > 0 && note.walletId != null) {
      // Ask to create transaction
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Create Transaction?'),
          content: Text('Do you want to record "Rp ${NumberFormat.decimalPattern('id').format(note.amount)}" as an expense?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No, just mark done'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yes, record expense', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // Create Transaction
        final transaction = Transaction.create(
          title: 'Smart Note: ${note.title}',
          amount: note.amount!,
          type: TransactionType.expense,
          categoryId: note.categoryId ?? 'groceries', // Default or from note
          date: DateTime.now(),
          note: note.notes,
          walletId: note.walletId,
        );
        
        final repo = await ref.read(transactionRepositoryProvider.future);
        await repo.addTransaction(transaction);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction recorded!')),
        );
      }
    }

    await ref.read(smartNoteRepositoryProvider).toggleComplete(note.id, isCompleted: value);
  }
}
