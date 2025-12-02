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
  final TransactionType type;
  final Transaction? transactionToEdit;
  
  const AddTransactionScreen({super.key, required this.type, this.transactionToEdit});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class CategorySelectionItem {
  final Category category;
  final SubCategory? subCategory;

  CategorySelectionItem({required this.category, this.subCategory});

  String get name => subCategory?.name ?? category.name;
  String get id => (subCategory?.id ?? category.id).toString();
  String get iconPath => subCategory?.iconPath ?? category.iconPath;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategorySelectionItem &&
        other.category.id == category.id &&
        other.subCategory?.id == subCategory?.id;
  }

  @override
  int get hashCode => Object.hash(category.id, subCategory?.id);
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _titleController = TextEditingController();
  
  String? _selectedWalletId;
  CategorySelectionItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      final t = widget.transactionToEdit!;
      _amountController.text = t.amount.toString();
      _noteController.text = t.note ?? '';
      _titleController.text = t.title;
      _selectedWalletId = t.walletId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final isExpense = type == TransactionType.expense || type == TransactionType.system;
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
          widget.transactionToEdit != null 
            ? 'Edit Transaction'
            : 'Add Transaction',
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
            const SizedBox(height: 24),

            Text('Title', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title (e.g. Breakfast)',
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
            const SizedBox(height: 24),
            
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
                      final first = wallets.first;
                      _selectedWalletId = first.externalId ?? first.id.toString();
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
                        final id = wallet.externalId ?? wallet.id.toString();
                        return DropdownMenuItem(
                          value: id,
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
                // Flatten categories into selection items
                final List<CategorySelectionItem> items = [];
                for (var category in categories) {
                  items.add(CategorySelectionItem(category: category));
                  for (var sub in category.subCategories ?? []) {
                    items.add(CategorySelectionItem(category: category, subCategory: sub));
                  }
                }

                // Auto-select item if none selected
                if (_selectedItem == null) {
                   if (widget.transactionToEdit != null && items.isNotEmpty) {
                     try {
                        // Try to find exact match by Category ID AND Title (for subcategory)
                        _selectedItem = items.firstWhere((item) {
                          final catId = item.category.externalId ?? item.category.id.toString();
                          return catId == widget.transactionToEdit!.categoryId && 
                          (item.subCategory?.name == widget.transactionToEdit!.title || item.subCategory == null && item.category.name == widget.transactionToEdit!.title);
                        });
                     } catch (e) {
                        // Fallback to just matching category ID
                        try {
                           _selectedItem = items.firstWhere((item) {
                             final catId = item.category.externalId ?? item.category.id.toString();
                             return catId == widget.transactionToEdit!.categoryId && item.subCategory == null;
                           });
                        } catch (e2) {
                           if (items.isNotEmpty) _selectedItem = items.first;
                        }
                     }
                   } else if (items.isNotEmpty) {
                      _selectedItem = items.first;
                   }
                   
                   // Trigger rebuild to show selection
                   if (_selectedItem != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                           // Also pre-fill title if it's empty and we just selected a default
                           if (_titleController.text.isEmpty) {
                             _titleController.text = _selectedItem!.name;
                           }
                        });
                      });
                   }
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CategorySelectionItem>(
                      value: _selectedItem,
                      isExpanded: true,
                      hint: const Text("Select Category"),
                      items: items.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Row(
                            children: [
                              if (item.subCategory != null) const SizedBox(width: 24), // Indent subcategories
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: item.category.color.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIconData(item.iconPath),
                                  color: item.category.color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.name, 
                                style: item.subCategory != null 
                                  ? AppTextStyles.bodyMedium 
                                  : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = value;
                          if (value != null) {
                            _titleController.text = value.name;
                          }
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
                  if (_selectedItem == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category")));
                    return;
                  }

                  final title = _titleController.text.isNotEmpty ? _titleController.text : _selectedItem!.name;

                  // 2. Save Transaction
                  final transactionRepo = await ref.read(transactionRepositoryProvider.future);
                  final walletRepo = await ref.read(walletRepositoryProvider.future);

                  if (widget.transactionToEdit != null) {
                    // UPDATE EXISTING
                    final oldTransaction = widget.transactionToEdit!;
                    
                    // Revert old balance
                    final oldWallet = await walletRepo.getWallet(oldTransaction.walletId!);
                    if (oldWallet != null) {
                      if (oldTransaction.isExpense) {
                        oldWallet.balance += oldTransaction.amount;
                      } else {
                        oldWallet.balance -= oldTransaction.amount;
                      }
                      await walletRepo.addWallet(oldWallet);
                    }

                    // Update transaction object
                    oldTransaction
                      ..title = title
                      ..amount = amount
                      ..walletId = _selectedWalletId
                      ..categoryId = _selectedItem!.category.externalId ?? _selectedItem!.category.id.toString()
                      ..note = _noteController.text;
                      // Date kept same or updated? User didn't ask to edit date, so keep it.
                    
                    await transactionRepo.updateTransaction(oldTransaction);

                    // Apply new balance
                    final newWallet = await walletRepo.getWallet(_selectedWalletId!);
                    if (newWallet != null) {
                      if (type == TransactionType.expense) {
                        newWallet.balance -= amount;
                      } else {
                        newWallet.balance += amount;
                      }
                      await walletRepo.addWallet(newWallet);
                    }

                  } else {
                    // CREATE NEW
                    final newTransaction = Transaction()
                      ..title = title
                      ..date = DateTime.now()
                      ..amount = amount
                      ..type = type
                      ..walletId = _selectedWalletId
                      ..categoryId = _selectedItem!.category.externalId ?? _selectedItem!.category.id.toString()
                      ..note = _noteController.text;

                    await transactionRepo.addTransaction(newTransaction);

                    // Update Wallet Balance
                    final wallet = await walletRepo.getWallet(_selectedWalletId!);
                    if (wallet != null) {
                      if (type == TransactionType.expense) {
                        wallet.balance -= amount;
                      } else {
                        wallet.balance += amount;
                      }
                      await walletRepo.addWallet(wallet);
                    }
                  }
                  
                  // Invalidate wallet list to ensure UI updates immediately
                  ref.invalidate(walletListProvider);
                  
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
