import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../wallets/data/wallet_repository.dart';
import '../../../wallets/domain/wallet.dart';
import '../../data/saving_repository.dart';
import '../../domain/saving_goal.dart';
import '../../domain/saving_log.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../transactions/domain/transaction.dart';

class DepositBottomSheet extends ConsumerStatefulWidget {
  final SavingGoal goal;
  final bool isDeposit; // true = Deposit (Wallet -> Saving), false = Withdraw (Saving -> Wallet)

  const DepositBottomSheet({super.key, required this.goal, required this.isDeposit});

  @override
  ConsumerState<DepositBottomSheet> createState() => _DepositBottomSheetState();
}

class _DepositBottomSheetState extends ConsumerState<DepositBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedWalletId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                widget.isDeposit ? 'Deposit to ${widget.goal.name}' : 'Withdraw from ${widget.goal.name}',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 24),
              
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
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter an amount';
                  final amount = double.tryParse(val);
                  if (amount == null || amount <= 0) return 'Invalid amount';
                  if (!widget.isDeposit && amount > widget.goal.currentAmount) {
                    return 'Insufficient savings balance';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Wallet Selector
              StreamBuilder<List<Wallet>>(
                stream: ref.watch(walletRepositoryProvider).value?.watchWallets() ?? const Stream.empty(),
                builder: (context, snapshot) {
                  final wallets = snapshot.data ?? [];
                  
                  if (_selectedWalletId == null && wallets.isNotEmpty) {
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
                      labelText: widget.isDeposit ? 'From Wallet' : 'To Wallet',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                    ),
                    items: wallets.map((w) {
                      final id = w.externalId ?? w.id.toString();
                      return DropdownMenuItem(
                        value: id,
                        child: Text('${w.name} (Rp ${w.balance.toStringAsFixed(0)})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedWalletId = val);
                    },
                    validator: (val) => val == null ? 'Please select a wallet' : null,
                  );
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDeposit ? AppColors.primary : Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    widget.isDeposit ? 'Confirm Deposit' : 'Confirm Withdraw',
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

  Future<void> _submitTransaction() async {
    if (_formKey.currentState!.validate() && _selectedWalletId != null) {
      final amount = double.parse(_amountController.text);
      final walletRepo = ref.read(walletRepositoryProvider).value!;
      final savingRepo = ref.read(savingRepositoryProvider);
      final transactionRepo = await ref.read(transactionRepositoryProvider.future);

      // 1. Get Wallet
      final wallet = await walletRepo.getWallet(_selectedWalletId!);
      if (wallet == null) return;

      // 2. Validate Wallet Balance for Deposit
      if (widget.isDeposit && wallet.balance < amount) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient wallet balance')),
          );
        }
        return;
      }

      // 3. Update Balances
      if (widget.isDeposit) {
        // Deposit: Wallet - Amount, Saving + Amount
        wallet.balance -= amount;
        widget.goal.currentAmount += amount;
      } else {
        // Withdraw: Wallet + Amount, Saving - Amount
        wallet.balance += amount;
        widget.goal.currentAmount -= amount;
      }

      // 4. Save Changes
      await walletRepo.updateWallet(wallet);
      await savingRepo.updateSavingGoal(widget.goal);

      // 5. Create Log
      final log = SavingLog(
        savingGoalId: widget.goal.id,
        amount: amount,
        type: widget.isDeposit ? SavingLogType.deposit : SavingLogType.withdraw,
        date: DateTime.now(),
      );
      await savingRepo.addLog(log);

      // 6. Create System Transaction
      final transaction = Transaction.create(
        title: widget.isDeposit ? 'Deposit to ${widget.goal.name}' : 'Withdraw from ${widget.goal.name}',
        amount: amount,
        type: TransactionType.system,
        categoryId: 'savings',
        walletId: _selectedWalletId!,
        note: 'Savings Transaction',
        date: DateTime.now(),
      );
      await transactionRepo.addTransaction(transaction);

      if (mounted) context.pop();
    }
  }
}
