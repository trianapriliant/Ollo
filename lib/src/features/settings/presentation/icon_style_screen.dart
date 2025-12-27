import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../localization/generated/app_localizations.dart';
import 'icon_style_provider.dart';

class IconStyleScreen extends ConsumerWidget {
  const IconStyleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStyle = ref.watch(iconStyleProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.iconStyleTitle, style: AppTextStyles.h2),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.palette_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.iconStyleDescription,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Style Options
          ...IconStyle.values.map((style) => _buildStyleOption(
            context, ref, style, currentStyle == style, l10n,
          )),
          
          const SizedBox(height: 32),
          
          // Preview Section
          Text(l10n.iconStylePreview, style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildPreviewGrid(currentStyle),
        ],
      ),
    );
  }

  Widget _buildStyleOption(
    BuildContext context, 
    WidgetRef ref, 
    IconStyle style, 
    bool isSelected,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ref.read(iconStyleProvider.notifier).setStyle(style);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getStyleName(style, l10n)} selected'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            children: [
              // Preview icons
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary.withOpacity(0.2) 
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getPreviewIcon(style, 'home'), 
                        size: 20, 
                        color: isSelected ? AppColors.primary : Colors.grey[700]),
                    const SizedBox(width: 4),
                    Icon(_getPreviewIcon(style, 'star'), 
                        size: 20, 
                        color: isSelected ? AppColors.primary : Colors.grey[700]),
                    const SizedBox(width: 4),
                    Icon(_getPreviewIcon(style, 'favorite'), 
                        size: 20, 
                        color: isSelected ? AppColors.primary : Colors.grey[700]),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Style name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStyleName(style, l10n),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : Colors.black,
                      ),
                    ),
                    Text(
                      _getStyleDescription(style, l10n),
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              // Checkmark
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewGrid(IconStyle style) {
    final previewIcons = [
      ('home', 'Home'),
      ('shopping_bag', 'Shopping'),
      ('favorite', 'Wishlist'),
      ('savings', 'Savings'),
      ('credit_card', 'Cards'),
      ('receipt', 'Bills'),
      ('restaurant', 'Food'),
      ('directions_car', 'Transport'),
      ('medical_services', 'Health'),
      ('movie', 'Entertainment'),
      ('work', 'Work'),
      ('school', 'Education'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: previewIcons.length,
        itemBuilder: (context, index) {
          final (iconName, label) = previewIcons[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPreviewIcon(style, iconName),
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  String _getStyleName(IconStyle style, AppLocalizations l10n) {
    switch (style) {
      case IconStyle.filled:
        return l10n.iconStyleFilled;
      case IconStyle.outlined:
        return l10n.iconStyleOutlined;
      case IconStyle.rounded:
        return l10n.iconStyleRounded;
      case IconStyle.sharp:
        return l10n.iconStyleSharp;
    }
  }

  String _getStyleDescription(IconStyle style, AppLocalizations l10n) {
    switch (style) {
      case IconStyle.filled:
        return l10n.iconStyleFilledDesc;
      case IconStyle.outlined:
        return l10n.iconStyleOutlinedDesc;
      case IconStyle.rounded:
        return l10n.iconStyleRoundedDesc;
      case IconStyle.sharp:
        return l10n.iconStyleSharpDesc;
    }
  }

  IconData _getPreviewIcon(IconStyle style, String iconName) {
    switch (iconName) {
      case 'home':
        switch (style) {
          case IconStyle.filled: return Icons.home;
          case IconStyle.outlined: return Icons.home_outlined;
          case IconStyle.rounded: return Icons.home_rounded;
          case IconStyle.sharp: return Icons.home_sharp;
        }
      case 'star':
        switch (style) {
          case IconStyle.filled: return Icons.star;
          case IconStyle.outlined: return Icons.star_outline;
          case IconStyle.rounded: return Icons.star_rounded;
          case IconStyle.sharp: return Icons.star_sharp;
        }
      case 'favorite':
        switch (style) {
          case IconStyle.filled: return Icons.favorite;
          case IconStyle.outlined: return Icons.favorite_outline;
          case IconStyle.rounded: return Icons.favorite_rounded;
          case IconStyle.sharp: return Icons.favorite_sharp;
        }
      case 'shopping_bag':
        switch (style) {
          case IconStyle.filled: return Icons.shopping_bag;
          case IconStyle.outlined: return Icons.shopping_bag_outlined;
          case IconStyle.rounded: return Icons.shopping_bag_rounded;
          case IconStyle.sharp: return Icons.shopping_bag_sharp;
        }
      case 'savings':
        switch (style) {
          case IconStyle.filled: return Icons.savings;
          case IconStyle.outlined: return Icons.savings_outlined;
          case IconStyle.rounded: return Icons.savings_rounded;
          case IconStyle.sharp: return Icons.savings_sharp;
        }
      case 'credit_card':
        switch (style) {
          case IconStyle.filled: return Icons.credit_card;
          case IconStyle.outlined: return Icons.credit_card_outlined;
          case IconStyle.rounded: return Icons.credit_card_rounded;
          case IconStyle.sharp: return Icons.credit_card_sharp;
        }
      case 'receipt':
        switch (style) {
          case IconStyle.filled: return Icons.receipt;
          case IconStyle.outlined: return Icons.receipt_outlined;
          case IconStyle.rounded: return Icons.receipt_rounded;
          case IconStyle.sharp: return Icons.receipt_sharp;
        }
      case 'restaurant':
        switch (style) {
          case IconStyle.filled: return Icons.restaurant;
          case IconStyle.outlined: return Icons.restaurant_outlined;
          case IconStyle.rounded: return Icons.restaurant_rounded;
          case IconStyle.sharp: return Icons.restaurant_sharp;
        }
      case 'directions_car':
        switch (style) {
          case IconStyle.filled: return Icons.directions_car;
          case IconStyle.outlined: return Icons.directions_car_outlined;
          case IconStyle.rounded: return Icons.directions_car_rounded;
          case IconStyle.sharp: return Icons.directions_car_sharp;
        }
      case 'medical_services':
        switch (style) {
          case IconStyle.filled: return Icons.medical_services;
          case IconStyle.outlined: return Icons.medical_services_outlined;
          case IconStyle.rounded: return Icons.medical_services_rounded;
          case IconStyle.sharp: return Icons.medical_services_sharp;
        }
      case 'movie':
        switch (style) {
          case IconStyle.filled: return Icons.movie;
          case IconStyle.outlined: return Icons.movie_outlined;
          case IconStyle.rounded: return Icons.movie_rounded;
          case IconStyle.sharp: return Icons.movie_sharp;
        }
      case 'work':
        switch (style) {
          case IconStyle.filled: return Icons.work;
          case IconStyle.outlined: return Icons.work_outline;
          case IconStyle.rounded: return Icons.work_rounded;
          case IconStyle.sharp: return Icons.work_sharp;
        }
      case 'school':
        switch (style) {
          case IconStyle.filled: return Icons.school;
          case IconStyle.outlined: return Icons.school_outlined;
          case IconStyle.rounded: return Icons.school_rounded;
          case IconStyle.sharp: return Icons.school_sharp;
        }
      default:
        return Icons.help_outline;
    }
  }
}
