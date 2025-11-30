import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../wallets/data/wallet_repository.dart';
import '../../../wallets/domain/wallet.dart';
import '../../data/recurring_repository.dart';
import '../../domain/recurring_transaction.dart';

class AddRecurringBottomSheet extends ConsumerStatefulWidget {
  final RecurringTransaction? transaction;

  const AddRecurringBottomSheet({super.key, this.transaction});

  @override
  ConsumerState<AddRecurringBottomSheet> createState() => _AddRecurringBottomSheetState();
}

class _AddRecurringBottomSheetState extends ConsumerState<AddRecurringBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  
  late RecurringFrequency _frequency;
  String? _selectedWalletId;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _nameController = TextEditingController(text: tx?.note ?? '');
    _amountController = TextEditingController(text: tx?.amount.toString() ?? '');
    _frequency = tx?.frequency ?? RecurringFrequency.monthly;
    _selectedWalletId = tx?.walletId;
    _startDate = tx?.startDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final walletsAsync = ref.watch(walletRepositoryProvider.select((repo) => repo.value?.watchWallets()));

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isEditing ? 'Edit Recurring' : 'Add Recurring', style: AppTextStyles.h2),
                  if (isEditing)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteRecurring,
                    ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Name Input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name (e.g. Netflix)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.label_outline),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),

              // Amount Input
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: 'Rp ',
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter an amount' : null,
              ),
              const SizedBox(height: 16),

              // Frequency Dropdown
              DropdownButtonFormField<RecurringFrequency>(
                value: _frequency,
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.repeat),
                ),
                items: RecurringFrequency.values.map((f) {
                  return DropdownMenuItem(
                    value: f,
                    child: Text(f.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _frequency = val);
                },
              ),
              const SizedBox(height: 16),

              // Wallet Selector
              StreamBuilder<List<Wallet>>(
                stream: ref.watch(walletRepositoryProvider).value?.watchWallets() ?? const Stream.empty(),
                builder: (context, snapshot) {
                  final wallets = snapshot.data ?? [];
                  
                  // Auto-select first wallet if none selected and not editing
                  if (_selectedWalletId == null && wallets.isNotEmpty && !isEditing) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        final firstWallet = wallets.first;
                        setState(() => _selectedWalletId = firstWallet.externalId ?? firstWallet.id.toString());
                      }
                    });
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedWalletId,
                    decoration: InputDecoration(
                      labelText: 'Pay with Wallet',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                    ),
                    items: wallets.map((w) {
                      final id = w.externalId ?? w.id.toString();
                      return DropdownMenuItem(
                        value: id,
                        child: Text(w.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedWalletId = val);
                    },
                    validator: (val) => val == null ? 'Please select a wallet' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Start Date Picker
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('d MMM y').format(_startDate)),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveRecurring,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isEditing ? 'Update Recurring' : 'Save Recurring',
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveRecurring() async {
    if (_formKey.currentState!.validate() && _selectedWalletId != null) {
      final amount = double.parse(_amountController.text);
      
      // Calculate next due date logic...
      DateTime nextDue = _startDate;
      final now = DateTime.now();
      
      // Only recalculate next due if creating new or if start date changed significantly
      // For simplicity, we'll recalculate to ensure consistency
      while (nextDue.isBefore(now)) {
        switch (_frequency) {
          case RecurringFrequency.daily:
            nextDue = nextDue.add(const Duration(days: 1));
            break;
          case RecurringFrequency.weekly:
            nextDue = nextDue.add(const Duration(days: 7));
            break;
          case RecurringFrequency.monthly:
            nextDue = DateTime(nextDue.year, nextDue.month + 1, nextDue.day);
            break;
          case RecurringFrequency.yearly:
            nextDue = DateTime(nextDue.year + 1, nextDue.month, nextDue.day);
            break;
        }
      }

      if (widget.transaction != null) {
        // Update existing
        final updatedTx = widget.transaction!;
        updatedTx.amount = amount;
        updatedTx.walletId = _selectedWalletId!;
        updatedTx.note = _nameController.text;
        updatedTx.frequency = _frequency;
        updatedTx.startDate = _startDate;
        updatedTx.nextDueDate = nextDue;
        
        await ref.read(recurringRepositoryProvider).updateRecurringTransaction(updatedTx);
      } else {
        // Create new
        final newTx = RecurringTransaction(
          amount: amount,
          categoryId: 'bills', 
          walletId: _selectedWalletId!,
          note: _nameController.text,
          frequency: _frequency,
          startDate: _startDate,
          nextDueDate: nextDue,
          isActive: true,
        );
        await ref.read(recurringRepositoryProvider).addRecurringTransaction(newTx);
      }
      
      if (mounted) context.pop();
    }
  }

  Future<void> _deleteRecurring() async {
    if (widget.transaction != null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Recurring?'),
          content: const Text('This will stop future auto-payments. Past transactions will remain.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(context, true), 
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await ref.read(recurringRepositoryProvider).deleteRecurringTransaction(widget.transaction!.id);
        if (mounted) context.pop();
      }
    }
  }
}
