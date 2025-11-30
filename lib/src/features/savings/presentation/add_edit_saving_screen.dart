import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../savings/data/saving_repository.dart';
import '../../savings/domain/saving_goal.dart';

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
    _targetController = TextEditingController(text: goal?.targetAmount.toString() ?? '');
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(isEditing ? 'Edit Bucket' : 'New Bucket', style: AppTextStyles.h2),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name Input
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Bucket Name (e.g. Emergency Fund)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.label_outline),
              ),
              validator: (val) => val == null || val.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),

            // Target Amount Input
            TextFormField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Amount',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.flag_outlined),
                prefixText: 'Rp ',
              ),
              validator: (val) => val == null || val.isEmpty ? 'Please enter a target' : null,
            ),
            const SizedBox(height: 16),

            // Type Dropdown
            DropdownButtonFormField<SavingType>(
              value: _type,
              decoration: InputDecoration(
                labelText: 'Bucket Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: SavingType.values.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(t.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _type = val);
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Save Bucket',
                  style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      final target = double.parse(_targetController.text);
      
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
      
      if (mounted) context.pop();
    }
  }
}
