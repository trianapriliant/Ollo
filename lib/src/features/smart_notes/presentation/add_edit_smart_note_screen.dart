import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/presentation/wallet_provider.dart';
import '../../wallets/domain/wallet.dart';
import '../data/smart_note_repository.dart';
import '../domain/smart_note.dart';
import '../../../common_widgets/modern_wallet_selector.dart';

class AddEditSmartNoteScreen extends ConsumerStatefulWidget {
  final SmartNote? note;

  const AddEditSmartNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddEditSmartNoteScreen> createState() => _AddEditSmartNoteScreenState();
}

class _AddEditSmartNoteScreenState extends ConsumerState<AddEditSmartNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  
  String? _selectedWalletId;
  
  // Temporary list for editing
  List<SmartNoteItem> _items = [];

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _titleController = TextEditingController(text: n?.title ?? '');
    _notesController = TextEditingController(text: n?.notes ?? '');
    _selectedWalletId = n?.walletId;
    
    if (n?.items != null) {
      _items = List.from(n!.items!);
    } else {
      // Start with one empty item
      _items = [SmartNoteItem(name: '')];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(SmartNoteItem(name: ''));
    });
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items.removeAt(index);
      });
    }
  }

  double get _totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.amount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    // Removed walletsAsync watch as ModernWalletSelector handles it internally

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
          isEditing ? AppLocalizations.of(context)!.editSmartNote : AppLocalizations.of(context)!.newSmartNote,
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextFormField(
                      controller: _titleController,
                      style: AppTextStyles.h3,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.smartNoteName,
                        hintText: AppLocalizations.of(context)!.smartNoteNameHint,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.shopping_basket_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.required : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Wallet (Modernized)
                    Text(
                      AppLocalizations.of(context)!.payWithWallet, 
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    ModernWalletSelector(
                      selectedWalletId: _selectedWalletId,
                      onWalletSelected: (val) => setState(() => _selectedWalletId = val),
                    ),
                    const SizedBox(height: 24),

                    // Items List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.itemsList, style: AppTextStyles.h3),
                        TextButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(AppLocalizations.of(context)!.addItem),
                          style: TextButton.styleFrom(foregroundColor: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              // Item Name
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  initialValue: item.name,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.itemName,
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (val) => item.name = val,
                                  validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.requiredShort : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Amount
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  initialValue: item.amount?.toStringAsFixed(0) ?? '',
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.priceLabel,
                                    prefixText: 'Rp ',
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (val) {
                                    final amt = double.tryParse(val.replaceAll(RegExp(r'[^0-9]'), ''));
                                    setState(() => item.amount = amt);
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () => _removeItem(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.additionalNotes,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.notes),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Summary
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.totalEstimate, style: const TextStyle(color: Colors.grey)),
                    Text(
                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_totalAmount),
                      style: AppTextStyles.h2.copyWith(color: Colors.teal),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(AppLocalizations.of(context)!.saveBundle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(smartNoteRepositoryProvider);

      if (widget.note != null) {
        final updated = widget.note!;
        updated.title = _titleController.text;
        updated.items = _items;
        updated.walletId = _selectedWalletId;
        updated.notes = _notesController.text;
        await repo.updateNote(updated);
      } else {
        final newNote = SmartNote(
          title: _titleController.text,
          items: _items,
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
