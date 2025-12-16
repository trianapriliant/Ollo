import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../wallets/presentation/wallet_provider.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../dashboard_filter_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

import '../main_card_theme_provider.dart';

class MainAccountCard extends ConsumerWidget {
  const MainAccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalanceAsync = ref.watch(totalBalanceProvider);
    final totalBalance = totalBalanceAsync.valueOrNull ?? 0.0;
    final currency = ref.watch(currencyProvider);
    final totalsAsync = ref.watch(dashboardTotalsProvider);
    final totals = totalsAsync.valueOrNull ?? {'income': 0.0, 'expense': 0.0};
    
    final currentTheme = ref.watch(mainCardThemeProvider);

    return Container(
      padding: const EdgeInsets.all(20), // Reduced from 24
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
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.totalBalance,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2), // Reduced from 4
          Text(
            currency.format(totalBalance),
            style: AppTextStyles.h1.copyWith(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16), // Reduced from 20
          Row(
            children: [
              Expanded(
                child: _buildGlassSummaryItem(
                  context,
                  label: AppLocalizations.of(context)!.income,
                  amount: totals['income']!,
                  currency: currency,
                  onTap: () {
                    context.push('/filtered-transactions', extra: {'isExpense': false});
                  },
                  icon: Icons.arrow_downward_rounded,
                  iconColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGlassSummaryItem(
                  context,
                  label: AppLocalizations.of(context)!.expense,
                  amount: totals['expense']!,
                  currency: currency,
                  onTap: () {
                    context.push('/filtered-transactions', extra: {'isExpense': true});
                  },
                  icon: Icons.arrow_upward_rounded,
                  iconColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassSummaryItem(
    BuildContext context, {
    required String label,
    required double amount,
    required Currency currency,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced from 16
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Reduced from 12
            Text(
              currency.format(amount),
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
