import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'currency_provider.dart';
import 'language_provider.dart';


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
        title: Text('Settings', style: AppTextStyles.h2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('General', style: AppTextStyles.bodyMedium),
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
                      child: const Icon(Icons.currency_exchange, color: AppColors.primary),
                    ),
                    title: Text('Currency', style: AppTextStyles.bodyLarge),
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
                    title: Text('Language', style: AppTextStyles.bodyLarge),
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
              Text('Select Currency', style: AppTextStyles.h2),
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
              Text('Select Language', style: AppTextStyles.h2),
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
