import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../wallet_summary_provider.dart';

class WalletSummaryCard extends ConsumerWidget {
  const WalletSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(walletSummaryProvider);
    final currency = ref.watch(currencyProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A90E2), // Blue
            const Color(0xFF50E3C2).withOpacity(0.8), // Teal
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: summaryAsync.when(
        data: (state) {
          final isPositive = state.periodChange >= 0;
          final sign = isPositive ? '+' : '';
          final color = isPositive ? Colors.white : Colors.white; // Keep white for contrast on gradient
          final badgeColor = isPositive ? Colors.white.withOpacity(0.2) : Colors.red.withOpacity(0.2);
          final icon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

          return Column(
            children: [
              Text(
                'Total Balance',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currency.format(state.totalBalance),
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$sign${state.percentageChange.toStringAsFixed(1)}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '($sign${currency.format(state.periodChange.abs())}) last 30 days',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error loading summary',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
