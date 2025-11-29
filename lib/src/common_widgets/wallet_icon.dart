import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/icon_helper.dart';

class WalletIcon extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Check if it's an asset path
    if (iconPath.startsWith('assets/')) {
      return Container(
        width: size + 16, // Add padding compensation
        height: size + 16,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: _buildAssetIcon(),
      );
    }

    // It's a Material Icon string
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Icon(
        IconHelper.getIcon(iconPath),
        size: size,
        color: color ?? Colors.black,
      ),
    );
  }

  Widget _buildAssetIcon() {
    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        // Optional: Apply color filter if color is provided, 
        // but usually wallet logos have their own colors.
        // colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
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
