import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../localization/generated/app_localizations.dart';
import '../../dashboard/presentation/main_card_theme_provider.dart';

class CardThemeSelectionScreen extends ConsumerWidget {
  const CardThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(mainCardThemeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.selectTheme, style: AppTextStyles.h2),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: MainCardTheme.values.length,
        itemBuilder: (context, index) {
          final theme = MainCardTheme.values[index];
          final isSelected = theme == currentTheme;
          return GestureDetector(
            onTap: () {
              ref.read(mainCardThemeProvider.notifier).setTheme(theme);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: theme.gradient,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: AppColors.primary, width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                   Center(
                    child: Text(
                      _getThemeName(l10n, theme),
                      style: AppTextStyles.h3.copyWith(color: Colors.white, shadows: [
                         Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ]),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 16, color: AppColors.primary),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getThemeName(AppLocalizations l10n, MainCardTheme theme) {
    switch (theme) {
      case MainCardTheme.classic:
        return l10n.themeClassic;
      case MainCardTheme.sunset:
        return l10n.themeSunset;
      case MainCardTheme.ocean:
        return l10n.themeOcean;
      case MainCardTheme.berry:
        return l10n.themeBerry;
      case MainCardTheme.forest:
        return l10n.themeForest;
      case MainCardTheme.midnight:
        return l10n.themeMidnight;
      case MainCardTheme.oasis:
        return l10n.themeOasis;
      case MainCardTheme.lavender:
        return l10n.themeLavender;
      case MainCardTheme.cottonCandy:
        return l10n.themeCottonCandy;
      case MainCardTheme.mint:
        return l10n.themeMint;
      case MainCardTheme.peach:
        return l10n.themePeach;
      case MainCardTheme.softBlue:
        return l10n.themeSoftBlue;
      case MainCardTheme.lilac:
        return l10n.themeLilac;
      case MainCardTheme.lemon:
        return l10n.themeLemon;
    }
  }
}
