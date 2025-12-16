import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'premium_provider.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Image or Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.background],
                stops: [0.0, 0.6],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Header
                  Text(
                    l10n.premiumTitle,
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.premiumSubtitle,
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                  
                  const Spacer(),
                  
                  // Features List
                  _buildFeatureItem(Icons.bar_chart, l10n.premiumAdvancedStats, l10n.premiumAdvancedStatsDesc),
                  const SizedBox(height: 16),
                  _buildFeatureItem(Icons.file_download, l10n.premiumDataExport, l10n.premiumDataExportDesc),
                  const SizedBox(height: 16),
                  _buildFeatureItem(Icons.all_inclusive, l10n.premiumUnlimitedWallets, l10n.premiumUnlimitedWalletsDesc),
                  const SizedBox(height: 16),
                  _buildFeatureItem(Icons.notifications_active, l10n.premiumSmartAlerts, l10n.premiumSmartAlertsDesc),
                  
                  const Spacer(),
                  
                  // Action Button
                  if (isPremium)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(l10n.youArePremium, style: AppTextStyles.h3.copyWith(color: Colors.green)),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Simulate Purchase
                          await ref.read(isPremiumProvider.notifier).setPremium(true);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.premiumWelcome)),
                            );
                            context.pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          l10n.upgradeButton,
                          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    
                  const SizedBox(height: 16),
                  if (!isPremium)
                    Center(
                      child: TextButton(
                        onPressed: () {
                           // Restore logic (same as upgrade for now)
                           ref.read(isPremiumProvider.notifier).setPremium(true);
                           context.pop();
                        },
                        child: Text(
                          l10n.restorePurchase,
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
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
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
