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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 24,
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
              // Header with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (widget.isDeposit ? AppColors.primary : Colors.red).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isDeposit ? Icons.savings : Icons.money_off,
                      color: widget.isDeposit ? AppColors.primary : Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isDeposit ? 'Deposit' : 'Withdraw',
                          style: AppTextStyles.h2,
                        ),
                        Text(
                          widget.goal.name,
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Amount Input - Borderless filled
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixText: 'Rp ',
                    prefixStyle: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    border: InputBorder.none,
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
              ),
              const SizedBox(height: 20),

              // Wallet Selector - Modern horizontal cards
              Text(
                widget.isDeposit ? 'From Wallet' : 'To Wallet',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 8),
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

                  // Get selected wallet for percentage calculations
                  final selectedWallet = wallets.where((w) {
                    final id = w.externalId ?? w.id.toString();
                    return id == _selectedWalletId;
                  }).firstOrNull;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: wallets.length,
                          itemBuilder: (context, index) {
                            final w = wallets[index];
                            final id = w.externalId ?? w.id.toString();
                            final isSelected = _selectedWalletId == id;
                            
                            return GestureDetector(
                              onTap: () => setState(() => _selectedWalletId = id),
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? AppColors.primary.withOpacity(0.1) 
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                  border: isSelected 
                                      ? Border.all(color: AppColors.primary, width: 2)
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: isSelected ? AppColors.primary : Colors.grey,
                                      size: 22,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      w.name,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        color: isSelected ? AppColors.primary : Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Rp ${w.balance.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isSelected ? AppColors.primary : Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Percentage shortcuts (% of target amount) - Deposit only
                      if (widget.isDeposit && widget.goal.targetAmount > 0) ...[
                        const SizedBox(height: 16),
                        Text(
                          '% of target (Rp ${widget.goal.targetAmount.toStringAsFixed(0)})',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            for (final pct in [5, 10, 25, 50])
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    final amount = (widget.goal.targetAmount * pct / 100).round();
                                    _amountController.text = amount.toString();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$pct%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDeposit ? AppColors.primary : Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.isDeposit ? 'Confirm Deposit' : 'Confirm Withdraw',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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

      // 5. Create System Transaction FIRST (to get ID)
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

      // 6. Create Log with transactionId for cascade delete
      final log = SavingLog(
        savingGoalId: widget.goal.id,
        amount: amount,
        type: widget.isDeposit ? SavingLogType.deposit : SavingLogType.withdraw,
        date: DateTime.now(),
        transactionId: transaction.id, // Link to transaction
      );
      await savingRepo.addLog(log);

      if (mounted) context.pop();
    }
  }
}
