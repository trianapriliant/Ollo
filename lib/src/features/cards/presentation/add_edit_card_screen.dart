import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
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
          icon: const Icon(Icons.close, color: Colors.black),
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
              icon: const Icon(Icons.delete_outline, color: Colors.red),
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
                            Icon(
                              _type == CardType.bank ? Icons.account_balance : Icons.account_balance_wallet,
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
                          const Icon(Icons.push_pin, color: Colors.white, size: 16),
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
                        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
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
                icon: Icons.business,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _numberController,
                label: 'Account Number',
                hint: 'e.g. 1234567890',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _holderController,
                label: 'Holder Name',
                hint: 'e.g. John Doe',
                icon: Icons.person_outline,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              
              // New Fields
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _labelController,
                      label: 'Label (Optional)',
                      hint: 'e.g. Main Savings',
                      icon: Icons.label_outline,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _branchController,
                      label: 'Branch (Optional)',
                      hint: 'e.g. KCP Sudirman',
                      icon: Icons.location_on_outlined,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Type & Account Type
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<CardType>(
                      value: _type,
                      decoration: InputDecoration(
                        labelText: 'Provider',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(_type == CardType.bank ? Icons.account_balance : Icons.account_balance_wallet),
                      ),
                      items: CardType.values.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _type = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<CardAccountType>(
                      value: _accountType,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(_accountType == CardAccountType.personal ? Icons.person : Icons.work),
                      ),
                      items: CardAccountType.values.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _accountType = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<CardCategory>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: CardCategory.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
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
                  secondary: const Icon(Icons.push_pin_outlined),
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
    required IconData icon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
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
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Card?'),
          content: const Text('Are you sure you want to delete this card?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(context, true), 
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await ref.read(cardRepositoryProvider).deleteCard(widget.card!.id);
        if (mounted) context.pop();
      }
    }
  }
}
