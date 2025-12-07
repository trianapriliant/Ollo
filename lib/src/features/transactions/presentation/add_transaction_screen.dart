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

import 'category_selection_item.dart';
import 'widgets/transaction_amount_input.dart';
import 'widgets/transaction_category_selector.dart';
import 'widgets/transaction_note_input.dart';
import 'widgets/transaction_wallet_selector.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionType type;
  final Transaction? transactionToEdit;

  const AddTransactionScreen({super.key, required this.type, this.transactionToEdit});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
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
            // 1. Amount Input
            TransactionAmountInput(
              controller: _amountController,
              currencySymbol: ref.watch(currencyProvider).symbol,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 24),

            // 2. Title Input
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

            const SizedBox(height: 24),

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
                      name: 'Bills',
                      iconPath: 'receipt_long',
                      type: CategoryType.expense,
                      colorValue: Colors.orange.value,
                      subCategories: [],
                    )..id = -100,
                  ));
                  items.add(CategorySelectionItem(
                    category: Category(
                      externalId: 'wishlist',
                      name: 'Wishlist',
                      iconPath: 'favorite',
                      type: CategoryType.expense,
                      colorValue: Colors.pink.value,
                      subCategories: [],
                    )..id = -101,
                  ));
                  items.add(CategorySelectionItem(
                    category: Category(
                      externalId: 'debt',
                      name: 'Debt',
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

                // Initial Selection Logic
                if (_selectedItem == null && widget.transactionToEdit != null && items.isNotEmpty) {
                    try {
                       _selectedItem = items.firstWhere((item) {
                         final catId = item.category.externalId ?? item.category.id.toString();
                         return catId == widget.transactionToEdit!.categoryId &&
                         (item.subCategory?.name == widget.transactionToEdit!.title || item.subCategory == null && item.category.name == widget.transactionToEdit!.title);
                       });
                    } catch (e) {
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

                return TransactionCategorySelector(
                  type: type,
                  selectedItem: _selectedItem,
                  transactionToEdit: widget.transactionToEdit,
                  items: items,
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value;
                      if (value != null) {
                        _titleController.text = value.name;
                      }
                    });
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error loading categories: $err'),
            ),

            const SizedBox(height: 24),

            // 5. Note Input
            TransactionNoteInput(controller: _noteController),

            const Spacer(),

            // 6. Save Button (Logic kept here as it coordinates everything)
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
                  if (_selectedItem == null &&
                      type != TransactionType.system &&
                      type != TransactionType.transfer &&
                      !(widget.transactionToEdit != null &&
                          ['debt', 'debts', 'saving', 'savings'].contains(widget.transactionToEdit!.categoryId))) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category")));
                    return;
                  }

                  final title = _titleController.text.isNotEmpty
                      ? _titleController.text
                      : (_selectedItem?.name ?? (type == TransactionType.transfer ? 'Transfer' : 'System Transaction'));

                  // Save Logic (Delegated to helper method or keep here?)
                  // Keeping here for now to avoid logic breakage, scope is UI refactoring.
                  await _saveTransaction(amount, title, isTransfer);
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

  Future<void> _saveTransaction(double amount, String title, bool isTransfer) async {
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

        // Update Wallet Balance
        final wallet = await walletRepo.getWallet(_selectedWalletId!);
        if (wallet != null) {
          if (widget.type == TransactionType.expense) {
            wallet.balance -= amount;
          } else if (widget.type == TransactionType.income) {
             wallet.balance += amount;
          } else if (widget.type == TransactionType.transfer) {
            wallet.balance -= amount;
          }
          await walletRepo.addWallet(wallet);
        }

        if (widget.type == TransactionType.transfer && _selectedDestinationWalletId != null) {
           final destWallet = await walletRepo.getWallet(_selectedDestinationWalletId!);
           if (destWallet != null) {
              destWallet.balance += amount;
              await walletRepo.addWallet(destWallet);
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
