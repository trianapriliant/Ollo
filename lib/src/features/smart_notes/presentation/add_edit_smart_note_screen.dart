import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/presentation/wallet_provider.dart';
import '../../wallets/domain/wallet.dart';
import '../data/smart_note_repository.dart';
import '../domain/smart_note.dart';

class AddEditSmartNoteScreen extends ConsumerStatefulWidget {
  final SmartNote? note;

  const AddEditSmartNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddEditSmartNoteScreen> createState() => _AddEditSmartNoteScreenState();
}

class _AddEditSmartNoteScreenState extends ConsumerState<AddEditSmartNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  
  String? _selectedWalletId;
  // String? _selectedCategoryId; // For future category implementation

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _titleController = TextEditingController(text: n?.title ?? '');
    _amountController = TextEditingController(text: n?.amount?.toStringAsFixed(0) ?? '');
    _notesController = TextEditingController(text: n?.notes ?? '');
    _selectedWalletId = n?.walletId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    final walletsAsync = ref.watch(walletListProvider);

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
          isEditing ? 'Edit Note' : 'New Note',
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                style: AppTextStyles.h3,
                decoration: InputDecoration(
                  labelText: 'What to buy?',
                  hintText: 'e.g. Rice 5kg',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: AppTextStyles.h3.copyWith(color: Colors.teal),
                decoration: InputDecoration(
                  labelText: 'Estimated Price (Optional)',
                  hintText: '0',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 16),

              // Wallet Selector
              walletsAsync.when(
                data: (wallets) {
                  return DropdownButtonFormField<String>(
                    value: _selectedWalletId,
                    decoration: InputDecoration(
                      labelText: 'Pay with Wallet (Optional)',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                    ),
                    items: wallets.map((w) {
                      return DropdownMenuItem(
                        value: w.externalId ?? w.id.toString(),
                        child: Text(w.name),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedWalletId = val),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Additional Notes',
                  hintText: 'e.g. Buy at Supermarket X',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.notes),
                ),
              ),

              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: Colors.teal.withOpacity(0.4),
                  ),
                  child: Text(
                    isEditing ? 'Update Note' : 'Add to List',
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

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(smartNoteRepositoryProvider);
      final amount = double.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      if (widget.note != null) {
        final updated = widget.note!;
        updated.title = _titleController.text;
        updated.amount = amount;
        updated.walletId = _selectedWalletId;
        updated.notes = _notesController.text;
        await repo.updateNote(updated);
      } else {
        final newNote = SmartNote(
          title: _titleController.text,
          amount: amount,
          walletId: _selectedWalletId,
          notes: _notesController.text,
          createdAt: DateTime.now(),
        );
        await repo.addNote(newNote);
      }

      if (mounted) context.pop();
    }
  }
}
