import 'package:flutter/material.dart';
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
        child: Image.asset(
          iconPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to a generic icon if image fails
            return Icon(
              Icons.account_balance_wallet,
              size: size,
              color: color ?? Colors.grey,
            );
          },
        ),
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
}
