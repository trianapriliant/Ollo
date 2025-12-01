import 'package:flutter/material.dart';
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

class AddBillScreen extends ConsumerStatefulWidget {
  const AddBillScreen({super.key});

  @override
  ConsumerState<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends ConsumerState<AddBillScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _selectedCategoryId = '1'; // Default
  bool _isRecurring = false;
  RecurringFrequency _frequency = RecurringFrequency.monthly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Add Bill', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            Text('Bill Details', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _titleController,
              label: 'Bill Name',
              hint: 'e.g. Internet, Rent',
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),

            // Amount Input
            _buildTextField(
              controller: _amountController,
              label: 'Amount',
              hint: '0',
              prefix: 'Rp ',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Due Date
            Text('Due Date', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
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

            // Category
            Text('Category', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
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
                  value: _selectedCategoryId,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('Bills')),
                    DropdownMenuItem(value: '2', child: Text('Food')),
                    DropdownMenuItem(value: '3', child: Text('Transport')),
                    DropdownMenuItem(value: '4', child: Text('Shopping')),
                    DropdownMenuItem(value: '5', child: Text('Entertainment')),
                    DropdownMenuItem(value: '6', child: Text('Health')),
                    DropdownMenuItem(value: '7', child: Text('Education')),
                  ],
                  onChanged: (val) => setState(() => _selectedCategoryId = val!),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recurring Switch
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
                    title: Text('Repeat this bill?', style: AppTextStyles.bodyMedium),
                    subtitle: Text('Automatically create new bills', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
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
                          Text('Frequency', style: AppTextStyles.bodyMedium),
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
                child: const Text('Save Bill', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    final amountText = _amountController.text.replaceAll(',', '').trim();
    final amount = double.tryParse(amountText);

    if (title.isEmpty || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid title and amount')),
      );
      return;
    }

    try {
      if (_isRecurring) {
        // Create Recurring Transaction Template
        final recurringRepo = ref.read(recurringRepositoryProvider);
        final newRecurring = RecurringTransaction(
          amount: amount,
          categoryId: _selectedCategoryId,
          walletId: '1', // Default wallet for now
          note: title,
          frequency: _frequency,
          startDate: _dueDate,
          nextDueDate: _dueDate,
          createBillOnly: true, // IMPORTANT: This makes it generate Bills, not Transactions
        );
        await recurringRepo.addRecurringTransaction(newRecurring);
        
        // Also create the first bill immediately if due today or past
        // Actually, the service processes "due" transactions. 
        // We can let the service handle it, or manually create the first one.
        // Let's manually create the first one to be sure.
        final billRepo = ref.read(billRepositoryProvider);
        final newBill = Bill(
          title: title,
          amount: amount,
          dueDate: _dueDate,
          categoryId: _selectedCategoryId,
          status: BillStatus.unpaid,
          recurringTransactionId: newRecurring.id,
        );
        await billRepo.addBill(newBill);

      } else {
        // One-time Bill
        final billRepo = ref.read(billRepositoryProvider);
        final newBill = Bill(
          title: title,
          amount: amount,
          dueDate: _dueDate,
          categoryId: _selectedCategoryId,
          status: BillStatus.unpaid,
        );
        await billRepo.addBill(newBill);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bill saved successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
