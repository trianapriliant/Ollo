import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Available icon styles for the app
enum IconStyle {
  filled,
  outlined,
  rounded,
  sharp,
}

extension IconStyleExtension on IconStyle {
  String get displayName {
    switch (this) {
      case IconStyle.filled:
        return 'Filled';
      case IconStyle.outlined:
        return 'Outlined';
      case IconStyle.rounded:
        return 'Rounded';
      case IconStyle.sharp:
        return 'Sharp';
    }
  }

  String get key {
    switch (this) {
      case IconStyle.filled:
        return 'filled';
      case IconStyle.outlined:
        return 'outlined';
      case IconStyle.rounded:
        return 'rounded';
      case IconStyle.sharp:
        return 'sharp';
    }
  }

  static IconStyle fromKey(String key) {
    switch (key) {
      case 'outlined':
        return IconStyle.outlined;
      case 'rounded':
        return IconStyle.rounded;
      case 'sharp':
        return IconStyle.sharp;
      default:
        return IconStyle.filled;
    }
  }

  /// Get a sample icon to preview this style
  IconData get previewIcon {
    switch (this) {
      case IconStyle.filled:
        return Icons.home;
      case IconStyle.outlined:
        return Icons.home_outlined;
      case IconStyle.rounded:
        return Icons.home_rounded;
      case IconStyle.sharp:
        return Icons.home_sharp;
    }
  }
}

/// Provider for the current icon style
class IconStyleNotifier extends StateNotifier<IconStyle> {
  static const String _prefsKey = 'icon_style';

  IconStyleNotifier() : super(IconStyle.filled) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final styleKey = prefs.getString(_prefsKey) ?? 'filled';
    state = IconStyleExtension.fromKey(styleKey);
  }

  Future<void> setStyle(IconStyle style) async {
    state = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, style.key);
  }
}

final iconStyleProvider = StateNotifierProvider<IconStyleNotifier, IconStyle>((ref) {
  return IconStyleNotifier();
});
