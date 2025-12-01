import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../data/debt_repository.dart';
import '../domain/debt.dart';

class DebtDetailScreen extends ConsumerStatefulWidget {
  final Debt debt;
  const DebtDetailScreen({super.key, required this.debt});

  @override
  ConsumerState<DebtDetailScreen> createState() => _DebtDetailScreenState();
}

class _DebtDetailScreenState extends ConsumerState<DebtDetailScreen> {
  late Debt _debt;

  @override
  void initState() {
    super.initState();
    _debt = widget.debt;
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    final isBorrowing = _debt.type == DebtType.borrowing;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Debt Details', style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (isBorrowing ? Colors.red : Colors.blue).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: (isBorrowing ? Colors.red : Colors.blue).withOpacity(0.1),
                    child: Icon(
                      isBorrowing ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isBorrowing ? Colors.red : Colors.blue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isBorrowing ? 'You owe ${_debt.personName}' : '${_debt.personName} owes you',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currency.format(_debt.remainingAmount),
                    style: AppTextStyles.h1.copyWith(
                      color: isBorrowing ? Colors.red : Colors.blue,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${currency.format(_debt.amount)}',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _debt.amount > 0 ? _debt.paidAmount / _debt.amount : 0,
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation<Color>(isBorrowing ? Colors.red : Colors.blue),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Paid: ${currency.format(_debt.paidAmount)}', style: AppTextStyles.bodySmall),
                      Text('${((_debt.paidAmount / _debt.amount) * 100).toStringAsFixed(0)}%', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today, 'Due Date', DateFormat('d MMM yyyy').format(_debt.dueDate)),
                  if (_debt.note != null && _debt.note!.isNotEmpty) ...[
                    const Divider(height: 24),
                    _buildInfoRow(Icons.note_outlined, 'Note', _debt.note!),
                  ],
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.info_outline, 
                    'Status', 
                    _debt.isPaid ? 'Paid' : (_debt.dueDate.isBefore(DateTime.now()) ? 'Overdue' : 'Active'),
                    valueColor: _debt.isPaid ? Colors.green : (_debt.dueDate.isBefore(DateTime.now()) ? Colors.red : Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // History Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Payment History', style: AppTextStyles.h3),
            ),
            const SizedBox(height: 16),
            if (_debt.history.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text('No payments yet', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _debt.history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final history = _debt.history[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('d MMM yyyy').format(history.date ?? DateTime.now()),
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (history.note != null)
                              Text(history.note!, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
                          ],
                        ),
                        Text(
                          currency.format(history.amount ?? 0),
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
      floatingActionButton: !_debt.isPaid
          ? FloatingActionButton.extended(
              onPressed: () => _showAddPaymentDialog(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Payment', style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Debt?'),
        content: const Text('This will remove the debt record. Wallet balances will NOT be reverted automatically.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(debtRepositoryProvider).deleteDebt(_debt.id);
      if (mounted) context.pop();
    }
  }

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String? selectedWalletId;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Payment', style: AppTextStyles.h2),
              const SizedBox(height: 24),
              
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Wallet Selector
              FutureBuilder(
                future: ref.read(walletRepositoryProvider.future).then((repo) => repo.getAllWallets()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  final wallets = snapshot.data as List<Wallet>;
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Wallet (Optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None (Just record)')),
                      ...wallets.map((w) => DropdownMenuItem(value: w.id.toString(), child: Text(w.name))),
                    ],
                    onChanged: (val) => setModalState(() => selectedWalletId = val),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(amountController.text);
                    if (amount == null || amount <= 0) return;

                    await _processPayment(amount, selectedWalletId, noteController.text);
                    if (mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Confirm Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment(double amount, String? walletId, String note) async {
    try {
      final debtRepo = ref.read(debtRepositoryProvider);
      
      // 1. Update Debt
      _debt.paidAmount += amount;
      if (_debt.paidAmount >= _debt.amount) {
        _debt.status = DebtStatus.paid;
      }
      
      // Add history
      final newHistory = List<DebtHistory>.from(_debt.history);
      newHistory.add(DebtHistory(
        date: DateTime.now(),
        amount: amount,
        note: note.isEmpty ? 'Payment' : note,
      ));
      _debt.history = newHistory;
      
      await debtRepo.updateDebt(_debt);

      // 2. Update Wallet & Create Transaction
      if (walletId != null) {
        final walletRepo = await ref.read(walletRepositoryProvider.future);
        final transactionRepo = await ref.read(transactionRepositoryProvider.future);
        
        final wallet = await walletRepo.getWallet(walletId);
        if (wallet != null) {
          // If I borrowed (Owe), paying back is Expense.
          // If I lent (Owed to me), receiving payment is Income.
          final isExpense = _debt.type == DebtType.borrowing;
          
          final transaction = Transaction.create(
            title: isExpense ? 'Paid debt to ${_debt.personName}' : 'Received payment from ${_debt.personName}',
            amount: amount,
            type: isExpense ? TransactionType.expense : TransactionType.income,
            categoryId: 'debt',
            walletId: walletId,
            note: note,
            date: DateTime.now(),
          );

          if (isExpense) {
            wallet.balance -= amount;
          } else {
            wallet.balance += amount;
          }

          await transactionRepo.addTransaction(transaction);
          await walletRepo.updateWallet(wallet);
        }
      }

      setState(() {}); // Refresh UI
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment recorded successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
