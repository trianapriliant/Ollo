import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../utils/icon_helper.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../common_widgets/modern_confirm_dialog.dart';
import '../../domain/category.dart';
import '../../../../localization/generated/app_localizations.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../../features/settings/presentation/icon_pack_provider.dart';

class SubCategoryManager extends ConsumerStatefulWidget {
  final List<SubCategory> subCategories;
  final ValueChanged<List<SubCategory>> onSubCategoriesChanged;

  const SubCategoryManager({
    super.key,
    required this.subCategories,
    required this.onSubCategoriesChanged,
  });

  @override
  ConsumerState<SubCategoryManager> createState() => _SubCategoryManagerState();
}

class _SubCategoryManagerState extends ConsumerState<SubCategoryManager> {
  static const List<String> commonIcons = [
    'fastfood', 'restaurant', 'lunch_dining', 'local_cafe', 
    'directions_bus', 'directions_car', 'local_gas_station', 
    'shopping_bag', 'shopping_cart', 
    'movie', 'sports_esports', 'fitness_center', 
    'medical_services', 'school', 'work', 
    'home', 'lightbulb', 'water_drop', 'wifi',
    'category', 'more_horiz', 'star', 'favorite'
  ];

  Future<void> _showDeleteConfirmation(SubCategory sub, int index) async {
    // Check for linked transactions
    final txnRepository = await ref.read(transactionRepositoryProvider.future);
    final linkedTransactions = await txnRepository.getTransactionsBySubCategoryId(sub.id ?? '');
    final count = linkedTransactions.length;
    
    if (!mounted) return;
    
    final confirmed = await showModernConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.delete,
      message: '${AppLocalizations.of(context)!.delete} "${sub.name}"?',
      secondaryMessage: count > 0 
        ? '$count ${count == 1 ? 'transaction uses' : 'transactions use'} this sub-category'
        : null,
      confirmText: AppLocalizations.of(context)!.delete,
      cancelText: AppLocalizations.of(context)!.cancel,
      type: ConfirmDialogType.delete,
    );
    
    if (confirmed == true) {
      final newList = List<SubCategory>.from(widget.subCategories);
      newList.removeAt(index);
      widget.onSubCategoriesChanged(newList);
    }
  }

  void _showSubCategoryEditor({SubCategory? subCategory, int? index}) {
    final isEditing = subCategory != null;
    final nameController = TextEditingController(text: isEditing ? subCategory.name : '');
    String selectedIcon = isEditing ? (subCategory.iconPath ?? 'category') : 'category';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing 
                            ? AppLocalizations.of(context)!.editSubCategory 
                            : AppLocalizations.of(context)!.newSubCategory,
                        style: AppTextStyles.h3,
                      ),
                      TextButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            final newList = List<SubCategory>.from(widget.subCategories);
                            
                            if (isEditing) {
                              newList[index!] = SubCategory(
                                id: subCategory.id,
                                name: nameController.text,
                                iconPath: selectedIcon,
                              );
                            } else {
                              newList.add(SubCategory(
                                id: const Uuid().v4(),
                                name: nameController.text,
                                iconPath: selectedIcon,
                              ));
                            }
                            
                            widget.onSubCategoriesChanged(newList);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.save, 
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.name, 
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.withOpacity(0.1)),
                          ),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.subCategoryHint,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                            autofocus: !isEditing,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          AppLocalizations.of(context)!.icon, 
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: commonIcons.map((icon) {
                            final isSelected = selectedIcon == icon;
                            return GestureDetector(
                              onTap: () => setModalState(() => selectedIcon = icon),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ] : null,
                                ),
                                child: IconHelper.getIconWidget(
                                  icon,
                                  pack: ref.read(iconPackProvider),
                                  color: isSelected ? AppColors.primary : Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.subCategories, 
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
            ),
            GestureDetector(
              onTap: () => _showSubCategoryEditor(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.add, 
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: widget.subCategories.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.folder_open, color: Colors.grey[300], size: 40),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.noSubCategories, 
                          style: TextStyle(color: Colors.grey[400])
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.subCategories.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
                  itemBuilder: (context, index) {
                    final sub = widget.subCategories[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconHelper.getIconWidget(
                          sub.iconPath ?? 'category',
                          pack: ref.watch(iconPackProvider),
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        sub.name ?? 'Unknown',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                            onPressed: () => _showSubCategoryEditor(subCategory: sub, index: index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[300]),
                            onPressed: () => _showDeleteConfirmation(sub, index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
