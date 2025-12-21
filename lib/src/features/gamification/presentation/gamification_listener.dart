import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../localization/generated/app_localizations.dart';
import '../application/gamification_provider.dart';
import '../domain/gamification_settings.dart';
import '../domain/gamification_stats.dart';

class GamificationListener extends ConsumerStatefulWidget {
  final Widget child;
  const GamificationListener({super.key, required this.child});

  @override
  ConsumerState<GamificationListener> createState() => _GamificationListenerState();
}

class _GamificationListenerState extends ConsumerState<GamificationListener> {
  Set<String> _previousUnlockedBadges = {};
  bool _isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    _listenToGamificationChanges();
    return widget.child;
  }

  void _listenToGamificationChanges() {
    ref.listen(gamificationProvider, (previous, next) {
      next.whenData((stats) {
        final currentUnlocked = stats.badges
            .where((b) => b.isUnlocked)
            .map((b) => b.id)
            .toSet();

        if (_isFirstLoad) {
          _previousUnlockedBadges = currentUnlocked;
          _isFirstLoad = false;
          return;
        }

        final newBadges = currentUnlocked.difference(_previousUnlockedBadges);
        if (newBadges.isNotEmpty) {
          // Check settings
          final settings = ref.read(gamificationSettingsProvider);
          if (settings.enableNotifications) {
            for (var badgeId in newBadges) {
              final badge = stats.badges.firstWhere((b) => b.id == badgeId);
              _showUnlockDialog(context, badge);
            }
          }
           _previousUnlockedBadges = currentUnlocked;
        }
      });
    });
  }

  void _showUnlockDialog(BuildContext context, GamificationBadge badge) {
    // Using a delayed overlay entry or simple dialog? 
    // Dialog is safer for "blocking" moment of joy. SnackBar is less intrusive.
    // Let's go with a premium Dialog.
    showDialog(
      context: context,
      barrierDismissible: true, // Allow clicking outside
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Dialog(
          backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: badge.color.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              // Icon with Glow
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge.color.withOpacity(0.1),
                ),
                child: Icon(
                  badge.icon,
                  size: 64,
                  color: badge.color,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                l10n.notificationNewBadgeUnlocked,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              // Badge Name (Localize if possible, but helper needed. For now use keys/fallback or just raw title if available)
              // Since we don't have easy context for localization here without passing it or using a key map...
              // We will rely on simple "New Badge!" messaging or try to use AppLocalizations if context is valid.
              Text(
                 l10n.notificationCongratulations,
                 textAlign: TextAlign.center,
                 style: GoogleFonts.outfit(
                   fontSize: 24,
                   fontWeight: FontWeight.bold,
                   color: AppColors.textPrimary,
                 ),
              ),
              const SizedBox(height: 8),
              Text(
                 l10n.notificationYouEarnedXP(badge.xpReward),
                 style: GoogleFonts.outfit(
                   fontSize: 16,
                   fontWeight: FontWeight.w600,
                   color: badge.color,
                 ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.notificationAwesome,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}
