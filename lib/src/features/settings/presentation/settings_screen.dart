import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'reorder_menu_screen.dart';
import 'card_theme_selection_screen.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'currency_provider.dart';
import 'language_provider.dart';
import '../../../localization/generated/app_localizations.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(AppLocalizations.of(context)!.settings, style: AppTextStyles.h2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.general, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.grid_view_rounded, color: AppColors.primary),
                    ),
                    title: Text(AppLocalizations.of(context)!.customizeMenu, style: AppTextStyles.bodyLarge),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReorderMenuScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.palette, color: AppColors.primary),
                    ),
                    title: Text(AppLocalizations.of(context)!.cardAppearance, style: AppTextStyles.bodyLarge),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CardThemeSelectionScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.currency_exchange, color: AppColors.primary),
                    ),
                    title: Text(AppLocalizations.of(context)!.currency, style: AppTextStyles.bodyLarge),
                    subtitle: Text('${currentCurrency.name} (${currentCurrency.symbol})'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showCurrencyPicker(context, ref),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.language, color: AppColors.primary),
                    ),
                    title: Text(AppLocalizations.of(context)!.language, style: AppTextStyles.bodyLarge),
                    subtitle: Consumer(
                      builder: (context, ref, _) {
                        final language = ref.watch(languageProvider);
                        return Text(language.name);
                      },
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showLanguagePicker(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.selectCurrency, style: AppTextStyles.h2),
              const SizedBox(height: 16),
              ...availableCurrencies.map((currency) {
                return ListTile(
                  leading: Text(currency.symbol, style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                  title: Text(currency.name, style: AppTextStyles.bodyLarge),
                  subtitle: Text(currency.code),
                  onTap: () {
                    ref.read(currencyProvider.notifier).setCurrency(currency);
                    context.pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.selectLanguage, style: AppTextStyles.h2),
              const SizedBox(height: 16),
              ...AppLanguage.values.map((language) {
                return ListTile(
                  leading: Text(language.code.toUpperCase(), style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                  title: Text(language.name, style: AppTextStyles.bodyLarge),
                  onTap: () {
                    ref.read(languageProvider.notifier).setLanguage(language);
                    context.pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }


}
