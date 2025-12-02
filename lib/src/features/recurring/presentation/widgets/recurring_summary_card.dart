import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../data/recurring_repository.dart';
import '../../domain/recurring_transaction.dart';

class RecurringSummaryCard extends ConsumerWidget {
  const RecurringSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringAsync = ref.watch(recurringListProvider);
    final repo = ref.watch(recurringRepositoryProvider);

    return recurringAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return _buildEmptyState();
        }

        return FutureBuilder<double>(
          future: repo.calculateMonthlyCommitment(),
          builder: (context, snapshot) {
            final monthlyCommitment = snapshot.data ?? 0.0;
            final nextBill = _getNextBill(transactions);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Commitment',
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(monthlyCommitment),
                              style: AppTextStyles.h2.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.repeat, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (nextBill != null) ...[
                      Text(
                        'Upcoming Bill',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${nextBill.note ?? "Unknown"}',
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _formatNextDue(nextBill.nextDueDate),
                                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              NumberFormat.compactCurrency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(nextBill.amount),
                              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                       Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No upcoming bills',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.repeat, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'No Recurring Bills',
            style: AppTextStyles.h3.copyWith(color: Colors.grey[800]),
          ),
          Text(
            'Add subscriptions or bills to track them here.',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  RecurringTransaction? _getNextBill(List<RecurringTransaction> transactions) {
    if (transactions.isEmpty) return null;
    final active = transactions.where((t) => t.isActive).toList();
    if (active.isEmpty) return null;
    
    active.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
    return active.first;
  }

  String _formatNextDue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(date.year, date.month, date.day);
    final diff = due.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 7) return 'In $diff days';
    return DateFormat('d MMM y').format(date);
  }
}
