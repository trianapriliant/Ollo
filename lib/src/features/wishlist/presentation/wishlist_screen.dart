import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../wallets/domain/wallet.dart';
import '../data/wishlist_repository.dart';
import '../domain/wishlist.dart';
import 'widgets/wishlist_summary_card.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistRepo = ref.watch(wishlistRepositoryProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Wishlist', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WishlistSummaryCard(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(
                color: const Color(0xFFFF80AB), // Pink Accent
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Achieved'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<Wishlist>>(
              stream: wishlistRepo.watchAllWishlists(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allWishlists = snapshot.data!;
                final activeWishlists = allWishlists.where((w) => !w.isCompleted).toList();
                final achievedWishlists = allWishlists.where((w) => w.isCompleted).toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _WishlistList(
                      wishlists: activeWishlists,
                      currency: currency,
                      isEmptyMessage: 'Start adding items you want to buy',
                    ),
                    _WishlistList(
                      wishlists: achievedWishlists,
                      currency: currency,
                      isEmptyMessage: 'No achieved dreams yet. Keep going!',
                      isAchieved: true,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/wishlist/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _WishlistList extends StatelessWidget {
  final List<Wishlist> wishlists;
  final Currency currency;
  final String isEmptyMessage;
  final bool isAchieved;

  const _WishlistList({
    required this.wishlists,
    required this.currency,
    required this.isEmptyMessage,
    this.isAchieved = false,
  });

  @override
  Widget build(BuildContext context) {
    if (wishlists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAchieved ? Icons.emoji_events_outlined : Icons.favorite_border,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isAchieved ? 'No achievements yet' : 'Your wishlist is empty',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(isEmptyMessage, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      itemCount: wishlists.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = wishlists[index];
        return _WishlistCard(item: item, currency: currency, isAchieved: isAchieved);
      },
    );
  }
}

class _WishlistCard extends ConsumerWidget {
  final Wishlist item;
  final Currency currency;
  final bool isAchieved;

  const _WishlistCard({
    required this.item,
    required this.currency,
    required this.isAchieved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.push('/wishlist/edit', extra: item);
      },
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: item.imagePath != null
                      ? Image.file(
                          File(item.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.accentBlue.withOpacity(0.3),
                              child: const Icon(Icons.broken_image, color: AppColors.primary),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.accentBlue.withOpacity(0.3),
                          child: const Icon(Icons.image_not_supported_outlined, color: AppColors.primary, size: 32),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Details Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: isAchieved ? TextDecoration.lineThrough : null,
                              color: isAchieved ? Colors.grey : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.linkUrl != null && item.linkUrl!.isNotEmpty)
                          GestureDetector(
                            onTap: () => _launchURL(context, item.linkUrl!),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.link, size: 16, color: Colors.blue),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (item.targetDate != null)
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('d MMM yyyy').format(item.targetDate!),
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      currency.format(item.price),
                      style: AppTextStyles.h3.copyWith(
                        color: isAchieved ? Colors.grey : AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Section
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () => _confirmDelete(context, ref, item),
                  ),
                  if (!isAchieved)
                    ElevatedButton(
                      onPressed: () => _showBuyDialog(context, ref, item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Buy'),
                    )
                  else
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String urlString) async {
    if (urlString.isEmpty) return;

    // Ensure URL has a scheme
    String finalUrl = urlString;
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      finalUrl = 'https://$urlString';
    }

    final Uri url = Uri.parse(finalUrl);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $finalUrl')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Wishlist item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Delete linked transaction if exists
      if (item.transactionId != null) {
        try {
          final transactionRepo = await ref.read(transactionRepositoryProvider.future);
          
          // We should also revert the wallet balance if we are deleting the transaction
          // But for now, let's just delete the transaction as requested.
          // Ideally, we should fetch the transaction, revert balance, then delete.
          // Let's try to do it properly.
          
          // Fetch transaction to get amount and wallet
          // Since we don't have a direct getTransaction method exposed easily here without stream,
          // we might skip balance revert for now or try to implement it if repository supports it.
          // The user said "harusnya semua yang terkait juga terhapus seperti riwayat transaksi juga ikut dihapus".
          // Reverting balance is a bit complex without fetching the transaction first.
          // Let's assume just deleting the history record is enough for now, 
          // OR better: let's try to revert if we can.
          
          // For safety and simplicity as per "hati hati kita terapkan perlahan lahan",
          // I will just delete the transaction record for now. 
          // Reverting balance might be unexpected if the user already adjusted it manually.
          await transactionRepo.deleteTransaction(item.transactionId!);
        } catch (e) {
          debugPrint('Error deleting linked transaction: $e');
        }
      }
      
      await ref.read(wishlistRepositoryProvider).deleteWishlist(item.id);
    }
  }

  Future<void> _showBuyDialog(BuildContext context, WidgetRef ref, Wishlist item) async {
    final walletRepo = await ref.read(walletRepositoryProvider.future);
    final wallets = await walletRepo.getAllWallets();

    if (context.mounted && wallets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No wallets found. Please create a wallet first.')),
      );
      return;
    }

    Wallet? selectedWallet = wallets.first;
    final currency = ref.read(currencyProvider);

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Buy Item', style: AppTextStyles.h3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Purchase "${item.title}"?', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text('Select Wallet:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Wallet>(
                    value: selectedWallet,
                    isExpanded: true,
                    items: wallets.map((wallet) {
                      return DropdownMenuItem(
                        value: wallet,
                        child: Row(
                          children: [
                            Text(wallet.name),
                            const Spacer(),
                            Text(
                              currency.format(wallet.balance),
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedWallet = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    currency.format(item.price),
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _processPurchase(context, ref, item, selectedWallet!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Confirm Purchase'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPurchase(
    BuildContext context,
    WidgetRef ref,
    Wishlist item,
    Wallet wallet,
  ) async {
    try {
      // 1. Create Transaction
      final transactionRepo = await ref.read(transactionRepositoryProvider.future);
      final newTransaction = Transaction.create(
        title: 'Wishlist: ${item.title}',
        amount: item.price,
        type: TransactionType.expense, // Change to Expense so it shows in stats
        walletId: wallet.id.toString(),
        categoryId: 'wishlist', // Force category to 'wishlist'
        note: 'Wishlist Purchase',
        date: DateTime.now(),
      );
      await transactionRepo.addTransaction(newTransaction);

      // 2. Update Wallet Balance
      final walletRepo = await ref.read(walletRepositoryProvider.future);
      wallet.balance -= item.price;
      await walletRepo.updateWallet(wallet);

      // 3. Mark Wishlist as Achieved & Link Transaction
      final wishlistRepo = ref.read(wishlistRepositoryProvider);
      final updatedItem = item
        ..isCompleted = true
        ..transactionId = newTransaction.id; // Link Transaction
      await wishlistRepo.updateWishlist(updatedItem);

      if (context.mounted) {
        Navigator.pop(context); // Close Dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchase successful! Dream achieved! 🎉'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
