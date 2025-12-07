import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../common_widgets/modern_wallet_selector.dart';
import '../../../wallets/presentation/wallet_provider.dart';

class TransactionWalletSelector extends ConsumerWidget {
  final String? selectedWalletId;
  final String? selectedDestinationWalletId;
  final bool isTransfer;
  final Function(String?) onWalletChanged;
  final Function(String?) onDestinationWalletChanged;

  const TransactionWalletSelector({
    super.key,
    required this.selectedWalletId,
    required this.selectedDestinationWalletId,
    required this.isTransfer,
    required this.onWalletChanged,
    required this.onDestinationWalletChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletListProvider);

    return walletsAsync.when(
      data: (wallets) {
        if (wallets.isEmpty) return const Text("No wallets found. Please create one.");

        // NOTE: Parent widget handles data validation and auto-selection initial state logic.
        // This widget focuses on rendering based on passed props.

        if (isTransfer) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    ModernWalletSelector(
                      selectedWalletId: selectedWalletId,
                      onWalletSelected: onWalletChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('To', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    if (wallets.length < 2)
                      const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text("Need 2+ wallets",
                              style: TextStyle(color: Colors.red, fontSize: 12)))
                    else
                      ModernWalletSelector(
                        selectedWalletId: selectedDestinationWalletId,
                        onWalletSelected: onDestinationWalletChanged,
                      ),
                  ],
                ),
              ),
            ],
          );
        }

        // Normal (Non-Transfer) Layout
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wallet', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            ModernWalletSelector(
              selectedWalletId: selectedWalletId,
              onWalletSelected: onWalletChanged,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error loading wallets: $err'),
    );
  }
}
