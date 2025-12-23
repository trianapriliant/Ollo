import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../subscription/presentation/premium_provider.dart';
import '../../../subscription/domain/subscription_model.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class PremiumStatusCard extends ConsumerWidget {
  const PremiumStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final isVip = ref.watch(isVipProvider);
    final isDeveloper = ref.watch(isDeveloperProvider);
    final tier = ref.watch(subscriptionTierProvider);

    // Determine colors and icons based on tier
    final List<Color> gradientColors;
    final IconData icon;
    final String title;
    final String subtitle;
    final String? badge;
    final Color iconColor;

    if (isDeveloper) {
      gradientColors = [const Color(0xFF1A1A2E), const Color(0xFF16213E)]; // Dark navy for Developer
      icon = Icons.code;
      iconColor = const Color(0xFF00D9FF); // Cyan
      title = 'Developer';
      subtitle = 'Full Access & Debug Mode';
      badge = 'DEV';
    } else if (isVip) {
      gradientColors = [const Color(0xFF9C27B0), const Color(0xFFE040FB)]; // Purple for VIP
      icon = Icons.workspace_premium;
      iconColor = Colors.white;
      title = 'VIP Member';
      subtitle = 'Early Access & Exclusive Benefits';
      badge = 'VIP';
    } else if (isPremium) {
      gradientColors = [const Color(0xFFFFD700), const Color(0xFFFFA500)]; // Gold for Premium
      icon = Icons.verified;
      iconColor = Colors.white;
      title = AppLocalizations.of(context)!.premiumMember;
      subtitle = AppLocalizations.of(context)!.unlimitedAccess;
      badge = 'PRO';
    } else {
      gradientColors = [const Color(0xFF4A90E2), const Color(0xFF50E3C2)]; // Blue/Teal for Free
      icon = Icons.star_border;
      iconColor = Colors.white;
      title = AppLocalizations.of(context)!.upgradeToPremium;
      subtitle = AppLocalizations.of(context)!.unlockFeatures;
      badge = null;
    }

    return GestureDetector(
      onTap: () => context.push('/premium'),
      onLongPress: kDebugMode ? () => _showDebugDialog(context, ref) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDeveloper ? 0.1 : 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h3.copyWith(color: Colors.white),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDeveloper 
                                ? const Color(0xFF00D9FF).withOpacity(0.3)
                                : Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: isDeveloper ? const Color(0xFF00D9FF) : Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  if (isPremium && !isVip && !isDeveloper) ...[
                    const SizedBox(height: 4),
                    Text(
                      tier.displayName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isPremium || isVip || isDeveloper ? Icons.settings : Icons.chevron_right,
              color: isDeveloper ? const Color(0xFF00D9FF) : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showDebugDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Mode'),
        content: const Text('Set subscription tier for testing.'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(subscriptionStatusProvider.notifier).setDebugStatus(SubscriptionTier.free);
              Navigator.of(context).pop();
            },
            child: const Text('FREE'),
          ),
          TextButton(
            onPressed: () {
              ref.read(subscriptionStatusProvider.notifier).setDebugStatus(SubscriptionTier.monthly);
              Navigator.of(context).pop();
            },
            child: const Text('PREMIUM'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(subscriptionStatusProvider.notifier).setDebugStatus(SubscriptionTier.vip);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            child: const Text('VIP', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
