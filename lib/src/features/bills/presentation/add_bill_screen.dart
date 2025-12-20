import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../recurring/data/recurring_repository.dart';
import '../../recurring/domain/recurring_transaction.dart';
import '../../transactions/presentation/widgets/category_selector.dart';
import '../data/bill_repository.dart';
import '../domain/bill.dart';
import '../../../utils/icon_helper.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/domain/category.dart';
import '../../../localization/generated/app_localizations.dart';

import 'package:intl/intl.dart';
import '../../../utils/currency_input_formatter.dart';

class AddBillScreen extends ConsumerStatefulWidget {
  final Bill? billToEdit;
  
  const AddBillScreen({super.key, this.billToEdit});

  @override
  ConsumerState<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends ConsumerState<AddBillScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String? _selectedCategoryId;
  bool _isRecurring = false;
  RecurringFrequency _frequency = RecurringFrequency.monthly;
  String _selectedBillType = 'Internet';

  final List<Map<String, dynamic>> _billTypes = [
    {'name': 'Internet', 'icon': Icons.wifi, 'color': Colors.blue},
    {'name': 'Electricity', 'icon': Icons.bolt, 'color': Colors.orange},
    {'name': 'Water', 'icon': Icons.water_drop, 'color': Colors.cyan},
    {'name': 'Rent', 'icon': Icons.home, 'color': Colors.indigo},
    {'name': 'Phone', 'icon': Icons.phone_iphone, 'color': Colors.green},
    {'name': 'Subscription', 'icon': Icons.subscriptions, 'color': Colors.red},
    {'name': 'Insurance', 'icon': Icons.shield, 'color': Colors.purple},
    {'name': 'Credit Card', 'icon': Icons.credit_card, 'color': Colors.teal},
    {'name': 'Other', 'icon': Icons.receipt_long, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.billToEdit != null) {
      final b = widget.billToEdit!;
      _titleController.text = b.title;
      _amountController.text = NumberFormat.decimalPattern('en_US').format(b.amount); // Format initial logic
      _dueDate = b.dueDate;
      _selectedCategoryId = b.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider(CategoryType.expense));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.billToEdit != null ? AppLocalizations.of(context)!.editBill : AppLocalizations.of(context)!.addBill, style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (widget.billToEdit != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            Text(AppLocalizations.of(context)!.billDetails, style: AppTextStyles.h3),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _titleController,
              label: AppLocalizations.of(context)!.billName,
              hint: 'e.g. Internet, Rent',
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),

            // Amount Input
            _buildTextField(
              controller: _amountController,
              label: AppLocalizations.of(context)!.amount,
              hint: '0',
              prefix: 'Rp ',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              formatter: CurrencyInputFormatter(), // Pass formatter
            ),
            const SizedBox(height: 24),

            // Due Date
            Text(AppLocalizations.of(context)!.dueDateLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      DateFormat('EEE, d MMM yyyy').format(_dueDate),
                      style: AppTextStyles.bodyMedium,
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bill Type Selector
            Text(AppLocalizations.of(context)!.billType, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedBillType,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  items: _billTypes.map((type) {
                    return DropdownMenuItem(
                      value: type['name'] as String,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (type['color'] as Color).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(type['icon'] as IconData, color: type['color'] as Color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(type['name'] as String),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedBillType = val!;
                      // Auto-fill title if empty or matches previous type
                      if (_titleController.text.isEmpty || _billTypes.any((t) => t['name'] == _titleController.text)) {
                        _titleController.text = val;
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recurring Switch (Only for new bills for now)
            if (widget.billToEdit == null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.repeatBill, style: AppTextStyles.bodyMedium),
                      subtitle: Text(AppLocalizations.of(context)!.autoCreateBill, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      value: _isRecurring,
                      onChanged: (val) => setState(() => _isRecurring = val),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_isRecurring) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.frequency, style: AppTextStyles.bodyMedium),
                            const Spacer(),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<RecurringFrequency>(
                                value: _frequency,
                                items: RecurringFrequency.values.map((f) {
                                  return DropdownMenuItem(
                                    value: f,
                                    child: Text(
                                      f.name.toUpperCase(),
                                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) => setState(() => _frequency = val!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(widget.billToEdit != null ? AppLocalizations.of(context)!.updateBill : AppLocalizations.of(context)!.saveBill, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    TextInputType keyboardType = TextInputType.text,
    TextInputFormatter? formatter, // Added optional formatter parameter
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: formatter != null ? [formatter] : null,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefix,
          prefixIcon: Icon(icon, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _saveBill() async {
    final title = _titleController.text.trim();
    // Use parse helper instead of manual replace
    final amount = CurrencyInputFormatter.parse(_amountController.text);

    if (title.isEmpty || amount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorInvalidBill)),
      );
      return;
    }
    
    try {
      final billRepo = ref.read(billRepositoryProvider);

      if (widget.billToEdit != null) {
        // UPDATE
        final bill = widget.billToEdit!;
        bill.title = title;
        bill.amount = amount;
        bill.dueDate = _dueDate;
        bill.categoryId = 'bills'; 
        
        await billRepo.updateBill(bill);
        
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.billUpdated)));
        }
      } else {
        // CREATE
        if (_isRecurring) {
          // Create Recurring Transaction Template
          final recurringRepo = ref.read(recurringRepositoryProvider);
          final newRecurring = RecurringTransaction(
            amount: amount,
            categoryId: 'bills',
            walletId: '1', 
            note: title,
            frequency: _frequency,
            startDate: _dueDate,
            nextDueDate: _dueDate,
            createBillOnly: true, 
          );
          await recurringRepo.addRecurringTransaction(newRecurring);
          
          final newBill = Bill(
            title: title,
            amount: amount,
            dueDate: _dueDate,
            categoryId: 'bills', 
            status: BillStatus.unpaid,
            recurringTransactionId: newRecurring.id,
          );
          await billRepo.addBill(newBill);

        } else {
          // One-time Bill
          final newBill = Bill(
            title: title,
            amount: amount,
            dueDate: _dueDate,
            categoryId: 'bills',
            status: BillStatus.unpaid,
          );
          await billRepo.addBill(newBill);
        }
        
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.billSaved)));
        }
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
  
  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteBill),
        content: Text(AppLocalizations.of(context)!.deleteBillConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    
    if (confirm == true && widget.billToEdit != null) {
      try {
        final billRepo = ref.read(billRepositoryProvider);
        await billRepo.deleteBill(widget.billToEdit!.id);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.billDeleted)));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
