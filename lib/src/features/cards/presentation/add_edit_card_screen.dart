import 'package:flutter/material.dart';
import '../../../common_widgets/modern_confirm_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/icon_helper.dart';
import '../../settings/presentation/icon_pack_provider.dart';
import '../../cards/data/card_repository.dart';
import '../../cards/domain/card.dart';

class AddEditCardScreen extends ConsumerStatefulWidget {
  final BankCard? card;

  const AddEditCardScreen({super.key, this.card});

  @override
  ConsumerState<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends ConsumerState<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _holderController;
  late TextEditingController _labelController;
  late TextEditingController _branchController;
  
  late CardType _type;
  late CardCategory _category;
  late CardAccountType _accountType;
  late bool _isPinned;
  late int _color;

  final List<int> _colors = [
    0xFF2196F3, // Blue
    0xFF4CAF50, // Green
    0xFFF44336, // Red
    0xFFFF9800, // Orange
    0xFF9C27B0, // Purple
    0xFF607D8B, // Blue Grey
    0xFF795548, // Brown
    0xFF000000, // Black
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.card;
    _nameController = TextEditingController(text: c?.name ?? '');
    _numberController = TextEditingController(text: c?.number ?? '');
    _holderController = TextEditingController(text: c?.holderName ?? '');
    _labelController = TextEditingController(text: c?.label ?? '');
    _branchController = TextEditingController(text: c?.branch ?? '');
    
    _type = c?.type ?? CardType.bank;
    _category = c?.category ?? CardCategory.main;
    _accountType = c?.accountType ?? CardAccountType.personal;
    _isPinned = c?.isPinned ?? false;
    _color = c?.color ?? _colors[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _holderController.dispose();
    _labelController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.card != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: IconHelper.getIconWidget('close', pack: ref.watch(iconPackProvider), color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Card' : 'Add Card',
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: IconHelper.getIconWidget('delete', pack: ref.watch(iconPackProvider), color: Colors.red),
              onPressed: _deleteCard,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(_color),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(_color).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameController.text.isEmpty ? 'Bank Name' : _nameController.text,
                                style: AppTextStyles.h3.copyWith(color: Colors.white),
                              ),
                              if (_labelController.text.isNotEmpty)
                                Text(
                                  _labelController.text,
                                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconHelper.getIconWidget(
                              _getTypeIconName(_type),
                              pack: ref.watch(iconPackProvider),
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                               decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _accountType.name.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _numberController.text.isEmpty ? '0000 0000 0000' : _numberController.text,
                      style: AppTextStyles.h2.copyWith(color: Colors.white, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _holderController.text.isEmpty ? 'HOLDER NAME' : _holderController.text.toUpperCase(),
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                        if (_isPinned)
                          IconHelper.getIconWidget('push_pin', pack: ref.watch(iconPackProvider), color: Colors.white, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Color Picker
              Text('Card Color', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = color == _color;
                    return GestureDetector(
                      onTap: () => setState(() => _color = color),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(color),
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.grey, width: 3) : null,
                        ),
                        child: isSelected ? IconHelper.getIconWidget('check', pack: ref.watch(iconPackProvider), color: Colors.white) : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _buildTextField(
                controller: _nameController,
                label: 'Bank / Wallet Name',
                hint: 'e.g. BCA, GoPay',
                iconName: 'bank',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _numberController,
                label: 'Account Number',
                hint: 'e.g. 1234567890',
                iconName: 'numbers',
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _holderController,
                label: 'Holder Name',
                hint: 'e.g. John Doe',
                iconName: 'person_outline',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              
              // New Fields (Optional)
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _labelController,
                      label: 'Label (Optional)',
                      hint: 'e.g. Main Savings',
                      iconName: 'label',
                      isRequired: false, // Explicitly not required
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _branchController,
                      label: 'Branch (Optional)',
                      hint: 'e.g. KCP Sudirman',
                      iconName: 'location',
                      isRequired: false, // Explicitly not required
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Type & Account Type (Modernized Selectors)
              Row(
                children: [
                  Expanded(
                    child: _buildSelector(
                      label: 'Provider',
                      value: _type.name.toUpperCase(),
                      iconName: _getTypeIconName(_type),
                      onTap: _showProviderPicker,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSelector(
                      label: 'Type',
                      value: _accountType.name.toUpperCase(),
                      iconName: _getAccountTypeIconName(_accountType),
                      onTap: _showAccountTypePicker,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category Selector (Modernized)
              _buildSelector(
                label: 'Category',
                value: _category.name.toUpperCase(),
                iconName: 'category', 
                onTap: _showCategoryPicker,
              ),
              const SizedBox(height: 16),

              // Pinned Switch
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  title: const Text('Pin to Top'),
                  secondary: IconHelper.getIconWidget('push_pin', pack: ref.watch(iconPackProvider), color: AppColors.textSecondary),
                  value: _isPinned,
                  onChanged: (val) => setState(() => _isPinned = val),
                  activeColor: AppColors.primary,
                ),
              ),

              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    isEditing ? 'Update Card' : 'Save Card',
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String iconName,
    TextInputType? keyboardType,
    bool isRequired = true,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: IconHelper.getIconWidget(iconName, pack: ref.watch(iconPackProvider), color: AppColors.textSecondary, size: 20),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      validator: (val) {
        if (!isRequired) return null;
        if (val == null || val.isEmpty) return 'Required';
        return null;
      },
    );
  }

  /// Reusable Selector Widget similar to AddBillScreen pattern
  Widget _buildSelector({
    required String label,
    required String value,
    required String iconName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           // Label optional, usually included in InputDecorator style or outside
           // Here mimicking custom InputDecorator look
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                IconHelper.getIconWidget(iconName, pack: ref.watch(iconPackProvider), color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                IconHelper.getIconWidget('keyboard_arrow_down', pack: ref.watch(iconPackProvider), color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers for Icons ---
  String _getTypeIconName(CardType type) {
    switch (type) {
      case CardType.bank: return 'bank';
      case CardType.eWallet: return 'wallet';
      case CardType.blockchain: return 'bitcoin';
      case CardType.other: return 'credit_card';
    }
  }

  String _getAccountTypeIconName(CardAccountType type) {
    switch (type) {
      case CardAccountType.personal: return 'person';
      case CardAccountType.business: return 'business_center';
      default: return 'person';
    }
  }

  // IconData getters for picker compatibility
  IconData _getTypeIcon(CardType type) {
    switch (type) {
      case CardType.bank: return Icons.account_balance;
      case CardType.eWallet: return Icons.account_balance_wallet;
      case CardType.blockchain: return Icons.currency_bitcoin;
      case CardType.other: return Icons.credit_card;
    }
  }

  IconData _getAccountTypeIcon(CardAccountType type) {
    switch (type) {
      case CardAccountType.personal: return Icons.person;
      case CardAccountType.business: return Icons.business_center;
      default: return Icons.work;
    }
  }

  // --- Pickers ---

  void _showProviderPicker() {
    _showPicker(
      title: 'Select Provider',
      items: CardType.values,
      selectedItem: _type,
      getName: (item) => item.name.toUpperCase(),
      getIcon: (item) => _getTypeIcon(item),
      onSelected: (item) => setState(() => _type = item),
    );
  }

  void _showAccountTypePicker() {
    _showPicker(
      title: 'Select Account Type',
      items: CardAccountType.values,
      selectedItem: _accountType,
      getName: (item) => item.name.toUpperCase(),
      getIcon: (item) => _getAccountTypeIcon(item),
      onSelected: (item) => setState(() => _accountType = item),
    );
  }

  void _showCategoryPicker() {
    _showPicker(
      title: 'Select Category',
      items: CardCategory.values,
      selectedItem: _category,
      getName: (item) => item.name.toUpperCase(),
      getIcon: (item) => Icons.category_outlined, // Simplified, or add map
      onSelected: (item) => setState(() => _category = item),
    );
  }

  // --- Generic Picker Implementation ---
  void _showPicker<T>({
    required String title,
    required List<T> items,
    required T selectedItem,
    required String Function(T) getName,
    required IconData Function(T) getIcon,
    required Function(T) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
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
              Text(title, style: AppTextStyles.h2),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == selectedItem;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getIcon(item),
                          color: isSelected ? AppColors.primary : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        getName(item),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected 
                          ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                          : null,
                      onTap: () {
                        onSelected(item);
                        context.pop();
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


  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(cardRepositoryProvider);
      
      if (widget.card != null) {
        final updated = widget.card!;
        updated.name = _nameController.text;
        updated.number = _numberController.text;
        updated.holderName = _holderController.text;
        updated.color = _color;
        updated.type = _type;
        updated.category = _category;
        updated.accountType = _accountType;
        updated.label = _labelController.text.isEmpty ? null : _labelController.text;
        updated.branch = _branchController.text.isEmpty ? null : _branchController.text;
        updated.isPinned = _isPinned;
        
        await repo.updateCard(updated);
      } else {
        final newCard = BankCard(
          name: _nameController.text,
          number: _numberController.text,
          holderName: _holderController.text,
          color: _color,
          type: _type,
          category: _category,
          accountType: _accountType,
          label: _labelController.text.isEmpty ? null : _labelController.text,
          branch: _branchController.text.isEmpty ? null : _branchController.text,
          isPinned: _isPinned,
        );
        await repo.addCard(newCard);
      }
      
      if (mounted) context.pop();
    }
  }

  Future<void> _deleteCard() async {
    if (widget.card != null) {
      final confirm = await showModernConfirmDialog(
        context: context,
        title: 'Delete Card?',
        message: 'Are you sure you want to delete this card?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        type: ConfirmDialogType.delete,
      );

      if (confirm == true) {
        await ref.read(cardRepositoryProvider).deleteCard(widget.card!.id);
        if (mounted) context.pop();
      }
    }
  }
}
