import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:ollo/src/utils/icon_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../utils/currency_input_formatter.dart';

import 'category_selection_item.dart';
import 'widgets/transaction_amount_input.dart';
import 'widgets/transaction_category_selector.dart';
import 'widgets/transaction_note_input.dart';
import 'widgets/transaction_wallet_selector.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionType type;
  final Transaction? transactionToEdit;
  final double? initialTransferFee; // For Quick Record voice transfer

  const AddTransactionScreen({super.key, required this.type, this.transactionToEdit, this.initialTransferFee});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _titleController = TextEditingController();
  final _feeController = TextEditingController(); // New Fee Controller

  String? _selectedWalletId;
  String? _selectedDestinationWalletId;
  CategorySelectionItem? _selectedItem;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      final t = widget.transactionToEdit!;
      _amountController.text = NumberFormat.decimalPattern('en_US').format(t.amount);
      _noteController.text = t.note ?? '';
      _titleController.text = t.title;
      _selectedWalletId = t.walletId;
      _selectedDestinationWalletId = t.destinationWalletId;
    }
    
    // Pre-fill transfer fee from Quick Record voice input
    if (widget.initialTransferFee != null && widget.initialTransferFee! > 0) {
      _feeController.text = NumberFormat.decimalPattern('en_US').format(widget.initialTransferFee);
    } 

    // Logic to Auto-Select 'Cash' if no wallet is selected yet 
    // (Works for new transactions AND drafts/voice results that missed a wallet)
    if (_selectedWalletId == null) {
      final walletsVal = ref.read(walletListProvider);
      if (walletsVal.hasValue) {
        final wallets = walletsVal.valueOrNull ?? [];
        if (wallets.isNotEmpty) {
           final defaultWallet = wallets.firstWhere(
             (w) => w.name.toLowerCase() == 'cash',
             orElse: () => wallets.first,
           );
           _selectedWalletId = defaultWallet.externalId ?? defaultWallet.id.toString();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final isExpense = type == TransactionType.expense || type == TransactionType.system;
    final isTransfer = type == TransactionType.transfer;
    final primaryColor = isExpense ? Colors.red[400]! : (isTransfer ? Colors.indigo : Colors.green[600]!);

    final categoriesAsync = ref.watch(categoryListProvider(isExpense ? CategoryType.expense : CategoryType.income));

    // Listen for wallet data if not yet selected
    ref.listen<AsyncValue<List<Wallet>>>(walletListProvider, (previous, next) {
      if (_selectedWalletId == null && widget.transactionToEdit == null) {
        next.whenData((wallets) {
          if (wallets.isNotEmpty) {
             final defaultWallet = wallets.firstWhere(
               (w) => w.name.toLowerCase() == 'cash',
               orElse: () => wallets.first,
             );
             setState(() {
               _selectedWalletId = defaultWallet.externalId ?? defaultWallet.id.toString();
             });
          }
        });
      }
    });

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
          widget.transactionToEdit != null && widget.transactionToEdit!.id != Isar.autoIncrement
              ? AppLocalizations.of(context)!.editTransaction
              : AppLocalizations.of(context)!.addTransaction,
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Reduced from 24
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            // 1. Amount Input
            TransactionAmountInput(
              controller: _amountController,
              currencySymbol: ref.watch(currencyProvider).symbol,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 16),

            // 2. Title Input
            Text(AppLocalizations.of(context)!.titleLabel, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: isTransfer ? AppLocalizations.of(context)!.enterDescriptionHint : AppLocalizations.of(context)!.enterTitleHint,
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
            const SizedBox(height: 16),

            // 3. Wallet Selection
            TransactionWalletSelector(
              selectedWalletId: _selectedWalletId,
              selectedDestinationWalletId: _selectedDestinationWalletId,
              isTransfer: isTransfer,
              onWalletChanged: (val) {
                setState(() {
                  _selectedWalletId = val;
                  if (_selectedDestinationWalletId == val) {
                    _selectedDestinationWalletId = null;
                  }
                });
              },
              onDestinationWalletChanged: (val) {
                setState(() {
                  _selectedDestinationWalletId = val;
                });
              },
            ),

            const SizedBox(height: 16),

            // 3b. Transfer Fee (Only if Transfer)
            if (isTransfer) ...[ 
               TransactionAmountInput(
                  controller: _feeController,
                  currencySymbol: ref.watch(currencyProvider).symbol,
                  primaryColor: Colors.orange, // Distinct color for fee
                  title: AppLocalizations.of(context)!.transferFee,
                  showSign: false, 
               ),
               const SizedBox(height: 16),
            ],

            // 4. Category Selection
            categoriesAsync.when(
              data: (categories) {
                // Flatten categories into selection items (Move this logic to provider/controller later?)
                // For now, keep data preparation here but layout in widget.
                final List<CategorySelectionItem> items = [];

                if (type == TransactionType.expense) {
                  items.add(CategorySelectionItem(
                    category: Category(
                      externalId: 'bills',
                      name: AppLocalizations.of(context)!.bills,
                      iconPath: 'receipt_long',
                      type: CategoryType.expense,
                      colorValue: Colors.orange.value,
                      subCategories: [],
                    )..id = -100,
                  ));
                  items.add(CategorySelectionItem(
                    category: Category(
                      externalId: 'wishlist',
                      name: AppLocalizations.of(context)!.wishlist,
                      iconPath: 'favorite',
                      type: CategoryType.expense,
                      colorValue: Colors.pink.value,
                      subCategories: [],
                    )..id = -101,
                  ));
                  items.add(CategorySelectionItem(
                    category: Category(
                      externalId: 'debt',
                      name: AppLocalizations.of(context)!.debts,
                      iconPath: 'handshake',
                      type: CategoryType.expense,
                      colorValue: Colors.purple.value,
                      subCategories: [],
                    )..id = -102,
                  ));
                }

                for (var category in categories) {
                  items.add(CategorySelectionItem(category: category));
                  for (var sub in category.subCategories ?? []) {
                    items.add(CategorySelectionItem(category: category, subCategory: sub));
                  }
                }

                if (_selectedItem == null && widget.transactionToEdit != null && items.isNotEmpty) {
                    try {
                       _selectedItem = items.firstWhere((item) {
                         final catId = item.category.externalId ?? item.category.id.toString();
                         if (catId != widget.transactionToEdit!.categoryId) return false;
                         
                         if (widget.transactionToEdit!.subCategoryName != null) {
                             return item.subCategory?.name == widget.transactionToEdit!.subCategoryName;
                         } else {
                             return item.subCategory == null;
                         }
                       });
                    } catch (e) {
                       // Fallback: Just try to match Main Category if Sub match fails
                       try {
                          _selectedItem = items.firstWhere((item) {
                            final catId = item.category.externalId ?? item.category.id.toString();
                            return catId == widget.transactionToEdit!.categoryId && item.subCategory == null;
                          });
                       } catch (e2) {
                          // ignore
                       }
                    }
                    if (_selectedItem != null && _titleController.text.isEmpty) {
                       WidgetsBinding.instance.addPostFrameCallback((_) {
                           _titleController.text = _selectedItem!.name;
                       });
                    }
                }

                return Column(
                  children: [
                    if (widget.transactionToEdit?.categoryId == 'system')
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock, color: Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.systemCategoryTitle,
                                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    _selectedItem?.name ?? 'System',
                                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      TransactionCategorySelector(
                        type: type,
                        selectedItem: _selectedItem,
                        transactionToEdit: widget.transactionToEdit,
                        items: items,
                        onChanged: (value) {
                          setState(() {
                            _selectedItem = value;
                            if (value != null && _titleController.text.isEmpty) {
                              _titleController.text = value.name;
                            }
                          });
                        },
                      ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error loading categories: $err'),
            ),

            const SizedBox(height: 16), // Reduced from 24

            // 5. Note Input
            TransactionNoteInput(controller: _noteController),
            
            const SizedBox(height: 16), // Bottom padding for scroll
                  ],
                ),
              ),
            ),
            
            // 6. Save Button - pinned at bottom
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () async {
                  setState(() { _isSaving = true; });
                  try {
                    final amount = CurrencyInputFormatter.parse(_amountController.text);
                    if (amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.enterValidAmount)));
                      setState(() { _isSaving = false; });
                      return;
                    }
                    if (_selectedWalletId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.selectWalletError)));
                      setState(() { _isSaving = false; });
                      return;
                    }
                    if (isTransfer && _selectedDestinationWalletId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.selectDestinationWalletError)));
                      setState(() { _isSaving = false; });
                      return;
                    }
                    if (_selectedItem == null &&
                        type != TransactionType.system &&
                        type != TransactionType.transfer &&
                        !(widget.transactionToEdit != null &&
                            ['debt', 'debts', 'saving', 'savings'].contains(widget.transactionToEdit!.categoryId))) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.selectCategoryError)));
                      setState(() { _isSaving = false; });
                      return;
                    }

                    final title = _titleController.text.isNotEmpty
                        ? _titleController.text
                        : (_selectedItem?.name ?? (type == TransactionType.transfer ? AppLocalizations.of(context)!.transferTransaction : 'System Transaction'));

                    await _saveTransaction(amount, title, isTransfer);
                  } finally {
                    if (mounted) setState(() { _isSaving = false; });
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
                child: _isSaving 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(AppLocalizations.of(context)!.saveTransaction, style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransaction(double amount, String title, bool isTransfer) async {
      final transactionRepo = await ref.read(transactionRepositoryProvider.future);
      final walletRepo = await ref.read(walletRepositoryProvider.future);
      
      final bool isEditing = widget.transactionToEdit != null && widget.transactionToEdit!.id != Isar.autoIncrement;

      if (isEditing) {
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
             oldWallet.balance += oldTransaction.amount;
          }
          await walletRepo.addWallet(oldWallet);
        }

        if (oldTransaction.type == TransactionType.transfer && oldTransaction.destinationWalletId != null) {
            final oldDestWallet = await walletRepo.getWallet(oldTransaction.destinationWalletId!);
            if (oldDestWallet != null) {
               oldDestWallet.balance -= oldTransaction.amount;
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

        await transactionRepo.updateTransaction(oldTransaction);

        // Apply new balance
        final newWallet = await walletRepo.getWallet(_selectedWalletId!);
        if (newWallet != null) {
          if (widget.type == TransactionType.expense) {
            newWallet.balance -= amount;
          } else if (widget.type == TransactionType.income) {
            newWallet.balance += amount;
          } else if (widget.type == TransactionType.transfer) {
            newWallet.balance -= amount;
          }
          await walletRepo.addWallet(newWallet);
        }

        if (widget.type == TransactionType.transfer && _selectedDestinationWalletId != null) {
           final newDestWallet = await walletRepo.getWallet(_selectedDestinationWalletId!);
           if (newDestWallet != null) {
              newDestWallet.balance += amount;
              await walletRepo.addWallet(newDestWallet);
           }
        }

      } else {
        // CREATE NEW
        final newTransaction = Transaction()
          ..title = title
          ..date = DateTime.now()
          ..amount = amount
          ..type = widget.type
          ..walletId = _selectedWalletId
          ..destinationWalletId = isTransfer ? _selectedDestinationWalletId : null
          ..categoryId = _selectedItem?.category.externalId ?? _selectedItem?.category.id.toString()
          ..subCategoryId = _selectedItem?.subCategory?.id
          ..subCategoryName = _selectedItem?.subCategory?.name
          ..subCategoryIcon = _selectedItem?.subCategory?.iconPath
          ..note = _noteController.text;

        await transactionRepo.addTransaction(newTransaction);
        
        // TRANSFER FEE LOGIC (Create separate expense)
        if (isTransfer) {
            final feeAmount = CurrencyInputFormatter.parse(_feeController.text);
            if (feeAmount > 0) {
                // Find "Financial" > "Fees" Category
                // Ideally this should be robust, but for now we search by known IDs
                final categories = await ref.read(categoryListProvider(CategoryType.expense).future);
                
                Category? feeCategory;
                SubCategory? feeSubCategory;
                
                // Try looking for Financial category first
                // Based on seeding: externalId: 'financial', subId: 'fees'
                try {
                  final financialCat = categories.firstWhere((c) => c.externalId == 'financial', orElse: () => categories.first);
                  if (financialCat.subCategories != null) {
                     feeSubCategory = financialCat.subCategories!.firstWhere((s) => s.id == 'fees' || s.id == 'fee', orElse: () => financialCat.subCategories!.first);
                     feeCategory = financialCat;
                  } else {
                     feeCategory = financialCat;
                  }
                } catch (e) {
                   // Fallback to first expense category if structure changed
                   if (categories.isNotEmpty) feeCategory = categories.first;
                }
                
                final feeTransaction = Transaction()
                  ..title = 'Transfer Fee'
                  ..date = DateTime.now()
                  ..amount = feeAmount
                  ..type = TransactionType.expense
                  ..walletId = _selectedWalletId // Fee deducted from Source Wallet
                  ..categoryId = feeCategory?.externalId ?? feeCategory?.id.toString()
                  ..subCategoryId = feeSubCategory?.id
                  ..subCategoryName = feeSubCategory?.name
                  ..subCategoryIcon = feeSubCategory?.iconPath
                  ..note = 'Fee for transfer: $title'; // Link to transfer
                  
                await transactionRepo.addTransaction(feeTransaction);
            }
        }


      }

      // Invalidate wallet list to ensure UI updates immediately
      ref.invalidate(walletListProvider);

      if (mounted) {
        context.pop();
      }
  }
}
