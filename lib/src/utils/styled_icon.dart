import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/settings/presentation/icon_style_provider.dart';
import 'icon_helper.dart';

/// A styled icon widget that automatically applies the user's chosen icon style.
/// Use this instead of Icon(IconHelper.getIcon(name)) to get automatic style support.
class StyledIcon extends ConsumerWidget {
  final String iconName;
  final double? size;
  final Color? color;

  const StyledIcon(
    this.iconName, {
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(iconStyleProvider);
    final iconData = IconHelper.getIconWithStyle(iconName, style);
    
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}

/// Extension to easily create a StyledIcon from a string
extension StyledIconExtension on String {
  Widget toStyledIcon({double? size, Color? color}) {
    return StyledIcon(this, size: size, color: color);
  }
}
