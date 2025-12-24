import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'currency_provider.dart';
import 'language_provider.dart';
import 'voice_language_provider.dart';
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
      body: SingleChildScrollView(
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
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mic, color: AppColors.primary),
                    ),
                    title: Text('Voice Input Language', style: AppTextStyles.bodyLarge),
                    subtitle: Consumer(
                      builder: (context, ref, _) {
                        final voiceLang = ref.watch(voiceLanguageProvider);
                        return Text(voiceLang.name);
                      },
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showVoiceLanguagePicker(context, ref),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.selectCurrency,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    final currentCurrency = ref.watch(currencyProvider);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableCurrencies.length,
                      itemBuilder: (context, index) {
                        final currency = availableCurrencies[index];
                        final isSelected = currency == currentCurrency;
                        
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              currency.symbol,
                              style: AppTextStyles.h3.copyWith(
                                color: isSelected ? AppColors.primary : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            currency.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            currency.code,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isSelected ? AppColors.primary.withOpacity(0.7) : Colors.grey[600],
                            ),
                          ),
                          trailing: isSelected 
                              ? Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                              : null,
                          onTap: () {
                            ref.read(currencyProvider.notifier).setCurrency(currency);
                            context.pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.selectLanguage,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    final currentLanguage = ref.watch(languageProvider);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: AppLanguage.values.length,
                      itemBuilder: (context, index) {
                        final language = AppLanguage.values[index];
                        final isSelected = language == currentLanguage;
                        
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              language.code.toUpperCase(),
                              style: AppTextStyles.h3.copyWith(
                                color: isSelected ? AppColors.primary : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            language.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          trailing: isSelected 
                              ? Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                              : null,
                          onTap: () {
                            ref.read(languageProvider.notifier).setLanguage(language);
                            context.pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showVoiceLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Select Voice Language',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    final currentVoiceLang = ref.watch(voiceLanguageProvider);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: VoiceLanguage.values.length,
                      itemBuilder: (context, index) {
                        final language = VoiceLanguage.values[index];
                        final isSelected = language == currentVoiceLang;
                        
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              language.code.split('_').last,
                              style: AppTextStyles.h3.copyWith(
                                color: isSelected ? AppColors.primary : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            language.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          trailing: isSelected 
                              ? Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                              : null,
                          onTap: () {
                            ref.read(voiceLanguageProvider.notifier).setLanguage(language);
                            context.pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
