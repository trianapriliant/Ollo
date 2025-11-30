import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../categories/domain/category.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../../../wallets/data/wallet_repository.dart';
import '../../../wallets/presentation/wallet_provider.dart';
import '../../../categories/data/category_repository.dart';
import '../../data/transaction_repository.dart';
import '../../domain/transaction.dart';
import 'category_selector.dart';
import 'sub_category_selector.dart';
import 'num_pad.dart';

class AddTransactionBottomSheet extends ConsumerStatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  ConsumerState<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends ConsumerState<AddTransactionBottomSheet> {
  String _amountStr = '0';
  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  String? _selectedWalletId;
  String? _selectedDestinationWalletId; // For Transfer
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onNumberTap(String number) {
    setState(() {
      if (_amountStr == '0') {
        _amountStr = number;
      } else {
        if (number == '.' && _amountStr.contains('.')) return;
        if (_amountStr.length > 10) return;
        _amountStr += number;
      }
    });
  }

  void _onBackspaceTap() {
    setState(() {
      if (_amountStr.length > 1) {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      } else {
        _amountStr = '0';
      }
    });
  }

  Future<void> _onDoneTap() async {
    final amount = double.tryParse(_amountStr) ?? 0.0;
    
    if (amount <= 0) {
      _showError("Please enter a valid amount");
      return;
    }
    if (_selectedWalletId == null) {
      _showError("Please select a wallet");
      return;
    }

    if (_selectedType == TransactionType.transfer) {
      if (_selectedDestinationWalletId == null) {
        _showError("Please select a destination wallet");
        return;
      }
      if (_selectedWalletId == _selectedDestinationWalletId) {
        _showError("Source and destination wallets must be different");
        return;
      }
    } else {
      if (_selectedCategory == null) {
        _showError("Please select a category");
        return;
      }
    }

    // 1. Create Transaction
    final newTransaction = Transaction()
      ..title = _selectedType == TransactionType.transfer 
          ? 'Transfer' 
          : (_selectedSubCategory?.name ?? _selectedCategory!.name)
      ..date = _selectedDate
      ..amount = amount
      ..type = _selectedType
      ..walletId = _selectedWalletId
      ..destinationWalletId = _selectedDestinationWalletId
      ..categoryId = _selectedCategory?.externalId ?? _selectedCategory?.id.toString()
      ..note = _noteController.text;

    // 2. Save Transaction
    final transactionRepo = await ref.read(transactionRepositoryProvider.future);
    await transactionRepo.addTransaction(newTransaction);

    // 3. Update Wallet Balance
    final walletRepo = await ref.read(walletRepositoryProvider.future);
    
    // Source Wallet
    final sourceWallet = await walletRepo.getWallet(_selectedWalletId!);
    if (sourceWallet != null) {
      if (_selectedType == TransactionType.expense || _selectedType == TransactionType.transfer) {
        sourceWallet.balance -= amount;
      } else {
        sourceWallet.balance += amount;
      }
      await walletRepo.addWallet(sourceWallet);
    }

    // Destination Wallet (for Transfer)
    if (_selectedType == TransactionType.transfer && _selectedDestinationWalletId != null) {
      final destWallet = await walletRepo.getWallet(_selectedDestinationWalletId!);
      if (destWallet != null) {
        destWallet.balance += amount;
        await walletRepo.addWallet(destWallet);
      }
    }

    if (mounted) {
      context.pop();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = ref.watch(currencyProvider).symbol;
    final walletsAsync = ref.watch(walletListProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                    // Header: Type Switcher & Date
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Type Toggle
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                _buildTypeButton('Expense', TransactionType.expense),
                                _buildTypeButton('Income', TransactionType.income),
                                _buildTypeButton('Transfer', TransactionType.transfer),
                              ],
                            ),
                          ),
                          // Date Selector
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setState(() => _selectedDate = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('MMM dd').format(_selectedDate),
                                    style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Wallet Selector (From)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: walletsAsync.when(
                        data: (wallets) {
                          if (wallets.isEmpty) return const Text("No wallets");
                          
                              if (_selectedWalletId == null && wallets.isNotEmpty) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (mounted) {
                                    final firstWallet = wallets.first;
                                    setState(() => _selectedWalletId = firstWallet.externalId ?? firstWallet.id.toString());
                                  }
                                });
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_selectedType == TransactionType.transfer)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                                      child: Text("From", style: AppTextStyles.bodySmall),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedWalletId,
                                        isExpanded: true,
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        items: wallets.map((w) {
                                          final id = w.externalId ?? w.id.toString();
                                          return DropdownMenuItem(
                                            value: id,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.account_balance_wallet, size: 20, color: AppColors.primary),
                                                const SizedBox(width: 12),
                                                Text(w.name, style: AppTextStyles.bodyMedium),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _selectedWalletId = val;
                                            // If destination wallet is same as new source wallet, reset destination
                                            if (_selectedType == TransactionType.transfer && 
                                                _selectedDestinationWalletId == val) {
                                              _selectedDestinationWalletId = null;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            loading: () => const SizedBox(),
                            error: (_, __) => const SizedBox(),
                          ),
                        ),

                        // Destination Wallet (To) - Only for Transfer
                        if (_selectedType == TransactionType.transfer) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: walletsAsync.when(
                              data: (wallets) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                                      child: Text("To", style: AppTextStyles.bodySmall),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedDestinationWalletId,
                                          isExpanded: true,
                                          hint: const Text("Select Destination"),
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: wallets.where((w) {
                                            final id = w.externalId ?? w.id.toString();
                                            return id != _selectedWalletId;
                                          }).map((w) {
                                            final id = w.externalId ?? w.id.toString();
                                            return DropdownMenuItem(
                                              value: id,
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.account_balance_wallet, size: 20, color: Colors.green),
                                                  const SizedBox(width: 12),
                                                  Text(w.name, style: AppTextStyles.bodyMedium),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) => setState(() => _selectedDestinationWalletId = val),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),
                          ),
                        ],

                        // Category Selector (Hide for Transfer) - Moved Here for Stability
                        if (_selectedType != TransactionType.transfer) ...[
                          const SizedBox(height: 16),
                          Consumer(
                            builder: (context, ref, child) {
                              final categoriesAsync = ref.watch(categoryListProvider(
                                _selectedType == TransactionType.expense ? CategoryType.expense : CategoryType.income
                              ));
                              
                              return categoriesAsync.when(
                                data: (categories) {
                                  if (_selectedCategory == null && categories.isNotEmpty) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {
                                          _selectedCategory = categories.first;
                                        });
                                      }
                                    });
                                  }

                                  return CategorySelector(
                                    categories: categories,
                                    selectedCategory: _selectedCategory,
                                    onCategorySelected: (category) {
                                      setState(() {
                                        _selectedCategory = category;
                                        _selectedSubCategory = null;
                                      });
                                    },
                                  );
                                },
                                loading: () => const SizedBox(height: 90, child: Center(child: CircularProgressIndicator())),
                                error: (_, __) => const SizedBox(),
                              );
                            },
                          ),

                          if (_selectedCategory != null && (_selectedCategory!.subCategories?.isNotEmpty ?? false)) ...[
                            const SizedBox(height: 16),
                            SubCategorySelector(
                              subCategories: _selectedCategory!.subCategories ?? [],
                              selectedSubCategory: _selectedSubCategory,
                              onSubCategorySelected: (sub) => setState(() => _selectedSubCategory = sub),
                              color: _selectedCategory!.color,
                            ),
                          ],
                        ],

                        const SizedBox(height: 16),

                        // Amount Display
                        Text(
                          'Amount',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              currencySymbol,
                              style: AppTextStyles.h2.copyWith(color: Colors.grey, fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _amountStr,
                              style: AppTextStyles.h1.copyWith(fontSize: 48),
                            ),
                          ],
                        ),

                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ),
            
            // Fixed Bottom Section: Note + NumPad
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Note Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: 'Add a note...',
                        border: InputBorder.none,
                        icon: Icon(Icons.edit_note, color: Colors.grey),
                      ),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
                
                // NumPad
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 16),
                  child: NumPad(
                    onNumberTap: _onNumberTap,
                    onBackspaceTap: _onBackspaceTap,
                    onDoneTap: _onDoneTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }

  Widget _buildTypeButton(String label, TransactionType type) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = null;
          // Reset destination if switching away from transfer (optional, but good for cleanup)
          if (type != TransactionType.transfer) {
            _selectedDestinationWalletId = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
