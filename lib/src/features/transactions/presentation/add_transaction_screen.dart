import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/presentation/wallet_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../settings/presentation/currency_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final bool isExpense;
  const AddTransactionScreen({super.key, required this.isExpense});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  String? _selectedWalletId;
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.isExpense;
    final primaryColor = isExpense ? Colors.red[400]! : Colors.green[600]!;
    
    final walletsAsync = ref.watch(walletListProvider);
    final categoriesAsync = ref.watch(categoryListProvider(isExpense ? CategoryType.expense : CategoryType.income));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isExpense ? 'Add Expense' : 'Add Income',
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.amountLarge.copyWith(color: primaryColor),
              decoration: InputDecoration(
                prefixText: '${ref.watch(currencyProvider).symbol} ',
                prefixStyle: AppTextStyles.amountLarge.copyWith(color: primaryColor),
                border: InputBorder.none,
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 32),
            
            // Wallet Selection
            Text('Wallet', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            walletsAsync.when(
              data: (wallets) {
                if (wallets.isEmpty) return const Text("No wallets found. Please create one.");
                
                // Auto-select first wallet if none selected
                if (_selectedWalletId == null && wallets.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedWalletId = wallets.first.id;
                    });
                  });
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedWalletId,
                      isExpanded: true,
                      hint: const Text("Select Wallet"),
                      items: wallets.map((wallet) {
                        return DropdownMenuItem(
                          value: wallet.id,
                          child: Row(
                            children: [
                              Icon(Icons.account_balance_wallet, color: AppColors.primary, size: 20),
                              const SizedBox(width: 12),
                              Text(wallet.name, style: AppTextStyles.bodyLarge),
                              const Spacer(),
                              Text('${ref.watch(currencyProvider).symbol} ${wallet.balance}', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWalletId = value;
                        });
                      },
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error loading wallets: $err'),
            ),

            const SizedBox(height: 24),

            // Category Selection
            Text('Category', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            categoriesAsync.when(
              data: (categories) {
                // Auto-select first category if none selected
                if (_selectedCategory == null && categories.isNotEmpty) {
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedCategory = categories.first;
                    });
                  });
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Category>(
                      value: _selectedCategory,
                      isExpanded: true,
                      hint: const Text("Select Category"),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: category.color.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  // Map string icon path to IconData (simplified for now)
                                  _getIconData(category.iconPath),
                                  color: category.color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(category.name, style: AppTextStyles.bodyLarge),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error loading categories: $err'),
            ),
            
            const SizedBox(height: 24),
            
            Text('Note', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Add a note...',
                hintStyle: AppTextStyles.bodyMedium,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(_amountController.text) ?? 0.0;
                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid amount")));
                    return;
                  }
                  if (_selectedWalletId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a wallet")));
                    return;
                  }
                  if (_selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category")));
                    return;
                  }

                  // 1. Create Transaction
                  final newTransaction = Transaction()
                    ..title = _selectedCategory!.name
                    ..date = DateTime.now()
                    ..amount = amount
                    ..isExpense = isExpense
                    ..walletId = _selectedWalletId
                    ..categoryId = _selectedCategory!.id
                    ..note = _noteController.text;

                  // 2. Save Transaction
                  final transactionRepo = await ref.read(transactionRepositoryProvider.future);
                  await transactionRepo.addTransaction(newTransaction);

                  // 3. Update Wallet Balance
                  final walletRepo = await ref.read(walletRepositoryProvider.future);
                  final wallet = await walletRepo.getWallet(_selectedWalletId!);
                  if (wallet != null) {
                    if (isExpense) {
                      wallet.balance -= amount;
                    } else {
                      wallet.balance += amount;
                    }
                    await walletRepo.addWallet(wallet); // Update wallet
                  }
                  
                  if (context.mounted) {
                    context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text('Save Transaction', style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconPath) {
    // Simple mapping for demo purposes
    switch (iconPath) {
      case 'fastfood': return Icons.fastfood;
      case 'directions_bus': return Icons.directions_bus;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'movie': return Icons.movie;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'receipt': return Icons.receipt;
      case 'attach_money': return Icons.attach_money;
      case 'store': return Icons.store;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'trending_up': return Icons.trending_up;
      default: return Icons.category;
    }
  }
}
