import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../utils/icon_helper.dart';
import '../../../categories/domain/category.dart';
import '../../../transactions/domain/transaction.dart';
import '../category_selection_item.dart';
import '../../../categories/presentation/category_localization_helper.dart';
import '../../../../localization/generated/app_localizations.dart';
import '../../../settings/presentation/icon_style_provider.dart';

class TransactionCategorySelector extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final iconStyle = ref.watch(iconStyleProvider);
    
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
        Text(AppLocalizations.of(context)!.category, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showCategoryPicker(context, ref),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                if (selectedItem != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedItem!.category.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconHelper.getIconWithStyle(selectedItem!.subCategory?.iconPath ?? selectedItem!.category.iconPath, iconStyle),
                      color: selectedItem!.category.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedItem!.subCategory != null
                       ? CategoryLocalizationHelper.getLocalizedSubCategoryName(context, selectedItem!.subCategory!)
                        : CategoryLocalizationHelper.getLocalizedCategoryName(context, selectedItem!.category),
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ] else ...[
                  Icon(Icons.category_outlined, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.selectCategory,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
                const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCategoryPicker(BuildContext context, WidgetRef ref) {
    final iconStyle = ref.read(iconStyleProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.selectCategory,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedItem == item;
                    final isSubCategory = item.subCategory != null;
                    
                    return ListTile(
                      contentPadding: EdgeInsets.only(
                        left: isSubCategory ? 48 : 24, 
                        right: 24, 
                        top: 4, 
                        bottom: 4
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : item.category.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          IconHelper.getIconWithStyle(item.subCategory?.iconPath ?? item.category.iconPath, iconStyle),
                          color: isSelected ? AppColors.primary : item.category.color,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        isSubCategory
                          ? CategoryLocalizationHelper.getLocalizedSubCategoryName(context, item.subCategory!)
                          : CategoryLocalizationHelper.getLocalizedCategoryName(context, item.category),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : (isSubCategory ? FontWeight.w400 : FontWeight.w600),
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected 
                          ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                          : null,
                      onTap: () {
                        onChanged(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadonlySystemCategory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.category, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSystemColor().withOpacity(0.15),
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
                  style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[700], fontWeight: FontWeight.w600),
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
