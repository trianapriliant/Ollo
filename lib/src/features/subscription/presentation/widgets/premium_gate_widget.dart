import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_text_styles.dart';
import '../premium_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

/// A widget that gates premium features
/// Shows a blur overlay with upgrade CTA for non-premium users
class PremiumGateWidget extends ConsumerWidget {
  final Widget child;
  final String featureName;
  final String? featureDescription;
  final bool showPreview;

  const PremiumGateWidget({
    super.key,
    required this.child,
    required this.featureName,
    this.featureDescription,
    this.showPreview = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final isVip = ref.watch(isVipProvider);

    // Allow access for premium or VIP users
    if (isPremium || isVip) {
      return child;
    }

    // Show locked state for free users
    return Stack(
      children: [
        // Blurred preview (optional)
        if (showPreview)
          IgnorePointer(
            child: Opacity(
              opacity: 0.3,
              child: child,
            ),
          ),
        
        // Lock overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: () => context.push('/premium'),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lock icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Color(0xFFFFD700),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Feature name
                  Text(
                    featureName,
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  
                  if (featureDescription != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        featureDescription!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Upgrade button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.upgradeToPremium,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A smaller inline premium badge for feature hints
class PremiumBadge extends StatelessWidget {
  final bool small;

  const PremiumBadge({super.key, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(small ? 8 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: small ? 10 : 12,
          ),
          SizedBox(width: small ? 2 : 4),
          Text(
            'PRO',
            style: TextStyle(
              color: Colors.white,
              fontSize: small ? 8 : 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A simple lock icon for feature lists
class PremiumLockIcon extends ConsumerWidget {
  final double size;

  const PremiumLockIcon({super.key, this.size = 16});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final isVip = ref.watch(isVipProvider);

    if (isPremium || isVip) {
      return const SizedBox.shrink();
    }

    return Icon(
      Icons.lock,
      color: const Color(0xFFFFD700),
      size: size,
    );
  }
}
