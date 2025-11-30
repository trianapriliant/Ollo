import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../data/bill_repository.dart';
import '../domain/bill.dart';

class BillsScreen extends ConsumerStatefulWidget {
  const BillsScreen({super.key});

  @override
  ConsumerState<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends ConsumerState<BillsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Bills & Reminders', style: AppTextStyles.h2),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Unpaid'),
            Tab(text: 'Paid'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _UnpaidBillsList(currency: currency),
          _PaidBillsList(currency: currency),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/bills/add');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _UnpaidBillsList extends ConsumerWidget {
  final Currency currency;

  const _UnpaidBillsList({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billRepo = ref.watch(billRepositoryProvider);
    
    return StreamBuilder<List<Bill>>(
      stream: billRepo.watchUnpaidBills(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final bills = snapshot.data!;
        if (bills.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('All bills paid!', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bills.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final bill = bills[index];
            return _BillItem(bill: bill, currency: currency);
          },
        );
      },
    );
  }
}

class _PaidBillsList extends ConsumerWidget {
  final Currency currency;

  const _PaidBillsList({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billRepo = ref.watch(billRepositoryProvider);

    return FutureBuilder<List<Bill>>(
      future: billRepo.getPaidBills(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

        final bills = snapshot.data ?? [];
        if (bills.isEmpty) {
          return Center(
            child: Text('No paid bills history', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bills.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final bill = bills[index];
            return _BillItem(bill: bill, currency: currency, isPaid: true);
          },
        );
      },
    );
  }
}

class _BillItem extends ConsumerWidget {
  final Bill bill;
  final Currency currency;
  final bool isPaid;

  const _BillItem({
    required this.bill,
    required this.currency,
    this.isPaid = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(bill.dueDate.year, bill.dueDate.month, bill.dueDate.day);
    
    final isOverdue = !isPaid && dueDate.isBefore(today);
    final isDueToday = !isPaid && dueDate.isAtSameMomentAs(today);
    
    Color statusColor = Colors.grey;
    String statusText = '';
    
    if (isPaid) {
      statusColor = Colors.green;
      statusText = 'Paid on ${DateFormat('MMM d').format(bill.paidAt!)}';
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
    } else if (isDueToday) {
      statusColor = Colors.orange;
      statusText = 'Due Today';
    } else {
      final daysLeft = dueDate.difference(today).inDays;
      statusColor = AppColors.primary;
      statusText = 'Due in $daysLeft days';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isOverdue ? Border.all(color: Colors.red.withOpacity(0.5)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPaid ? Icons.check : Icons.receipt_long,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.title,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: AppTextStyles.bodySmall.copyWith(color: statusColor),
                ),
                if (!isPaid) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, y').format(bill.dueDate),
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currency.format(bill.amount),
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              if (!isPaid)
                const SizedBox(height: 8),
              if (!isPaid)
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => _showPayDialog(context, ref, bill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Pay'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPayDialog(BuildContext context, WidgetRef ref, Bill bill) {
    showDialog(
      context: context,
      builder: (context) => _PayBillDialog(bill: bill),
    );
  }
}

class _PayBillDialog extends ConsumerStatefulWidget {
  final Bill bill;

  const _PayBillDialog({required this.bill});

  @override
  ConsumerState<_PayBillDialog> createState() => _PayBillDialogState();
}

class _PayBillDialogState extends ConsumerState<_PayBillDialog> {
  // TODO: Fetch wallets
  // For now, we'll just implement the logic assuming we can get the default wallet
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    
    return AlertDialog(
      title: const Text('Pay Bill'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pay ${widget.bill.title}?'),
          const SizedBox(height: 8),
          Text(
            currency.format(widget.bill.amount),
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 16),
          const Text('This will create an expense transaction and deduct from your wallet.', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _processPayment,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Confirm Payment', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<void> _processPayment() async {
    setState(() => _isLoading = true);
    
    try {
      final billRepo = ref.read(billRepositoryProvider);
      final transactionRepo = await ref.read(transactionRepositoryProvider.future);
      final walletRepo = await ref.read(walletRepositoryProvider.future);
      
      // 1. Get Wallet (Use bill's walletId or default)
      // For simplicity, getting the first wallet if not specified
      final wallets = await walletRepo.getAllWallets();
      if (wallets.isEmpty) {
        throw Exception('No wallet found');
      }
      
      final walletId = widget.bill.walletId ?? wallets.first.id.toString();
      final wallet = await walletRepo.getWallet(walletId);
      
      if (wallet == null) throw Exception('Wallet not found');
      
      // Check balance
      if (wallet.balance < widget.bill.amount) {
        // Warning handled by UI logic or just proceed with negative balance?
        // User asked for "Insight: Danger". We can show a warning dialog here.
        // For now, let's proceed but maybe show a snackbar warning.
      }
      
      // 2. Create Transaction
      final newTransaction = Transaction.create(
        title: 'Bill: ${widget.bill.title}',
        amount: widget.bill.amount,
        type: TransactionType.expense,
        categoryId: widget.bill.categoryId,
        walletId: walletId,
        note: 'Bill Payment',
        date: DateTime.now(),
      );
      
      // 3. Update Wallet
      wallet.balance -= widget.bill.amount;
      
      // 4. Update Bill
      widget.bill.status = BillStatus.paid;
      widget.bill.paidAt = DateTime.now();
      
      // 5. Save all
      await transactionRepo.addTransaction(newTransaction);
      await walletRepo.updateWallet(wallet);
      await billRepo.updateBill(widget.bill);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill paid successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
