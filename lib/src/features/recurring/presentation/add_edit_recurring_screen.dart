import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';
import '../../recurring/data/recurring_repository.dart';
import '../../recurring/domain/recurring_transaction.dart';
import '../../../common_widgets/modern_wallet_selector.dart';

class AddEditRecurringScreen extends ConsumerStatefulWidget {
  final RecurringTransaction? transaction;

  const AddEditRecurringScreen({super.key, this.transaction});

  @override
  ConsumerState<AddEditRecurringScreen> createState() => _AddEditRecurringScreenState();
}

class _AddEditRecurringScreenState extends ConsumerState<AddEditRecurringScreen> {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Recurring' : 'New Recurring',
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _deleteRecurring,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input (Big)
              Center(
                child: Column(
                  children: [
                    Text('Amount', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    IntrinsicWidth(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.amountLarge.copyWith(color: AppColors.primary),
                        decoration: InputDecoration(
                          prefixText: 'Rp ',
                          prefixStyle: AppTextStyles.amountLarge.copyWith(color: AppColors.primary),
                          border: InputBorder.none,
                          hintText: '0',
                          hintStyle: AppTextStyles.amountLarge.copyWith(color: Colors.grey[300]),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter amount';
                          if (double.tryParse(val) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Name Input
              Text('Name', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Netflix Subscription',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 24),

              // Frequency & Date Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Frequency', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<RecurringFrequency>(
                              value: _frequency,
                              isExpanded: true,
                              items: RecurringFrequency.values.map((f) {
                                return DropdownMenuItem(
                                  value: f,
                                  child: Text(f.name.toUpperCase(), style: AppTextStyles.bodyLarge),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _frequency = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start Date', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(DateFormat('d MMM y').format(_startDate), style: AppTextStyles.bodyLarge),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Wallet Selector
              Text('Pay with Wallet', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              StreamBuilder<List<Wallet>>(
                stream: ref.watch(walletRepositoryProvider).value?.watchWallets() ?? const Stream.empty(),
                builder: (context, snapshot) {
                  final wallets = snapshot.data ?? [];
                  
                  if (_selectedWalletId == null && wallets.isNotEmpty && !isEditing) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        final firstWallet = wallets.first;
                        setState(() => _selectedWalletId = firstWallet.externalId ?? firstWallet.id.toString());
                      }
                    });
                  }

                  return ModernWalletSelector(
                    selectedWalletId: _selectedWalletId,
                    onWalletSelected: (val) {
                      setState(() => _selectedWalletId = val);
                    },
                  );
                },
              ),
              
              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveRecurring,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    isEditing ? 'Update Recurring' : 'Save Recurring',
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
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
    } else if (_selectedWalletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a wallet')),
      );
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
