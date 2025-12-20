import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../data/debt_repository.dart';
import '../domain/debt.dart';
import '../../wallets/presentation/wallet_provider.dart';
import '../../../common_widgets/modern_wallet_selector.dart';
import '../../../utils/currency_input_formatter.dart';

class AddDebtScreen extends ConsumerStatefulWidget {
  final Debt? debtToEdit;

  const AddDebtScreen({super.key, this.debtToEdit});

  @override
  ConsumerState<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends ConsumerState<AddDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  DebtType _type = DebtType.borrowing;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  String? _selectedWalletId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.debtToEdit != null) {
      final d = widget.debtToEdit!;
      _nameController.text = d.personName;
      _amountController.text = NumberFormat.decimalPattern('en_US').format(d.amount);
      _noteController.text = d.note ?? '';
      _type = d.type;
      _dueDate = d.dueDate;
      _selectedWalletId = d.walletId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletRepo = ref.watch(walletRepositoryProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.debtToEdit != null ? AppLocalizations.of(context)!.editDebt : AppLocalizations.of(context)!.addDebt, style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (widget.debtToEdit != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _type = DebtType.borrowing),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _type == DebtType.borrowing ? Colors.red[100] : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: _type == DebtType.borrowing ? Border.all(color: Colors.red) : null,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.iBorrowed,
                              style: TextStyle(
                                color: _type == DebtType.borrowing ? Colors.red[900] : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _type = DebtType.lending),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _type == DebtType.lending ? Colors.blue[100] : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: _type == DebtType.lending ? Border.all(color: Colors.blue) : null,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.iLent,
                              style: TextStyle(
                                color: _type == DebtType.lending ? Colors.blue[900] : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Person Name
              Text(AppLocalizations.of(context)!.personName, style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.whoHint,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 16),

              // Amount
              Text(AppLocalizations.of(context)!.amount, style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: '0',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Due Date
              Text(AppLocalizations.of(context)!.dueDateLabel, style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(DateFormat('d MMM yyyy').format(_dueDate)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Wallet (Required for Transaction)
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                   final walletsAsync = ref.watch(walletListProvider);
                   return walletsAsync.when(
                     data: (wallets) {
                       if (wallets.isNotEmpty && _selectedWalletId == null) {
                         // Auto-select first wallet
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                           if (mounted && _selectedWalletId == null) {
                               setState(() {
                                 _selectedWalletId = wallets.first.externalId ?? wallets.first.id.toString();
                               });
                           }
                         });
                       }
                       
                       return Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(AppLocalizations.of(context)!.wallet, style: AppTextStyles.bodySmall),
                           const SizedBox(height: 8),
                           ModernWalletSelector(
                              selectedWalletId: _selectedWalletId,
                              onWalletSelected: (val) => setState(() => _selectedWalletId = val),
                           ),
                         ],
                       );
                     },
                     loading: () => const LinearProgressIndicator(),
                     error: (err, _) => Text('${AppLocalizations.of(context)!.unknown}: $err'),
                   );
                },
              ),
              const SizedBox(height: 16),

              // Note
              Text(AppLocalizations.of(context)!.note, style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.addNoteHint,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDebt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.debtToEdit != null ? AppLocalizations.of(context)!.updateDebt : AppLocalizations.of(context)!.saveDebt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveDebt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = CurrencyInputFormatter.parse(_amountController.text);
      final debtRepo = ref.read(debtRepositoryProvider);
      
      if (widget.debtToEdit != null) {
        // UPDATE
        final debt = widget.debtToEdit!;
        debt.personName = _nameController.text;
        debt.amount = amount;
        debt.type = _type;
        debt.dueDate = _dueDate;
        debt.note = _noteController.text.isEmpty ? null : _noteController.text;
        debt.walletId = _selectedWalletId;
        
        await debtRepo.updateDebt(debt);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.debtUpdated)));
        }
      } else {
        // CREATE
        final debt = Debt(
          personName: _nameController.text,
          amount: amount,
          type: _type,
          dueDate: _dueDate,
          note: _noteController.text.isEmpty ? null : _noteController.text,
          walletId: _selectedWalletId,
        );

        // If wallet selected, create transaction
        if (_selectedWalletId != null) {
          final walletRepo = await ref.read(walletRepositoryProvider.future);
          final transactionRepo = await ref.read(transactionRepositoryProvider.future);
          
          final wallet = await walletRepo.getWallet(_selectedWalletId!);
          if (wallet != null) {
            // First add the debt to get an ID (if needed, though updateDebt handles it, explicit add is clearer or update works for new too)
            await debtRepo.addDebt(debt);

            // If I borrow, I get money (Income). If I lend, I lose money (Expense).
            final isIncome = _type == DebtType.borrowing;
            
            final transaction = Transaction.create(
              title: isIncome ? 'Borrowed from ${_nameController.text}' : 'Lent to ${_nameController.text}',
              amount: amount,
              type: isIncome ? TransactionType.income : TransactionType.expense, // Correctly categorize as Income/Expense
              categoryId: 'debt', 
              walletId: _selectedWalletId!,
              note: 'Debt created',
              date: DateTime.now(),
            );

            if (isIncome) {
              wallet.balance += amount;
            } else {
              wallet.balance -= amount;
            }

            await transactionRepo.addTransaction(transaction);
            await walletRepo.updateWallet(wallet);
            
            // Link transaction to debt AND UPDATE DEBT
            debt.transactionId = transaction.id;
            await debtRepo.updateDebt(debt); // Persist the link
          }
        } else {
            // If no wallet selected, just add the debt
            await debtRepo.addDebt(debt);
        }
        
        // If wallet was NOT selected, we already added the debt above.
        // But if wallet WAS selected, we updated the debt with transactionId.
        // Wait, we added debt BEFORE creating transaction.
        // So the updateDebt above is correct.
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.debtSaved)));
        }
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteDebt),
        content: Text(AppLocalizations.of(context)!.deleteDebtConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    
    if (confirm == true && widget.debtToEdit != null) {
      try {
        final debtRepo = ref.read(debtRepositoryProvider);
        await debtRepo.deleteDebt(widget.debtToEdit!.id);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.debtDeleted)));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
