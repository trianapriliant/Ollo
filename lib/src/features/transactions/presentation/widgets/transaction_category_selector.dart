import 'package:flutter/material.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../utils/icon_helper.dart';
import '../../../categories/domain/category.dart';
import '../../../transactions/domain/transaction.dart';
import '../category_selection_item.dart';

import '../../../categories/presentation/category_localization_helper.dart';
import '../../../../localization/generated/app_localizations.dart';

class TransactionCategorySelector extends StatelessWidget {
  final TransactionType type;
  final CategorySelectionItem? selectedItem;
  final Transaction? transactionToEdit;
  final List<CategorySelectionItem> items; 
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
      return _buildReadonlySystemCategory(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.category, style: AppTextStyles.bodyMedium),
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
              hint: Text(AppLocalizations.of(context)!.selectCategory),
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
                        item.subCategory != null
                          ? CategoryLocalizationHelper.getLocalizedSubCategoryName(context, item.subCategory!)
                          : CategoryLocalizationHelper.getLocalizedCategoryName(context, item.category),
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

  Widget _buildReadonlySystemCategory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.category, style: AppTextStyles.bodyMedium),
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
                  _getSystemLabel(context),
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

  String _getSystemLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (type == TransactionType.transfer) return l10n.sysCatTransfer.toUpperCase();
    final catId = transactionToEdit?.categoryId;
    if (catId == 'debt' || catId == 'debts') return l10n.sysCatDebts.toUpperCase();
    if (catId == 'saving' || catId == 'savings') return l10n.sysCatSavings.toUpperCase();
    if (catId == 'notes') return l10n.sysCatSmartNotes.toUpperCase();
    if (catId == 'bills') return l10n.sysCatBills.toUpperCase();
    if (catId == 'wishlist') return l10n.sysCatWishlist.toUpperCase();
    return catId?.toUpperCase() ?? 'SYSTEM';
  }
}
