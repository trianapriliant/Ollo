import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../../data/bill_repository.dart';
import '../../domain/bill.dart';

class BillSummaryCard extends ConsumerWidget {
  const BillSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final billsAsync = ref.watch(billRepositoryProvider).watchUnpaidBills();

    return StreamBuilder(
      stream: billsAsync,
      builder: (context, snapshot) {
        final bills = snapshot.data ?? [];
        
        double totalUnpaid = 0;
        int dueToday = 0;
        int overdue = 0;
        
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        for (var bill in bills) {
          totalUnpaid += bill.amount;
          
          final dueDate = DateTime(bill.dueDate.year, bill.dueDate.month, bill.dueDate.day);
          if (dueDate.isBefore(today)) {
            overdue++;
          } else if (dueDate.isAtSameMomentAs(today)) {
            dueToday++;
          }
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6B48FF), // Purple
                const Color(0xFF8F73FF), // Lighter Purple
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B48FF).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Unpaid',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${bills.length} Bills',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currency.format(totalUnpaid),
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (overdue > 0)
                    _buildStatusBadge(
                      icon: Icons.warning_rounded,
                      label: '$overdue Overdue',
                      color: Colors.red.shade100,
                      textColor: Colors.red.shade900,
                    ),
                  if (overdue > 0 && dueToday > 0)
                    const SizedBox(width: 8),
                  if (dueToday > 0)
                    _buildStatusBadge(
                      icon: Icons.access_time_filled,
                      label: '$dueToday Due Today',
                      color: Colors.orange.shade100,
                      textColor: Colors.orange.shade900,
                    ),
                  if (overdue == 0 && dueToday == 0 && bills.isNotEmpty)
                     _buildStatusBadge(
                      icon: Icons.check_circle,
                      label: 'On Track',
                      color: Colors.green.shade100,
                      textColor: Colors.green.shade900,
                    ),
                   if (bills.isEmpty)
                     _buildStatusBadge(
                      icon: Icons.thumb_up,
                      label: 'All Paid!',
                      color: Colors.white.withOpacity(0.2),
                      textColor: Colors.white,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
