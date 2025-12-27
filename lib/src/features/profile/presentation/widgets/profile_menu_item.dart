import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/icon_helper.dart';
import '../../../../features/settings/presentation/icon_pack_provider.dart';

class ProfileMenuItem extends ConsumerWidget {
  final String iconName;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.iconName,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconPack = ref.watch(iconPackProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red[50] : AppColors.accentBlue,
            shape: BoxShape.circle,
          ),
          child: IconHelper.getIconWidget(
            iconName,
            color: isDestructive ? Colors.red : AppColors.primary,
            pack: iconPack,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDestructive ? Colors.red : AppColors.textPrimary,
          ),
        ),
        trailing: IconHelper.getIconWidget(
          'chevron_right', 
          color: AppColors.textSecondary,
          pack: iconPack,
        ),
        onTap: onTap,
      ),
    );
  }
}
