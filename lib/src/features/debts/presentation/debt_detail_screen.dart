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
import '../../../localization/generated/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.debtDetails, style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {
              context.push('/debts/edit', extra: _debt);
            },
          ),
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
                    isBorrowing ? AppLocalizations.of(context)!.youOweName(_debt.personName) : AppLocalizations.of(context)!.nameOwesYou(_debt.personName),
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
                    AppLocalizations.of(context)!.totalAmount(currency.format(_debt.amount)),
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
                      Text(AppLocalizations.of(context)!.paidAmount(currency.format(_debt.paidAmount)), style: AppTextStyles.bodySmall),
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
                  _buildInfoRow(Icons.calendar_today, AppLocalizations.of(context)!.dueDateLabel, DateFormat('d MMM yyyy').format(_debt.dueDate)),
                  if (_debt.note != null && _debt.note!.isNotEmpty) ...[
                    const Divider(height: 24),
                    _buildInfoRow(Icons.note_outlined, AppLocalizations.of(context)!.note, _debt.note!),
                  ],
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.info_outline, 
                    AppLocalizations.of(context)!.statusLabel, 
                    _debt.isPaid ? AppLocalizations.of(context)!.paidStatus : (_debt.dueDate.isBefore(DateTime.now()) ? AppLocalizations.of(context)!.overdue : AppLocalizations.of(context)!.activeStatus),
                    valueColor: _debt.isPaid ? Colors.green : (_debt.dueDate.isBefore(DateTime.now()) ? Colors.red : Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // History Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(AppLocalizations.of(context)!.paymentHistory, style: AppTextStyles.h3),
            ),
            const SizedBox(height: 16),
            if (_debt.history.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(AppLocalizations.of(context)!.noPaymentsYet, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
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
                  return GestureDetector(
                    onTap: () => _showPaymentOptions(context, index, history),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('d MMM yyyy').format(history.date ?? DateTime.now()),
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (history.note != null && history.note!.isNotEmpty)
                                  Text(history.note!, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            currency.format(history.amount ?? 0),
                            style: AppTextStyles.bodyLarge.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.more_vert, color: Colors.grey, size: 18),
                        ],
                      ),
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
              label: Text(AppLocalizations.of(context)!.addPayment, style: const TextStyle(color: Colors.white)),
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
        title: Text(AppLocalizations.of(context)!.deleteDebt),
        content: Text(AppLocalizations.of(context)!.deleteDebtWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
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
              // Header with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.payment, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.addPayment, style: AppTextStyles.h2),
                ],
              ),
              const SizedBox(height: 20),
              
              // Percentage Shortcuts - Modern pills
              Row(
                children: [
                  for (final percent in [0.25, 0.5, 1.0])
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: percent == 1.0 ? 0 : 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              final remaining = _debt.remainingAmount;
                              final amount = remaining * percent;
                              amountController.text = amount.toStringAsFixed(0);
                              setModalState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  percent == 1.0 ? 'Full' : '${(percent * 100).toInt()}%',
                                  style: TextStyle(
                                    color: AppColors.primary, 
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Amount - Borderless filled
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.amount,
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixText: 'Rp ',
                    prefixStyle: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Wallet Selector - Modern horizontal cards
              Text(
                '${AppLocalizations.of(context)!.wallet} (${AppLocalizations.of(context)!.optional})',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                future: ref.read(walletRepositoryProvider.future).then((repo) => repo.getAllWallets()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox(height: 60);
                  final wallets = snapshot.data as List<Wallet>;
                  return SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // None option
                        GestureDetector(
                          onTap: () => setModalState(() => selectedWalletId = null),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: selectedWalletId == null 
                                  ? AppColors.primary.withOpacity(0.1) 
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: selectedWalletId == null 
                                  ? Border.all(color: AppColors.primary, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.block,
                                  color: selectedWalletId == null ? AppColors.primary : Colors.grey,
                                  size: 22,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'None',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: selectedWalletId == null ? FontWeight.w600 : FontWeight.normal,
                                    color: selectedWalletId == null ? AppColors.primary : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Wallet options
                        ...wallets.map((w) => GestureDetector(
                          onTap: () => setModalState(() => selectedWalletId = w.id.toString()),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: selectedWalletId == w.id.toString()
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: selectedWalletId == w.id.toString()
                                  ? Border.all(color: AppColors.primary, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: selectedWalletId == w.id.toString() ? AppColors.primary : Colors.grey,
                                  size: 22,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  w.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: selectedWalletId == w.id.toString() ? FontWeight.w600 : FontWeight.normal,
                                    color: selectedWalletId == w.id.toString() ? AppColors.primary : Colors.grey.shade700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Note - Borderless filled
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: noteController,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    labelText: '${AppLocalizations.of(context)!.note} (${AppLocalizations.of(context)!.optional})',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 52,
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
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.confirmPayment,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
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
      int? transactionId;
      
      // 1. Create Transaction first to get the ID
      if (walletId != null) {
        final walletRepo = await ref.read(walletRepositoryProvider.future);
        final transactionRepo = await ref.read(transactionRepositoryProvider.future);
        
        final wallet = await walletRepo.getWallet(walletId);
        if (wallet != null) {
          final isExpense = _debt.type == DebtType.borrowing;
          
          final transaction = Transaction.create(
            title: isExpense ? 'Paid debt to ${_debt.personName}' : 'Received payment from ${_debt.personName}',
            amount: amount,
            type: isExpense ? TransactionType.expense : TransactionType.income,
            categoryId: 'debt',
            walletId: wallet.externalId ?? wallet.id.toString(),
            note: note,
            date: DateTime.now(),
          );

          transactionId = await transactionRepo.addTransaction(transaction);
        }
      }

      // 2. Update Debt with history including transactionId
      _debt.paidAmount += amount;
      if (_debt.paidAmount >= _debt.amount) {
        _debt.status = DebtStatus.paid;
      }
      
      final newHistory = List<DebtHistory>.from(_debt.history);
      newHistory.add(DebtHistory(
        date: DateTime.now(),
        amount: amount,
        note: note.isEmpty ? 'Payment' : note,
        transactionId: transactionId,
      ));
      _debt.history = newHistory;
      
      await debtRepo.updateDebt(_debt);

      setState(() {});
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.paymentRecorded), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showPaymentOptions(BuildContext context, int index, DebtHistory history) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.paymentOptions,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              ref.read(currencyProvider).format(history.amount ?? 0),
              style: AppTextStyles.h2.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit, color: AppColors.primary),
              ),
              title: Text(AppLocalizations.of(context)!.editPayment),
              subtitle: const Text('Modify amount or note'),
              onTap: () {
                Navigator.pop(context);
                _editPayment(index, history);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              title: Text(AppLocalizations.of(context)!.deletePayment, style: const TextStyle(color: Colors.red)),
              subtitle: const Text('Remove this payment record'),
              onTap: () {
                Navigator.pop(context);
                _confirmDeletePayment(index, history);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _editPayment(int index, DebtHistory history) {
    final amountController = TextEditingController(text: history.amount?.toStringAsFixed(0) ?? '');
    final noteController = TextEditingController(text: history.note ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            Text(AppLocalizations.of(context)!.editPayment, style: AppTextStyles.h2),
            const SizedBox(height: 24),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.amount,
                prefixText: 'Rp ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.note,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final newAmount = double.tryParse(amountController.text);
                  if (newAmount == null || newAmount <= 0) return;

                  await _updatePayment(index, history, newAmount, noteController.text);
                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePayment(int index, DebtHistory history, double newAmount, String newNote) async {
    try {
      final debtRepo = ref.read(debtRepositoryProvider);
      final oldAmount = history.amount ?? 0;
      final amountDiff = newAmount - oldAmount;

      // Update history
      final newHistory = List<DebtHistory>.from(_debt.history);
      newHistory[index] = DebtHistory(
        date: history.date,
        amount: newAmount,
        note: newNote.isEmpty ? 'Payment' : newNote,
        transactionId: history.transactionId,
      );
      _debt.history = newHistory;

      // Update paid amount
      _debt.paidAmount += amountDiff;
      if (_debt.paidAmount >= _debt.amount) {
        _debt.status = DebtStatus.paid;
      } else if (_debt.status == DebtStatus.paid) {
        _debt.status = DebtStatus.active;
      }

      await debtRepo.updateDebt(_debt);

      // Update linked transaction if exists
      if (history.transactionId != null) {
        final transactionRepo = await ref.read(transactionRepositoryProvider.future);
        final transaction = await transactionRepo.getTransactionById(history.transactionId!);
        if (transaction != null) {
          transaction.amount = newAmount;
          transaction.note = newNote;
          await transactionRepo.updateTransaction(transaction);
        }
      }

      setState(() {});
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment updated'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _confirmDeletePayment(int index, DebtHistory history) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletePayment),
        content: Text(
          'This will remove the payment of ${ref.read(currencyProvider).format(history.amount ?? 0)}. '
          '${history.transactionId != null ? 'The linked transaction will also be deleted.' : ''}'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deletePayment(index, history);
    }
  }

  Future<void> _deletePayment(int index, DebtHistory history) async {
    try {
      final debtRepo = ref.read(debtRepositoryProvider);
      final amount = history.amount ?? 0;

      // Remove from history
      final newHistory = List<DebtHistory>.from(_debt.history);
      newHistory.removeAt(index);
      _debt.history = newHistory;

      // Update paid amount
      _debt.paidAmount -= amount;
      if (_debt.paidAmount < 0) _debt.paidAmount = 0;
      
      // Update status
      if (_debt.paidAmount < _debt.amount) {
        _debt.status = _debt.dueDate.isBefore(DateTime.now()) ? DebtStatus.overdue : DebtStatus.active;
      }

      await debtRepo.updateDebt(_debt);

      // Delete linked transaction if exists
      if (history.transactionId != null) {
        final transactionRepo = await ref.read(transactionRepositoryProvider.future);
        await transactionRepo.deleteTransaction(history.transactionId!);
      }

      setState(() {});
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment deleted'), backgroundColor: Colors.orange),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

