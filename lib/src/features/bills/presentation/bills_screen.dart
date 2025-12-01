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
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Bills',
          style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Unpaid'),
                Tab(text: 'Paid'),
              ],
            ),
          ),
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
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_outline, size: 48, color: AppColors.primary.withOpacity(0.6)),
                ),
                const SizedBox(height: 16),
                Text('All caught up!', style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Text('No unpaid bills at the moment.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('No history yet', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
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
    
    Color statusColor = AppColors.textSecondary;
    String statusText = '';
    IconData statusIcon = Icons.calendar_today_outlined;
    
    if (isPaid) {
      statusColor = Colors.green;
      statusText = 'Paid ${DateFormat('MMM d').format(bill.paidAt!)}';
      statusIcon = Icons.check_circle_outline;
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
      statusIcon = Icons.warning_amber_rounded;
    } else if (isDueToday) {
      statusColor = Colors.orange;
      statusText = 'Due Today';
      statusIcon = Icons.access_time;
    } else {
      final daysLeft = dueDate.difference(today).inDays;
      statusColor = AppColors.primary;
      statusText = 'Due in $daysLeft days';
      statusIcon = Icons.schedule;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // TODO: Show bill details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green.withOpacity(0.1) : AppColors.accentBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isPaid ? Icons.check : Icons.receipt_long_outlined,
                    color: isPaid ? Colors.green : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currency.format(bill.amount),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (!isPaid) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: TextButton(
                          onPressed: () => _showPayDialog(context, ref, bill),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Pay', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: Text('Pay Bill', style: AppTextStyles.h3),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pay ${widget.bill.title}?', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount', style: TextStyle(color: AppColors.textSecondary)),
                Text(
                  currency.format(widget.bill.amount),
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This will create an expense transaction and deduct from your wallet.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Confirm Payment'),
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
      
      final wallets = await walletRepo.getAllWallets();
      if (wallets.isEmpty) {
        throw Exception('No wallet found');
      }
      
      final walletId = widget.bill.walletId ?? wallets.first.id.toString();
      final wallet = await walletRepo.getWallet(walletId);
      
      if (wallet == null) throw Exception('Wallet not found');
      
      // Create Transaction
      final newTransaction = Transaction.create(
        title: 'Bill: ${widget.bill.title}',
        amount: widget.bill.amount,
        type: TransactionType.expense,
        categoryId: widget.bill.categoryId,
        walletId: walletId,
        note: 'Bill Payment',
        date: DateTime.now(),
      );
      
      // Update Wallet
      wallet.balance -= widget.bill.amount;
      
      // Update Bill
      widget.bill.status = BillStatus.paid;
      widget.bill.paidAt = DateTime.now();
      
      // Save all
      await transactionRepo.addTransaction(newTransaction);
      await walletRepo.updateWallet(wallet);
      await billRepo.updateBill(widget.bill);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bill paid successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
