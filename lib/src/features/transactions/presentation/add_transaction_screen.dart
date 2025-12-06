import 'package:flutter/material.dart';
import 'package:ollo/src/utils/icon_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/presentation/wallet_provider.dart';
import '../../wallets/domain/wallet.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../common_widgets/modern_wallet_selector.dart';

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
        other.subCategory?.id == subCategory?.id &&
        (other.subCategory == null) == (subCategory == null);
  }

  @override
  int get hashCode => Object.hash(category.id, subCategory?.id, subCategory == null);
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _titleController = TextEditingController();
  
  String? _selectedWalletId;
  String? _selectedDestinationWalletId;
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
      _selectedDestinationWalletId = t.destinationWalletId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final isExpense = type == TransactionType.expense || type == TransactionType.system;
    final isTransfer = type == TransactionType.transfer;
    final primaryColor = isExpense ? Colors.red[400]! : (isTransfer ? Colors.indigo : Colors.green[600]!);
    
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
                hintText: isTransfer ? 'Enter description' : 'Enter title (e.g. Breakfast)',
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
            walletsAsync.when(
              data: (wallets) {
                if (wallets.isEmpty) return const Text("No wallets found. Please create one.");
                
                // Validate selected wallet (Source)
                if (_selectedWalletId != null && !wallets.any((w) => (w.externalId ?? w.id.toString()) == _selectedWalletId)) {
                   _selectedWalletId = null; 
                }
                
                // Auto-select first wallet if none selected
                if (_selectedWalletId == null && wallets.isNotEmpty) {
                    final first = wallets.first;
                    _selectedWalletId = first.externalId ?? first.id.toString();
                }

                if (isTransfer) {
                   // Validate Destination Wallet
                   final availableWallets = wallets.where((w) => (w.externalId ?? w.id.toString()) != _selectedWalletId).toList();
                  
                   // Auto-select first available if none selected or if selected is same as source
                   if (_selectedDestinationWalletId == null || _selectedDestinationWalletId == _selectedWalletId) {
                      if (availableWallets.isNotEmpty) {
                        _selectedDestinationWalletId = availableWallets.first.externalId ?? availableWallets.first.id.toString();
                      } else {
                        _selectedDestinationWalletId = null;
                      }
                   } else if (!wallets.any((w) => (w.externalId ?? w.id.toString()) == _selectedDestinationWalletId)) {
                      _selectedDestinationWalletId = null;
                   }

                   return Row(
                     children: [
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('From', style: AppTextStyles.bodyMedium),
                             const SizedBox(height: 8),
                             ModernWalletSelector(
                               selectedWalletId: _selectedWalletId,
                               onWalletSelected: (val) {
                                 setState(() {
                                   _selectedWalletId = val;
                                   // Reset destination if it becomes same as source (though ModernWalletSelector might not show it immediately without re-filtering, but logic handles it on rebuild)
                                   if (_selectedDestinationWalletId == val) {
                                      _selectedDestinationWalletId = null; // Will auto-select next available on rebuild
                                   }
                                 });
                               },
                             ),
                           ],
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('To', style: AppTextStyles.bodyMedium),
                             const SizedBox(height: 8),
                             if (wallets.length < 2) 
                               const Padding(padding: EdgeInsets.only(top: 12), child: Text("Need 2+ wallets", style: TextStyle(color: Colors.red, fontSize: 12)))
                             else
                               ModernWalletSelector(
                                 selectedWalletId: _selectedDestinationWalletId,
                                 onWalletSelected: (val) {
                                   setState(() {
                                     _selectedDestinationWalletId = val;
                                   });
                                 },
                               ),
                           ],
                         ),
                       ),
                     ],
                   );
                }

                // Normal (Non-Transfer) Layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallet', style: AppTextStyles.bodyMedium),
                     const SizedBox(height: 8),
                    ModernWalletSelector(
                      selectedWalletId: _selectedWalletId,
                      onWalletSelected: (val) {
                        setState(() {
                          _selectedWalletId = val;
                        });
                      },
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading wallets: $err'),
            ),

            const SizedBox(height: 24),

            // Category Selection
            Text('Category', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            if (type == TransactionType.system || type == TransactionType.transfer)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: type == TransactionType.transfer ? Colors.indigo.withOpacity(0.2) : Colors.blue.withOpacity(0.2), // Default system color
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        type == TransactionType.transfer ? Icons.swap_horiz : Icons.settings, 
                        color: type == TransactionType.transfer ? Colors.indigo : Colors.blue, 
                        size: 20
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        type == TransactionType.transfer 
                          ? 'TRANSFER' 
                          : (widget.transactionToEdit?.categoryId?.toUpperCase() ?? 'SYSTEM'),
                        style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[700]),
                      ),
                    ),
                    const Icon(Icons.lock, color: Colors.grey, size: 20),
                  ],
                ),
              )
            else
              categoriesAsync.when(
                data: (categories) {
                  // Flatten categories into selection items
                  final List<CategorySelectionItem> items = [];
                  
                  // Add System Categories (Virtual)
                  if (type == TransactionType.expense) {
                    items.add(CategorySelectionItem(
                      category: Category(
                        externalId: 'bills',
                        name: 'Bills',
                        iconPath: 'receipt_long',
                        type: CategoryType.expense,
                        colorValue: Colors.orange.value,
                        subCategories: [],
                      )..id = -100, // Unique Virtual ID
                    ));
                    items.add(CategorySelectionItem(
                      category: Category(
                        externalId: 'wishlist',
                        name: 'Wishlist',
                        iconPath: 'favorite',
                        type: CategoryType.expense,
                        colorValue: Colors.pink.value,
                        subCategories: [],
                      )..id = -101, // Unique Virtual ID
                    ));
                    items.add(CategorySelectionItem(
                      category: Category(
                        externalId: 'debt',
                        name: 'Debt',
                        iconPath: 'handshake',
                        type: CategoryType.expense,
                        colorValue: Colors.purple.value,
                        subCategories: [],
                      )..id = -102, // Unique Virtual ID
                    ));
                  }

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
                                  decoration: BoxDecoration(
                                    color: item.category.color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    IconHelper.getIcon(item.subCategory?.iconPath ?? item.category.iconPath),
                                    color: item.category.color,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item.name,
                                  style: item.subCategory != null
                                      ? AppTextStyles.bodyMedium 
                                      : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
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
                  if (isTransfer && _selectedDestinationWalletId == null) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a destination wallet")));
                     return;
                  }
                  if (_selectedItem == null && type != TransactionType.system && type != TransactionType.transfer) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category")));
                    return;
                  }

                  final title = _titleController.text.isNotEmpty 
                      ? _titleController.text 
                      : (_selectedItem?.name ?? (type == TransactionType.transfer ? 'Transfer' : 'System Transaction'));

                  // 2. Save Transaction
                  final transactionRepo = await ref.read(transactionRepositoryProvider.future);
                  final walletRepo = await ref.read(walletRepositoryProvider.future);

                  if (widget.transactionToEdit != null) {
                    // UPDATE EXISTING
                    final oldTransaction = widget.transactionToEdit!;
                    
                    // Revert old balance
                    final oldWallet = await walletRepo.getWallet(oldTransaction.walletId!);
                    if (oldWallet != null) {
                      if (oldTransaction.type == TransactionType.expense) {
                        oldWallet.balance += oldTransaction.amount;
                      } else if (oldTransaction.type == TransactionType.income) {
                        oldWallet.balance -= oldTransaction.amount;
                      } else if (oldTransaction.type == TransactionType.transfer) {
                         // Revert transfer: Add back to source
                         oldWallet.balance += oldTransaction.amount;
                      }
                      await walletRepo.addWallet(oldWallet);
                    }
                    
                    // Revert old destination balance if transfer
                    if (oldTransaction.type == TransactionType.transfer && oldTransaction.destinationWalletId != null) {
                        final oldDestWallet = await walletRepo.getWallet(oldTransaction.destinationWalletId!);
                        if (oldDestWallet != null) {
                           oldDestWallet.balance -= oldTransaction.amount; // Remove what was added to dest
                           await walletRepo.addWallet(oldDestWallet);
                        }
                    }

                    // Update transaction object
                    oldTransaction
                      ..title = title
                      ..amount = amount
                      ..walletId = _selectedWalletId
                      ..destinationWalletId = isTransfer ? _selectedDestinationWalletId : null
                      ..categoryId = _selectedItem?.category.externalId ?? _selectedItem?.category.id.toString() ?? oldTransaction.categoryId
                      ..subCategoryId = _selectedItem?.subCategory?.id ?? oldTransaction.subCategoryId
                      ..subCategoryName = _selectedItem?.subCategory?.name ?? oldTransaction.subCategoryName
                      ..subCategoryIcon = _selectedItem?.subCategory?.iconPath ?? oldTransaction.subCategoryIcon
                      ..note = _noteController.text;
                      // Date kept same or updated? User didn't ask to edit date, so keep it.
                    
                    await transactionRepo.updateTransaction(oldTransaction);

                    // Apply new balance
                    final newWallet = await walletRepo.getWallet(_selectedWalletId!);
                    if (newWallet != null) {
                      if (type == TransactionType.expense) {
                        newWallet.balance -= amount;
                      } else if (type == TransactionType.income) {
                        newWallet.balance += amount;
                      } else if (type == TransactionType.transfer) {
                        newWallet.balance -= amount; // Deduct from source
                      }
                      await walletRepo.addWallet(newWallet);
                    }
                    
                    if (type == TransactionType.transfer && _selectedDestinationWalletId != null) {
                       final newDestWallet = await walletRepo.getWallet(_selectedDestinationWalletId!);
                       if (newDestWallet != null) {
                          newDestWallet.balance += amount; // Add to destination
                          await walletRepo.addWallet(newDestWallet);
                       }
                    }

                  } else {
                    // CREATE NEW
                    final newTransaction = Transaction()
                      ..title = title
                      ..date = DateTime.now()
                      ..amount = amount
                      ..type = type
                      ..walletId = _selectedWalletId
                      ..destinationWalletId = isTransfer ? _selectedDestinationWalletId : null
                      ..categoryId = _selectedItem?.category.externalId ?? _selectedItem?.category.id.toString()
                      ..subCategoryId = _selectedItem?.subCategory?.id
                      ..subCategoryName = _selectedItem?.subCategory?.name
                      ..subCategoryIcon = _selectedItem?.subCategory?.iconPath
                      ..note = _noteController.text;

                    await transactionRepo.addTransaction(newTransaction);

                    // Update Wallet Balance
                    final wallet = await walletRepo.getWallet(_selectedWalletId!);
                    if (wallet != null) {
                      if (type == TransactionType.expense) {
                        wallet.balance -= amount;
                      } else if (type == TransactionType.income) {
                         wallet.balance += amount;
                      } else if (type == TransactionType.transfer) {
                        wallet.balance -= amount; // Deduct from source
                      }
                      await walletRepo.addWallet(wallet);
                    }
                    
                    if (type == TransactionType.transfer && _selectedDestinationWalletId != null) {
                       final destWallet = await walletRepo.getWallet(_selectedDestinationWalletId!);
                       if (destWallet != null) {
                          destWallet.balance += amount; // Add to destination
                          await walletRepo.addWallet(destWallet);
                       }
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
}
