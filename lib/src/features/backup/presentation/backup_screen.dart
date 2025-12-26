import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ollo/src/constants/app_colors.dart';
import 'package:ollo/src/constants/app_text_styles.dart';
import 'package:permission_handler/permission_handler.dart';
import '../application/backup_service.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _isLoading = false;
  String? _statusMessage;
  bool _isError = false;

  Future<void> _createBackup() async {
    setState(() {
      _isLoading = true;
      _statusMessage = AppLocalizations.of(context)!.creatingBackup;
      _isError = false;
    });

    try {
      // Request permission
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }
      
      // Fallback for older Android
      if (!status.isGranted) {
         if (await Permission.storage.request().isGranted) {
            // Good
         } else {
            // throw Exception("Storage permission required");
            // Just proceed and let it try falling back to app docs
         }
      }

      final path = await ref.read(backupServiceProvider).createBackup();
      if (mounted) {
        setState(() {
          _statusMessage = AppLocalizations.of(context)!.backupSuccess(path);
          _isError = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.backupSuccess(path)), // Using same message
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = AppLocalizations.of(context)!.backupError(e.toString());
          _isError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _restoreBackup() async {
    // Show confirmation dialog first
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon with gradient background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                AppLocalizations.of(context)!.restoreWarningTitle,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Warning Message
              Text(
                AppLocalizations.of(context)!.restoreWarningMessage,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.orange.withOpacity(0.4),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.yesRestore,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = AppLocalizations.of(context)!.restoringBackup;
      _isError = false;
    });

    try {
      await ref.read(backupServiceProvider).restoreBackup();
      if (mounted) {
        setState(() {
          _statusMessage = AppLocalizations.of(context)!.restoreSuccess;
          _isError = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(AppLocalizations.of(context)!.restoreSuccess),
            backgroundColor: Colors.green,
          ),
        );
         // Optionally pop or go home
         // context.go('/'); 
      }
    } catch (e) {
      if (mounted) {
         setState(() {
          _statusMessage = AppLocalizations.of(context)!.restoreError(e.toString());
          _isError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showBackupInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.backup, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.backupContentsTitle,
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Data Section
              Text(
                AppLocalizations.of(context)!.backupDataSection,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildInfoItem(Icons.swap_horiz, AppLocalizations.of(context)!.transactions),
              _buildInfoItem(Icons.account_balance_wallet, AppLocalizations.of(context)!.wallets),
              _buildInfoItem(Icons.category, AppLocalizations.of(context)!.categories),
              _buildInfoItem(Icons.flag, AppLocalizations.of(context)!.budgets),
              _buildInfoItem(Icons.receipt_long, AppLocalizations.of(context)!.bills),
              _buildInfoItem(Icons.repeat, AppLocalizations.of(context)!.recurringTransactions),
              _buildInfoItem(Icons.money_off, AppLocalizations.of(context)!.debts),
              _buildInfoItem(Icons.star, AppLocalizations.of(context)!.wishlist),
              _buildInfoItem(Icons.savings, AppLocalizations.of(context)!.savingGoals),
              _buildInfoItem(Icons.credit_card, AppLocalizations.of(context)!.cards),
              _buildInfoItem(Icons.note, AppLocalizations.of(context)!.smartNotes),
              _buildInfoItem(Icons.person, AppLocalizations.of(context)!.profile),
              
              const Divider(height: 24),
              
              // Settings Section
              Text(
                AppLocalizations.of(context)!.backupSettingsSection,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildInfoItem(Icons.palette, AppLocalizations.of(context)!.colorPalette),
              _buildInfoItem(Icons.style, AppLocalizations.of(context)!.cardAppearance),
              _buildInfoItem(Icons.language, AppLocalizations.of(context)!.appLanguage),
              _buildInfoItem(Icons.mic, AppLocalizations.of(context)!.voiceLanguage),
              _buildInfoItem(Icons.reorder, AppLocalizations.of(context)!.menuOrder),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppLocalizations.of(context)!.gotIt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.backupRecoveryTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.textSecondary),
            onPressed: () => _showBackupInfoDialog(context),
            tooltip: 'Info',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.backupDescription,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 32),
            
            // STATUS CARD
            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: _isError ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isError ? Colors.red : Colors.green,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isError ? Icons.error_outline : Icons.check_circle_outline,
                      color: _isError ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(
                          color: _isError ? Colors.red[900] : Colors.green[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // CREATE BACKUP BUTTON
            _buildActionButton(
              title: AppLocalizations.of(context)!.createBackup,
              subtitle: AppLocalizations.of(context)!.createBackupSubtitle,
              icon: Icons.save_alt,
              color: AppColors.primary,
              onTap: _isLoading ? null : _createBackup,
            ),
            
            const SizedBox(height: 16),

            // RESTORE BACKUP BUTTON
            _buildActionButton(
              title: AppLocalizations.of(context)!.restoreBackup,
              subtitle: AppLocalizations.of(context)!.restoreBackupSubtitle,
              icon: Icons.restore_page,
              color: Colors.orange,
              onTap: _isLoading ? null : _restoreBackup,
              isDestructive: true,
            ),

             if (_isLoading)
               const Padding(
                 padding: EdgeInsets.only(top: 32),
                 child: Center(child: CircularProgressIndicator()),
               ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDestructive ? Colors.red : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                       color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
