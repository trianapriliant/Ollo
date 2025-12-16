import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../subscription/presentation/premium_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class PremiumStatusCard extends ConsumerWidget {
  const PremiumStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    return GestureDetector(
      onTap: () => _showPremiumDebugDialog(context, ref),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPremium
                ? [const Color(0xFFFFD700), const Color(0xFFFFA500)] // Gold for Premium
                : [const Color(0xFF4A90E2), const Color(0xFF50E3C2)], // Blue/Teal for Free (Upgrade CTA)
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isPremium ? Colors.orange : Colors.blue).withOpacity(0.3),
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
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPremium ? Icons.verified : Icons.star_border,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPremium ? AppLocalizations.of(context)!.premiumMember : AppLocalizations.of(context)!.upgradeToPremium,
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPremium ? AppLocalizations.of(context)!.unlimitedAccess : AppLocalizations.of(context)!.unlockFeatures,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showPremiumDebugDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Mode'),
        content: const Text('Set Premium Status manually for testing purposes.'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(isPremiumProvider.notifier).setPremium(false);
              context.pop();
            },
            child: const Text('Set FREE'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(isPremiumProvider.notifier).setPremium(true);
              context.pop();
            },
            child: const Text('Set PREMIUM'),
          ),
        ],
      ),
    );
  }
}
