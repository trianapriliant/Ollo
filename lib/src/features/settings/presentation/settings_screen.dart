import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'currency_provider.dart';
import 'language_provider.dart';
import 'voice_language_provider.dart';
import '../../../localization/generated/app_localizations.dart';
import '../../wallets/application/wallet_template_service.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(currencyProvider);
    final installedPacksAsync = ref.watch(installedPacksProvider);

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
            
            const SizedBox(height: 24),
            
            // Wallet Icon Packs Section
            Text('Wallet Icons', style: AppTextStyles.bodyMedium),
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
                        color: const Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.downloading, color: Color(0xFF4CAF50)),
                    ),
                    title: Text('Import Icon Pack', style: AppTextStyles.bodyLarge),
                    subtitle: installedPacksAsync.when(
                      data: (packs) => Text(
                        packs.isEmpty ? 'No packs installed' : '${packs.length} pack(s) installed',
                        style: TextStyle(color: packs.isEmpty ? Colors.grey : Colors.green),
                      ),
                      loading: () => const Text('Loading...'),
                      error: (_, __) => const Text('Error'),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _importIconPack(context, ref),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline, color: Color(0xFFF44336)),
                    ),
                    title: Text('Clear Imported Packs', style: AppTextStyles.bodyLarge),
                    subtitle: const Text('Remove all imported icons'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _clearIconPacks(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importIconPack(BuildContext context, WidgetRef ref) async {
    try {
      // Pick ZIP file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        dialogTitle: 'Select Icon Pack ZIP File',
      );
      
      if (result == null || result.files.isEmpty) return;
      
      final filePath = result.files.first.path;
      if (filePath == null) return;
      
      // Show importing dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 24),
                Text('Importing icon pack...'),
              ],
            ),
          ),
        );
      }
      
      // Import the ZIP
      final importResult = await WalletTemplateService.importFromZip(File(filePath));
      
      // Close dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // Refresh providers
      ref.invalidate(installedPacksProvider);
      ref.invalidate(importedTemplatesProvider);
      
      // Show result
      if (context.mounted) {
        if (importResult.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Imported ${importResult.importedCount} templates from "${importResult.packName}"'
                '${importResult.skippedCount > 0 ? ' (${importResult.skippedCount} skipped)' : ''}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Import failed: ${importResult.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close dialog if open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearIconPacks(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Icon Packs?'),
        content: const Text(
          'This will remove all imported wallet icons. '
          'You will need to import them again to use bank/e-wallet templates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await WalletTemplateService.clearImportedTemplates();
      ref.invalidate(installedPacksProvider);
      ref.invalidate(importedTemplatesProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ All imported icon packs cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
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
