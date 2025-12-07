import 'package:flutter/material.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../utils/icon_helper.dart';
import '../../../categories/domain/category.dart';
import '../../../transactions/domain/transaction.dart';
import '../category_selection_item.dart';

class TransactionCategorySelector extends StatelessWidget {
  final TransactionType type;
  final CategorySelectionItem? selectedItem;
  final Transaction? transactionToEdit;
  final List<CategorySelectionItem> items; // Pass pre-calculated items or calculate inside?
  // passing items is better but items depend on categoriesAsync.
  // Let's pass the list of items to keep it pure if possible, OR make it ConsumerWidget.
  // Given the complexity of generating "System Categories", keeping logic here might be better.
  // But parent needs the items to auto-select.
  // Let's assume parent passes `items` or this widget is a ConsumerWidget that fetches categories.
  // Ideally, decoupling data fetching: pass `items` as List<CategorySelectionItem>.
  // BUT `items` creation logic is complex (virtual categories).
  // Let's stick to ConsumerWidget for now to encapsulate the "Virtual Category" logic,
  // OR just accept the items list.
  // Check original code: It builds `items` inside `categoriesAsync.when`.
  // To keep it clean, let's accept `items` and let the parent handle the `AsyncValue` or
  // make this widget handle the `AsyncValue`.
  // Decision: Make it handle the list of items. Parent handles fetching.
  
  final Function(CategorySelectionItem?) onChanged;

  const TransactionCategorySelector({
    super.key,
    required this.type,
    required this.selectedItem,
    required this.transactionToEdit,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (type == TransactionType.system ||
        type == TransactionType.transfer ||
        (transactionToEdit != null &&
            ['debt', 'debts', 'saving', 'savings', 'notes', 'bills', 'wishlist']
                .contains(transactionToEdit!.categoryId))) {
      return _buildReadonlySystemCategory();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CategorySelectionItem>(
              value: selectedItem,
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
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadonlySystemCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
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
                  color: _getSystemColor().withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getSystemIcon(),
                  color: _getSystemColor(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getSystemLabel(),
                  style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[700]),
                ),
              ),
              const Icon(Icons.lock, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSystemColor() {
    if (type == TransactionType.transfer) return Colors.indigo;
    final catId = transactionToEdit?.categoryId;
    if (catId == 'debt' || catId == 'debts') return Colors.purple;
    if (catId == 'saving' || catId == 'savings') return Colors.blue;
    if (catId == 'notes') return Colors.teal;
    if (catId == 'bills') return Colors.orange;
    if (catId == 'wishlist') return Colors.pink;
    return Colors.blue;
  }

  IconData _getSystemIcon() {
    if (type == TransactionType.transfer) return Icons.swap_horiz;
    final catId = transactionToEdit?.categoryId;
    if (catId == 'debt' || catId == 'debts') return Icons.handshake;
    if (catId == 'saving' || catId == 'savings') return Icons.savings;
    if (catId == 'notes') return Icons.shopping_basket;
    if (catId == 'bills') return Icons.receipt_long;
    if (catId == 'wishlist') return Icons.favorite;
    return Icons.settings;
  }

  String _getSystemLabel() {
    if (type == TransactionType.transfer) return 'TRANSFER';
    final catId = transactionToEdit?.categoryId;
    if (catId == 'debt' || catId == 'debts') return 'DEBT';
    if (catId == 'saving' || catId == 'savings') return 'SAVINGS';
    if (catId == 'notes') return 'BUNDLED NOTES';
    if (catId == 'bills') return 'BILLS';
    if (catId == 'wishlist') return 'WISHLIST';
    return catId?.toUpperCase() ?? 'SYSTEM';
  }
}
