import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../localization/generated/app_localizations.dart';

class ReimburseScreen extends ConsumerStatefulWidget {
  const ReimburseScreen({super.key});

  @override
  ConsumerState<ReimburseScreen> createState() => _ReimburseScreenState();
}

class _ReimburseScreenState extends ConsumerState<ReimburseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _sortByDate = false;

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.reimbursementTitle, style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'home') {
                context.go('/home');
              }
              if (value == 'sort_date') {
                setState(() => _sortByDate = !_sortByDate);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_sortByDate ? l10n.sortByDate : 'Sort cleared'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'sort_date',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _sortByDate 
                            ? const Color(0xFF1E1E1E).withOpacity(0.2)
                            : const Color(0xFF1E1E1E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1E1E1E)),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.sortByDate, style: AppTextStyles.bodyMedium),
                    if (_sortByDate) ...[
                      const Spacer(),
                      const Icon(Icons.check, size: 18, color: Color(0xFF1E1E1E)),
                    ],
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'home',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.home, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: l10n.reimbursementPending),
            Tab(text: l10n.reimbursementCompleted),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'reimburse_fab',
        onPressed: () => context.push('/reimburse/add'),
        backgroundColor: const Color(0xFF1E1E1E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReimburseList(status: TransactionStatus.pending, sortByDate: _sortByDate),
          _ReimburseList(status: TransactionStatus.completed, sortByDate: _sortByDate),
        ],
      ),
    );
  }
}

class _ReimburseList extends ConsumerWidget {
  final TransactionStatus status;
  final bool sortByDate;

  const _ReimburseList({required this.status, this.sortByDate = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionStreamProvider);
    final currency = ref.watch(currencyProvider);
    final l10n = AppLocalizations.of(context)!;

    return transactionsAsync.when(
      data: (transactions) {
        var reimbursements = transactions.where((t) => t.type == TransactionType.reimbursement && t.status == status).toList();
        
        // Apply sorting if enabled
        if (sortByDate && reimbursements.isNotEmpty) {
          reimbursements.sort((a, b) => b.date.compareTo(a.date)); // Newest first
        }

        if (reimbursements.isEmpty) {
          return Center(
            child: Text(
              status == TransactionStatus.pending ? l10n.noPendingReimbursements : l10n.noCompletedReimbursements,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reimbursements.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = reimbursements[index];
            return _buildItem(context, ref, item, currency, l10n);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildItem(BuildContext context, WidgetRef ref, Transaction item, Currency currency, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: status == TransactionStatus.pending ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.currency_exchange,
              color: status == TransactionStatus.pending ? Colors.orange : Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(item.date),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currency.format(item.amount),
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              if (status == TransactionStatus.pending)
                GestureDetector(
                  onTap: () async {
                    // Mark as completed
                    final repo = await ref.read(transactionRepositoryProvider.future);
                    // The safer way is:
                    item.status = TransactionStatus.completed;
                    await repo.updateTransaction(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.markPaid,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
