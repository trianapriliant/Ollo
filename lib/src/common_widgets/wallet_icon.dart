import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/settings/presentation/icon_pack_provider.dart';
import '../utils/icon_helper.dart';

class WalletIcon extends ConsumerWidget {
  final String iconPath;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const WalletIcon({
    super.key,
    required this.iconPath,
    this.size = 24,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if it's a custom file (user uploaded image or imported icon)
    if (_isCustomFilePath(iconPath)) {
      return Container(
        width: size + 16,
        height: size + 16,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: _buildCustomFileIcon(),
        ),
      );
    }

    // Check if it's an asset path
    if (iconPath.startsWith('assets/')) {
      return Container(
        width: size + 16,
        height: size + 16,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: _buildAssetIcon(),
      );
    }

    // It's a Material Icon string (or Iconoir string)
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: IconHelper.getIconWidget(
        iconPath,
        pack: ref.watch(iconPackProvider),
        size: size,
        color: color ?? Colors.black,
      ),
    );
  }

  /// Check if the path is a custom file path (user uploaded)
  bool _isCustomFilePath(String path) {
    // Custom files are stored with absolute paths or in app documents directory
    if (path.isEmpty) return false;
    if (path.startsWith('assets/')) return false;
    
    // Check common file path patterns
    if (path.startsWith('/') || // Unix/Android absolute path
        path.contains(':\\') || // Windows absolute path
        path.startsWith('file://') || // File URI
        path.contains('/app_flutter/') || // Flutter app documents
        path.contains('Documents') || // iOS documents
        path.contains('data/data/')) { // Android app data
      return true;
    }
    return false;
  }

  /// Build icon from custom file path (local storage)
  /// Supports both SVG and raster images (PNG, JPG)
  Widget _buildCustomFileIcon() {
    final file = File(iconPath);
    
    if (iconPath.toLowerCase().endsWith('.svg')) {
      // Use SvgPicture.file for SVG files from local storage
      return SvgPicture.file(
        file,
        width: size + 8,
        height: size + 8,
        fit: BoxFit.contain,
        placeholderBuilder: (BuildContext context) => _buildErrorIcon(),
      );
    } else {
      // Use Image.file for raster images (PNG, JPG, etc)
      return Image.file(
        file,
        width: size + 8,
        height: size + 8,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
      );
    }
  }

  Widget _buildAssetIcon() {
    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (BuildContext context) => _buildErrorIcon(),
      );
    } else {
      return Image.asset(
        iconPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
      );
    }
  }

  Widget _buildErrorIcon() {
    return Icon(
      Icons.account_balance_wallet,
      size: size,
      color: color ?? Colors.grey,
    );
  }
}
