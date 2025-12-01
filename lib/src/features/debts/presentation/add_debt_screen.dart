import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../data/debt_repository.dart';
import '../domain/debt.dart';

class AddDebtScreen extends ConsumerStatefulWidget {
  const AddDebtScreen({super.key});

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
        title: Text('Add Debt/Loan', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
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
                              'I Borrowed',
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
                              'I Lent',
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
              Text('Person Name', style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Who?',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Amount
              Text('Amount', style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
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
              Text('Due Date', style: AppTextStyles.bodySmall),
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

              // Wallet (Optional)
              Text('Wallet (Optional)', style: AppTextStyles.bodySmall),
              const SizedBox(height: 4),
              Text('Select a wallet to automatically record this transaction.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              if (walletRepo != null)
                FutureBuilder(
                  future: walletRepo.getAllWallets(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final wallets = snapshot.data!;
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedWalletId,
                          hint: const Text('Select Wallet'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String>(value: null, child: Text('None (Just record debt)')),
                            ...wallets.map((w) => DropdownMenuItem(
                              value: w.id.toString(),
                              child: Text(w.name),
                            )),
                          ],
                          onChanged: (val) => setState(() => _selectedWalletId = val),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),

              // Note
              Text('Note', style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Optional note...',
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
                    : const Text('Save Debt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      final amount = double.parse(_amountController.text);
      final debtRepo = ref.read(debtRepositoryProvider);
      
      final debt = Debt(
        personName: _nameController.text,
        amount: amount,
        type: _type,
        dueDate: _dueDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        walletId: _selectedWalletId,
      );

      await debtRepo.addDebt(debt);

      // If wallet selected, create transaction
      if (_selectedWalletId != null) {
        final walletRepo = await ref.read(walletRepositoryProvider.future);
        final transactionRepo = await ref.read(transactionRepositoryProvider.future);
        
        final wallet = await walletRepo.getWallet(_selectedWalletId!);
        if (wallet != null) {
          // If I borrow, I get money (Income). If I lend, I lose money (Expense).
          final isIncome = _type == DebtType.borrowing;
          
          final transaction = Transaction.create(
            title: isIncome ? 'Borrowed from ${_nameController.text}' : 'Lent to ${_nameController.text}',
            amount: amount,
            type: isIncome ? TransactionType.income : TransactionType.expense,
            categoryId: 'debt', // Ideally should be a real category ID
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
        }
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debt saved successfully')),
        );
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
}
