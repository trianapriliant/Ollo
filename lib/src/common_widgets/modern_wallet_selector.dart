import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ollo/src/utils/icon_helper.dart'; // Make sure this path is correct
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../features/wallets/data/wallet_repository.dart';
import '../features/wallets/domain/wallet.dart';
import '../features/settings/presentation/currency_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class ModernWalletSelector extends ConsumerWidget {
  final String? selectedWalletId;
  final ValueChanged<String> onWalletSelected;
  final bool isCompact; // For tighter spaces like "Note" row

  const ModernWalletSelector({
    super.key,
    required this.selectedWalletId,
    required this.onWalletSelected,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletRepositoryProvider.select((repo) => repo.value?.watchWallets()));
    final currencySymbol = ref.watch(currencyProvider).symbol;

    return StreamBuilder<List<Wallet>>(
      stream: walletsAsync ?? const Stream.empty(),
      builder: (context, snapshot) {
        final wallets = snapshot.data ?? [];
        final selectedWallet = wallets.isEmpty
            ? null
            : (selectedWalletId == null
                ? null
                : wallets.firstWhere(
                    (w) => (w.externalId ?? w.id.toString()) == selectedWalletId,
                    orElse: () => wallets.first,
                  ));

        // If generic/empty, show placeholder or first wallet
        final displayWallet = selectedWallet ?? (wallets.isNotEmpty ? wallets.first : null);

        if (displayWallet == null) {
          return const SizedBox.shrink(); 
        }

        return GestureDetector(
          onTap: () => _showWalletPicker(context, wallets, selectedWalletId, onWalletSelected, currencySymbol),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 16,
              vertical: isCompact ? 8 : 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
               boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon removed as per request
                SizedBox(width: isCompact ? 8 : 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayWallet.name,
                        style: isCompact 
                          ? AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)
                          : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isCompact)
                        Text(
                          '$currencySymbol ${displayWallet.balance.toStringAsFixed(0)}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded, 
                  color: AppColors.textSecondary,
                  size: isCompact ? 20 : 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWalletPicker(
    BuildContext context, 
    List<Wallet> wallets, 
    String? currentId, 
    ValueChanged<String> onSelected,
    String currencySymbol,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context)!.selectWallet,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250), // Slightly slower for smoothness
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(24),
              width: double.infinity, 
              constraints: BoxConstraints(
                maxWidth: 320, // Cappped width
                maxHeight: MediaQuery.of(context).size.height * 0.5, // Max 50% height
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selectWallet,
                          style: AppTextStyles.h3.copyWith(fontSize: 18),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 18, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Flexible(
                    child: ListView.builder( // Changed to builder for efficiency
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        final wallet = wallets[index];
                        final id = wallet.externalId ?? wallet.id.toString();
                        final isSelected = id == currentId;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0), // Spacing via padding
                          child: InkWell(
                            onTap: () {
                              onSelected(id);
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withOpacity(0.04) : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Icon removed as per request
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          wallet.name,
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            fontSize: 14,
                                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$currencySymbol ${wallet.balance.toStringAsFixed(0)}',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutCubic.transform(anim1.value), // Smoother, no bounce
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }
}
