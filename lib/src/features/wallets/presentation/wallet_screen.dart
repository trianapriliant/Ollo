import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'wallet_provider.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../common_widgets/wallet_icon.dart';
import '../domain/wallet.dart';

import 'widgets/wallet_summary_card.dart';
import '../../../localization/generated/app_localizations.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.myWallets, style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => context.push('/add-wallet'),
          ),
        ],
      ),
      body: walletsAsync.when(
        data: (wallets) {
          if (wallets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.emptyWalletsTitle,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.emptyWalletsMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/add-wallet'),
                    child: Text(AppLocalizations.of(context)!.addWallet),
                  ),
                ],
              ),
            );
          }
          // Group wallets by type
          final groupedWallets = <WalletType, List<Wallet>>{};
          for (var wallet in wallets) {
            groupedWallets.putIfAbsent(wallet.type, () => []).add(wallet);
          }

          // Define sort order
          final typeOrder = [
            WalletType.cash,
            WalletType.bank,
            WalletType.ewallet,
            WalletType.creditCard,
            WalletType.exchange,
            WalletType.other,
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            child: Column(
              children: [
                const WalletSummaryCard(),
                const SizedBox(height: 24),
                
                ...typeOrder.map((type) {
                  final walletsOfType = groupedWallets[type];
                  if (walletsOfType == null || walletsOfType.isEmpty) return const SizedBox.shrink();

                  String groupTitle = '';
                  switch (type) {
                    case WalletType.cash: groupTitle = AppLocalizations.of(context)!.walletTypeCash; break;
                    case WalletType.bank: groupTitle = AppLocalizations.of(context)!.walletTypeBank; break;
                    case WalletType.ewallet: groupTitle = AppLocalizations.of(context)!.walletTypeEWallet; break;
                    case WalletType.creditCard: groupTitle = AppLocalizations.of(context)!.walletTypeCreditCard; break;
                    case WalletType.exchange: groupTitle = AppLocalizations.of(context)!.walletTypeExchange; break;
                    case WalletType.other: groupTitle = AppLocalizations.of(context)!.walletTypeOther; break;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(groupTitle, style: AppTextStyles.h3),
                      ),
                      ...walletsOfType.map((wallet) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => context.push('/wallet-detail', extra: wallet),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                WalletIcon(
                                  iconPath: wallet.iconPath,
                                  size: 24,
                                  backgroundColor: AppColors.accentBlue.withOpacity(0.2),
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(wallet.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                                      Text(wallet.type.name.toUpperCase(), style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.currentBalance,
                                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: Colors.grey),
                                    ),
                                    Text(
                                      ref.watch(currencyProvider).format(wallet.balance),
                                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
