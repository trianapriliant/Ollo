import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../wallet_summary_provider.dart';

import '../../../debts/data/debt_repository.dart';
import '../../../debts/domain/debt.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

import '../../../dashboard/presentation/main_card_theme_provider.dart';

class WalletSummaryCard extends ConsumerWidget {
  const WalletSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(walletSummaryProvider);
    final debtsAsync = ref.watch(debtListProvider);
    final currency = ref.watch(currencyProvider);
    final currentTheme = ref.watch(mainCardThemeProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: currentTheme.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: currentTheme.gradient.colors.first.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: summaryAsync.when(
        data: (state) {
          final isPositive = state.periodChange >= 0;
          final sign = isPositive ? '+' : '';
          final badgeColor = isPositive ? Colors.white.withOpacity(0.2) : Colors.red.withOpacity(0.2);
          final icon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

          // Calculate Nett Balance & Total Active Debt
          double nettBalance = state.totalBalance;
          double totalDebt = 0;
          
          debtsAsync.whenData((debts) {
            for (final debt in debts) {
              if (debt.status == DebtStatus.active) {
                final remaining = debt.amount - debt.paidAmount;
                if (debt.type == DebtType.lending) {
                  nettBalance += remaining; // Piutang (Receivable) adds to wealth
                } else {
                  nettBalance -= remaining; // Hutang (Payable) subtracts from wealth
                  totalDebt += remaining; // Track total debt
                }
              }
            }
          });

          return Column(
            children: [
              Text(
                AppLocalizations.of(context)!.totalBalance,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4), // Reduced from 8
              Text(
                currency.format(state.totalBalance),
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Nett Balance & Debt Display
              const SizedBox(height: 8), // Reduced from 12
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nett Balance
                  _buildGlassBadge(
                    context,
                    label: '${AppLocalizations.of(context)!.nettBalance}: ${currency.format(nettBalance)}',
                    color: Colors.white,
                  ),
                  
                  // Active Debt (if any)
                  if (totalDebt > 0) ...[
                    const SizedBox(width: 8),
                    _buildGlassBadge(
                      context,
                      label: '${AppLocalizations.of(context)!.activeDebt}: ${currency.format(totalDebt)}',
                      color: Colors.white,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16), // Reduced from 20
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlassBadge(
                    context,
                    label: '$sign${state.percentageChange.toStringAsFixed(1)}%',
                    icon: icon,
                    color: Colors.white,
                    isBold: true,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '($sign${currency.format(state.periodChange.abs())}) ${AppLocalizations.of(context)!.last30Days}',
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
            AppLocalizations.of(context)!.error(error.toString()),
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassBadge(
    BuildContext context, {
    required String label,
    IconData? icon,
    required Color color,
    bool isBold = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
