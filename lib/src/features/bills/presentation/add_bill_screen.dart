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
        title: const Text('Add Bill'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Bill Name',
                hintText: 'e.g. Internet, Rent',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: 'Rp ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Due Date
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(DateFormat('EEE, d MMM yyyy').format(_dueDate)),
              trailing: const Icon(Icons.calendar_today),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),

            // Category (Simplified for now)
            // Ideally reuse CategorySelector but it might need specific layout
            // For now, just a simple dropdown or similar
            const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategoryId,
                  isExpanded: true,
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
            const SizedBox(height: 16),

            // Recurring Switch
            SwitchListTile(
              title: const Text('Repeat this bill?'),
              subtitle: const Text('Automatically create new bills'),
              value: _isRecurring,
              onChanged: (val) => setState(() => _isRecurring = val),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            
            if (_isRecurring) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<RecurringFrequency>(
                    value: _frequency,
                    isExpanded: true,
                    items: RecurringFrequency.values.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(f.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _frequency = val!),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Bill'),
              ),
            ),
          ],
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
          const SnackBar(content: Text('Bill saved successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
