import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum ConfirmDialogType { delete, warning, info, success }

class ModernConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? secondaryMessage;
  final String confirmText;
  final String cancelText;
  final ConfirmDialogType type;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ModernConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.secondaryMessage,
    required this.confirmText,
    required this.cancelText,
    this.type = ConfirmDialogType.warning,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getTypeConfig();
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: config.color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: config.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                color: config.color,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Secondary message (warning box)
            if (secondaryMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        secondaryMessage!,
                        style: TextStyle(color: Colors.amber[800], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: onCancel ?? () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm ?? () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _TypeConfig _getTypeConfig() {
    switch (type) {
      case ConfirmDialogType.delete:
        return _TypeConfig(
          color: Colors.red,
          icon: Icons.delete_outline_rounded,
        );
      case ConfirmDialogType.warning:
        return _TypeConfig(
          color: Colors.amber,
          icon: Icons.warning_amber_rounded,
        );
      case ConfirmDialogType.info:
        return _TypeConfig(
          color: Colors.blue,
          icon: Icons.info_outline_rounded,
        );
      case ConfirmDialogType.success:
        return _TypeConfig(
          color: Colors.green,
          icon: Icons.check_circle_outline_rounded,
        );
    }
  }
}

class _TypeConfig {
  final Color color;
  final IconData icon;

  _TypeConfig({required this.color, required this.icon});
}

/// Helper function to show the modern confirm dialog
Future<bool?> showModernConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? secondaryMessage,
  String? confirmText,
  String? cancelText,
  ConfirmDialogType type = ConfirmDialogType.warning,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ModernConfirmDialog(
      title: title,
      message: message,
      secondaryMessage: secondaryMessage,
      confirmText: confirmText ?? 'Confirm',
      cancelText: cancelText ?? 'Cancel',
      type: type,
    ),
  );
}
