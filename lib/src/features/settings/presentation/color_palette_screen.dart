import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../domain/transaction_color_theme.dart';
import '../../../localization/generated/app_localizations.dart';

class ColorPaletteScreen extends ConsumerWidget {
  const ColorPaletteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(colorPaletteProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context)!.colorPalette, style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.colorPalettePreview,
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              // PREVIEW CARD
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPreviewItem(
                      icon: Icons.fastfood,
                      title: 'Lunch',
                      date: 'Today',
                      amount: '- Rp 50.000',
                      color: currentTheme.expenseColor,
                      iconBg: Colors.orange.withOpacity(0.1),
                      iconColor: Colors.orange,
                    ),
                    const Divider(),
                    _buildPreviewItem(
                      icon: Icons.work,
                      title: 'Salary',
                      date: 'Yesterday',
                      amount: '+ Rp 5.000.000',
                      color: currentTheme.incomeColor,
                      iconBg: Colors.green.withOpacity(0.1),
                      iconColor: Colors.green,
                    ),
                    const Divider(),
                    _buildPreviewItem(
                      icon: Icons.swap_horiz,
                      title: 'Transfer to Savings',
                      date: '20 Dec 2024',
                      amount: '- Rp 1.000.000',
                      color: currentTheme.transferColor,
                      iconBg: Colors.blue.withOpacity(0.1),
                      iconColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.colorPaletteSelectTheme,
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),

              // THEME LIST
              ...TransactionTheme.values.map((theme) {
                final isSelected = theme.type == currentTheme.type;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      ref.read(colorPaletteProvider.notifier).setTheme(theme.type);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected 
                            ? Border.all(color: AppColors.primary, width: 2) 
                            : Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : Colors.grey[300],
                            ),
                            child: isSelected 
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Text(theme.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                          const Spacer(),
                          _buildColorDot(theme.incomeColor),
                          const SizedBox(width: 8),
                          _buildColorDot(theme.expenseColor),
                          const SizedBox(width: 8),
                          _buildColorDot(theme.transferColor),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required Color color,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: iconBg,
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              Text(date, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }
}
