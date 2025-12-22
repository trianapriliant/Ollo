import 'package:flutter/material.dart';
import '../../../common_widgets/modern_confirm_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../savings/data/saving_repository.dart';
import '../../savings/domain/saving_goal.dart';

import 'package:intl/intl.dart';
import '../../../utils/currency_input_formatter.dart';

class AddEditSavingScreen extends ConsumerStatefulWidget {
  final SavingGoal? goal;

  const AddEditSavingScreen({super.key, this.goal});

  @override
  ConsumerState<AddEditSavingScreen> createState() => _AddEditSavingScreenState();
}

class _AddEditSavingScreenState extends ConsumerState<AddEditSavingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _targetController;
  
  SavingType _type = SavingType.standard;

  @override
  void initState() {
    super.initState();
    final goal = widget.goal;
    _nameController = TextEditingController(text: goal?.name ?? '');
    
    // Format initial value
    String formattedTarget = '';
    if (goal != null) {
      formattedTarget = NumberFormat.decimalPattern('en_US').format(goal.targetAmount);
    }
    _targetController = TextEditingController(text: formattedTarget);
    
    _type = goal?.type ?? SavingType.standard;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.goal != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(isEditing ? 'Edit Bucket' : 'New Bucket', style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Target Amount Input (Big)
                    Text('Target Amount', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _targetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyInputFormatter(),
                      ],
                      style: AppTextStyles.h1.copyWith(fontSize: 40, color: AppColors.primary),
                      decoration: InputDecoration(
                        prefixText: 'Rp ',
                        prefixStyle: AppTextStyles.h1.copyWith(fontSize: 40, color: AppColors.primary),
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: AppTextStyles.h1.copyWith(fontSize: 40, color: Colors.grey[300]),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Please enter a target';
                        final amount = CurrencyInputFormatter.parse(val);
                        if (amount <= 0) return 'Invalid amount';
                        return null;
                      },
                    ),
                    const Divider(height: 32, thickness: 1),

                    // Name Input
                    Text('Bucket Name', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'e.g. Emergency Fund, New Laptop',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        prefixIcon: const Icon(Icons.label_outline, color: Colors.grey),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 24),

                    // Type Selector
                    Text('Bucket Type', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _showBucketTypePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getTypeColor(_type).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_getTypeIcon(_type), color: _getTypeColor(_type), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(_getTypeLabel(_type), style: AppTextStyles.bodyMedium),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Save Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? 'Update Bucket' : 'Create Bucket',
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBucketTypePicker() {
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
              Text(
                'Select Bucket Type',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: SavingType.values.length,
                  itemBuilder: (context, index) {
                    final type = SavingType.values[index];
                    final isSelected = type == _type;
                    
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(_getTypeIcon(type), 
                          color: isSelected ? AppColors.primary : Colors.grey[700]),
                      ),
                      title: Text(
                        _getTypeLabel(type),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected 
                          ? Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                          : null,
                      onTap: () {
                        setState(() => _type = type);
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

  IconData _getTypeIcon(SavingType type) {
    switch (type) {
      case SavingType.emergency:
        return Icons.warning_amber_rounded;
      case SavingType.deposito:
        return Icons.lock_clock_outlined;
      case SavingType.standard:
      default:
        return Icons.savings_outlined;
    }
  }

  Color _getTypeColor(SavingType type) {
    switch (type) {
      case SavingType.emergency:
        return Colors.red;
      case SavingType.deposito:
        return Colors.purple;
      case SavingType.standard:
      default:
        return Colors.blue;
    }
  }

  String _getTypeLabel(SavingType type) {
    switch (type) {
      case SavingType.emergency:
        return 'Emergency Fund';
      case SavingType.deposito:
        return 'Locked / Deposito';
      case SavingType.standard:
      default:
        return 'Standard Goal';
    }
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      final target = CurrencyInputFormatter.parse(_targetController.text);
      
      if (widget.goal != null) {
        final updated = widget.goal!;
        updated.name = _nameController.text;
        updated.targetAmount = target;
        updated.type = _type;
        await ref.read(savingRepositoryProvider).updateSavingGoal(updated);
      } else {
        final newGoal = SavingGoal(
          name: _nameController.text,
          targetAmount: target,
          type: _type,
        );
        await ref.read(savingRepositoryProvider).addSavingGoal(newGoal);
      }
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.goal != null ? 'Bucket updated!' : 'Bucket created!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showModernConfirmDialog(
      context: context,
      title: 'Delete Bucket?',
      message: 'This will delete the saving goal and its history. Wallet balances will NOT be reverted automatically.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      type: ConfirmDialogType.delete,
    );

    if (confirm == true && widget.goal != null) {
      await ref.read(savingRepositoryProvider).deleteSavingGoal(widget.goal!.id);
      if (mounted) {
        context.pop(); // Close dialog
        context.pop(); // Close screen
        // If we came from detail screen, we might need to pop again or handle it. 
        // Usually DetailScreen listens to stream and pops if item deleted, or we pop manually.
        // Let's assume DetailScreen handles it or we pop to list.
      }
    }
  }
}
