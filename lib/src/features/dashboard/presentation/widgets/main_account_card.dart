import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../wallets/presentation/wallet_provider.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../dashboard_filter_provider.dart';

class MainAccountCard extends ConsumerWidget {
  const MainAccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalanceAsync = ref.watch(totalBalanceProvider);
    final totalBalance = totalBalanceAsync.valueOrNull ?? 0.0;
    final currency = ref.watch(currencyProvider);
    final totalsAsync = ref.watch(dashboardTotalsProvider);
    final totals = totalsAsync.valueOrNull ?? {'income': 0.0, 'expense': 0.0};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text('Total Balance', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 4),
          Text(currency.format(totalBalance), style: AppTextStyles.amountLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  label: 'Income',
                  amount: totals['income']!,
                  currency: currency,
                  icon: Icons.arrow_downward,
                  color: Colors.green,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  label: 'Expense',
                  amount: totals['expense']!,
                  currency: currency,
                  icon: Icons.arrow_upward,
                  color: Colors.red,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String label,
    required double amount,
    required Currency currency,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12), // Smaller corner radius as requested
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currency.format(amount),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
