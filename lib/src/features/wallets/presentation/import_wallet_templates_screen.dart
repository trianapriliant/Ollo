import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../application/wallet_template_service.dart';

class ImportWalletTemplatesScreen extends ConsumerWidget {
  const ImportWalletTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: Text('Import Wallet Templates', style: AppTextStyles.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature Description Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4A90E2).withOpacity(0.1),
                    const Color(0xFF50E3C2).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF4A90E2).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet Icon Packs',
                              style: AppTextStyles.h3.copyWith(
                                color: const Color(0xFF4A90E2),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Customize your wallet icons',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Import custom wallet templates with bank and e-wallet icons. '
                    'Use ZIP files containing icons and a manifest.json file to add '
                    'new wallet templates with their logos.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Imported icons will appear when you add a new wallet.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Installed Packs Status
            Text('Installed Packs', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: installedPacksAsync.when(
                data: (packs) {
                  if (packs.isEmpty) {
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.folder_open, color: Colors.grey[400]),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No packs installed',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Import a ZIP file to get started',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  
                  return Column(
                    children: packs.map((pack) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                pack,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error loading packs'),
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Text('Actions', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.downloading, color: Color(0xFF4CAF50)),
                    ),
                    title: Text('Import Icon Pack', style: AppTextStyles.bodyLarge),
                    subtitle: const Text('Import from ZIP file'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _importIconPack(context, ref),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline, color: Color(0xFFF44336)),
                    ),
                    title: Text('Clear All Packs', style: AppTextStyles.bodyLarge),
                    subtitle: const Text('Remove all imported icons'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _clearIconPacks(context, ref),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ZIP Format Guide
            Text('ZIP File Format', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your ZIP file should contain:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFormatItem('📄', 'manifest.json', 'List of templates with names and icon files'),
                  const SizedBox(height: 8),
                  _buildFormatItem('🖼️', 'Icon files', 'PNG or SVG images for each wallet'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Example manifest.json:',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '{\n  "name": "Indonesian Banks",\n  "templates": [\n    {"name": "BCA", "icon": "bca.png"},\n    {"name": "BRI", "icon": "bri.png"}\n  ]\n}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatItem(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
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
          'You will need to import them again to use custom wallet templates.',
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
}
