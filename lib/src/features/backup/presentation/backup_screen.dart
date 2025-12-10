import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ollo/src/constants/app_colors.dart';
import 'package:ollo/src/constants/app_text_styles.dart';
import '../application/backup_service.dart';

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
      _statusMessage = "Creating backup...";
      _isError = false;
    });

    try {
      final path = await ref.read(backupServiceProvider).createBackup();
      if (mounted) {
        setState(() {
          _statusMessage = "Backup saved successfully to:\n$path";
          _isError = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Backup created at $path"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = "Failed to create backup: $e";
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
      builder: (context) => AlertDialog(
        title: const Text("⚠️ Warning: Restore Data"),
        content: const Text(
          "Restoring a backup will DELETE ALL current data on this device and replace it with the backup content.\n\nThis action cannot be undone. Are you sure?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Restore", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = "Restoring backup...";
      _isError = false;
    });

    try {
      await ref.read(backupServiceProvider).restoreBackup();
      if (mounted) {
        setState(() {
          _statusMessage = "Backup restored successfully!\nPlease restart the app if data doesn't appear immediately.";
          _isError = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
            content: Text("Restore successful!"),
            backgroundColor: Colors.green,
          ),
        );
         // Optionally pop or go home
         // context.go('/'); 
      }
    } catch (e) {
      if (mounted) {
         setState(() {
          _statusMessage = "Failed to restore backup: $e";
          _isError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Backup & Recovery'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Secure your data by creating a local backup file (JSON). You can restore this file later or on another device.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
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
              title: "Create Backup",
              subtitle: "Export all data to a JSON file",
              icon: Icons.save_alt,
              color: AppColors.primary,
              onTap: _isLoading ? null : _createBackup,
            ),
            
            const SizedBox(height: 16),

            // RESTORE BACKUP BUTTON
            _buildActionButton(
              title: "Restore Backup",
              subtitle: "Import data from a JSON file (Wipes current data)",
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
