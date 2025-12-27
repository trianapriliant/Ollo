import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../recurring/data/recurring_repository.dart';
import '../../recurring/domain/recurring_transaction.dart';
import 'widgets/recurring_summary_card.dart';
import '../../../localization/generated/app_localizations.dart';

class RecurringScreen extends ConsumerStatefulWidget {
  const RecurringScreen({super.key});

  @override
  ConsumerState<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends ConsumerState<RecurringScreen> {
  bool _sortByDate = false;

  List<RecurringTransaction> _sortTransactions(List<RecurringTransaction> transactions) {
    if (!_sortByDate) return transactions;
    final sorted = List<RecurringTransaction>.from(transactions);
    sorted.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate)); // Earliest first
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final recurringAsync = ref.watch(recurringListProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.recurringTitle, style: AppTextStyles.h2),
        centerTitle: true,
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
                    content: Text(_sortByDate ? AppLocalizations.of(context)!.sortByDate : 'Sort cleared'),
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
                            ? AppColors.primary.withOpacity(0.2) 
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.sortByDate, style: AppTextStyles.bodyMedium),
                    if (_sortByDate) ...[
                      const Spacer(),
                      Icon(Icons.check, size: 18, color: AppColors.primary),
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
                    Text(AppLocalizations.of(context)!.home, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RecurringSummaryCard(),
              const SizedBox(height: 24),
              Text(AppLocalizations.of(context)!.activeSubscriptions, style: AppTextStyles.h3),
              const SizedBox(height: 16),
              recurringAsync.when(
                data: (transactions) {
                  final sortedTx = _sortTransactions(transactions);
                  if (sortedTx.isEmpty) {
                    return Center(child: Text(AppLocalizations.of(context)!.noActiveSubscriptions));
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedTx.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tx = sortedTx[index];
                      return _buildRecurringItem(context, tx, ref, currency);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'recurring_fab',
        onPressed: () => _showAddRecurringDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRecurringItem(BuildContext context, RecurringTransaction tx, WidgetRef ref, Currency currency) {
    return InkWell(
      onTap: () => _showAddRecurringDialog(context, ref, transaction: tx),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                color: AppColors.accentBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.repeat, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.note ?? AppLocalizations.of(context)!.recurring,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${tx.frequency.name.toUpperCase()} • Next: ${DateFormat('d MMM').format(tx.nextDueDate)}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              currency.format(tx.amount),
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRecurringDialog(BuildContext context, WidgetRef ref, {RecurringTransaction? transaction}) {
    if (transaction != null) {
      context.push('/recurring/edit', extra: transaction);
    } else {
      context.push('/recurring/add');
    }
  }
}
