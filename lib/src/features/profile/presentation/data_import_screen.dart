import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import '../../profile/application/data_import_service.dart';

class DataImportScreen extends ConsumerStatefulWidget {
  const DataImportScreen({super.key});

  @override
  ConsumerState<DataImportScreen> createState() => _DataImportScreenState();
}

class _DataImportScreenState extends ConsumerState<DataImportScreen> {
  bool _isLoading = false;
  
  Future<void> _handleDownloadTemplate() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(dataImportServiceProvider);
      final path = await service.generateTemplate();
      
      // Share file immediately so user can easily save/open
      await Share.shareXFiles([XFile(path)], text: 'Ollo Import Template');
      
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
               content: Text(AppLocalizations.of(context)!.templateSaved), 
               backgroundColor: Colors.green
            ),
         );
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
         );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleUploadCsv() async {
    setState(() => _isLoading = true);
    try {
      // Pick File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
         type: FileType.custom,
         allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          final service = ref.read(dataImportServiceProvider);
          final res = await service.importCsv(file);
          
          final success = res['success'] as int;
          final failed = res['failed'] as int;
          
          if (mounted) {
             if (failed == 0) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                       content: Text(AppLocalizations.of(context)!.importSuccess(success)), 
                       backgroundColor: Colors.green,
                       duration: const Duration(seconds: 4),
                    ),
                 );
                 context.pop(); // Go back on success
             } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                       content: Text(AppLocalizations.of(context)!.importPartialSuccess(success, failed)), 
                       backgroundColor: Colors.orange,
                       duration: const Duration(seconds: 6),
                    ),
                 );
             }
          }
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
         );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(AppLocalizations.of(context)!.importDataTitle, style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                   const Icon(Icons.info_outline, color: Colors.blue),
                   const SizedBox(width: 12),
                   Expanded(
                     child: Text(
                        AppLocalizations.of(context)!.importInfoText,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.blue[800]),
                     ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Download Template
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _handleDownloadTemplate,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.download, color: AppColors.primary),
                label: Text(
                  AppLocalizations.of(context)!.downloadTemplate,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Upload CSV
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleUploadCsv,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                icon: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.upload_file),
                label: Text(
                  AppLocalizations.of(context)!.uploadCsv,
                  style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
