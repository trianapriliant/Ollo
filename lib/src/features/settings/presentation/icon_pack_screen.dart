import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'icon_pack_provider.dart';

class IconPackScreen extends ConsumerWidget {
  const IconPackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPack = ref.watch(iconPackProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Icon Pack', style: AppTextStyles.h2),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Choose your preferred icon style. Changes will apply across the entire app.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Icon Pack Options
            _buildIconPackOption(
              context: context,
              ref: ref,
              title: 'Material Icons',
              subtitle: 'Default Flutter icons with clean, modern design',
              pack: IconPack.material,
              currentPack: currentPack,
              previewIcons: [
                const Icon(Icons.wallet, size: 28),
                const Icon(Icons.shopping_bag, size: 28),
                const Icon(Icons.restaurant, size: 28),
                const Icon(Icons.directions_car, size: 28),
                const Icon(Icons.home, size: 28),
              ],
            ),
            const SizedBox(height: 16),
            _buildIconPackOption(
              context: context,
              ref: ref,
              title: 'Iconoir',
              subtitle: 'Modern, minimalist outline icons',
              pack: IconPack.iconoir,
              currentPack: currentPack,
              previewIcons: [
                iconoir.Wallet(width: 28, height: 28, color: Colors.grey[700]),
                iconoir.ShoppingBag(width: 28, height: 28, color: Colors.grey[700]),
                iconoir.Cutlery(width: 28, height: 28, color: Colors.grey[700]),
                iconoir.Car(width: 28, height: 28, color: Colors.grey[700]),
                iconoir.Home(width: 28, height: 28, color: Colors.grey[700]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconPackOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required IconPack pack,
    required IconPack currentPack,
    required List<Widget> previewIcons,
  }) {
    final isSelected = currentPack == pack;

    return GestureDetector(
      onTap: () {
        ref.read(iconPackProvider.notifier).setIconPack(pack);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Icon Preview
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: previewIcons,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
