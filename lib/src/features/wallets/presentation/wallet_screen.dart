import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'wallet_provider.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../common_widgets/wallet_icon.dart';

import 'widgets/wallet_summary_card.dart';

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
        title: Text('My Wallets', style: AppTextStyles.h2),
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
                    'Dompet masih kosong',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yuk tambahkan dompet atau akun bank-mu untuk mulai mencatat! 💳',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/add-wallet'),
                    child: const Text('Tambah Dompet Baru'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: WalletSummaryCard(),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: wallets.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final wallet = wallets[index];
                    return GestureDetector(
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
                            Text(
                              '${ref.watch(currencyProvider).symbol} ${wallet.balance.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
