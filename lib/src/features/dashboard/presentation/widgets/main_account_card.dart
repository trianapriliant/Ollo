import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../wallets/presentation/wallet_provider.dart';
import '../../../settings/presentation/currency_provider.dart';

class MainAccountCard extends ConsumerWidget {
  const MainAccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalanceAsync = ref.watch(totalBalanceProvider);
    final totalBalance = totalBalanceAsync.valueOrNull ?? 0.0;
    final currency = ref.watch(currencyProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text('Total Balance', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text('${currency.symbol} ${totalBalance.toStringAsFixed(2)}', style: AppTextStyles.amountLarge),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/add-transaction', extra: false), // Income
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('Income'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/add-transaction', extra: true), // Expense
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Expense'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
