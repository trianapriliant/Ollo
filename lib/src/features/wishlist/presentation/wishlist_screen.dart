import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
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
        centerTitle: false,
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
    return Container(
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
                    onPressed: () => _markAsAchieved(context, ref, item),
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
    );
  }

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
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
      await ref.read(wishlistRepositoryProvider).deleteWishlist(item.id);
    }
  }

  Future<void> _markAsAchieved(BuildContext context, WidgetRef ref, Wishlist item) async {
    final updatedItem = item..isCompleted = true;
    await ref.read(wishlistRepositoryProvider).updateWishlist(updatedItem);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dream achieved! Congratulations! 🎉'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
