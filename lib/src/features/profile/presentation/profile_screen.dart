import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../common/data/isar_provider.dart';
import '../../transactions/domain/transaction.dart';
import '../../wallets/domain/wallet.dart';
import '../../recurring/domain/recurring_transaction.dart';
import '../../bills/domain/bill.dart';
import '../../debts/domain/debt.dart';
import '../../wishlist/domain/wishlist.dart';
import '../../smart_notes/domain/smart_note.dart';
import '../../budget/domain/budget.dart';
import '../../savings/domain/saving_goal.dart';
import '../../savings/domain/saving_log.dart';
import '../../categories/domain/category.dart';
import '../../onboarding/data/onboarding_repository.dart';
import 'widgets/developer_options_helper.dart';
import 'widgets/premium_status_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_menu_section.dart';
import '../../profile/application/data_export_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile', style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'developer') {
                DeveloperOptionsHelper.showLoginDialog(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'developer',
                child: Row(
                  children: [
                    Icon(Icons.terminal, size: 18, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Developer Options'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Modular Header
                ProfileHeader(profile: profile),

                const SizedBox(height: 32),
                
                // Modular Premium Card
                const PremiumStatusCard(),

                const SizedBox(height: 32),

                // Future Features Section
                const ProfileMenuSection(title: 'Future Features'),
                ProfileMenuItem(
                  icon: Icons.cloud_sync_outlined,
                  title: 'Backup & Recovery',
                  onTap: () => context.push('/backup'),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.auto_awesome_outlined,
                  title: 'AI Automation',
                  onTap: () => _showComingSoonDialog(context, 'AI Automation', 'Let AI categorize your transactions and provide smart financial insights.'),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.feedback_outlined,
                  title: 'Feedback & Roadmap',
                  onTap: () => context.push('/roadmap'),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.file_download_outlined,
                  title: 'Data Export',
                  onTap: () {
                     context.push('/data-export');
                  },
                ),
                const SizedBox(height: 24),

                // Data Management Section
                const ProfileMenuSection(title: 'Data Management'),
                ProfileMenuItem(
                  icon: Icons.category,
                  title: 'Categories',
                  onTap: () => context.push('/categories'),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Wallets',
                  onTap: () => context.go('/wallet'),
                ),
                const SizedBox(height: 24),

                // General Section
                const ProfileMenuSection(title: 'General'),
                ProfileMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => context.push('/settings'),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => context.push('/help-support'),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Send Feedback',
                  onTap: () => context.push('/send-feedback'),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.info_outline,
                  title: 'About Ollo',
                  onTap: () => context.push('/about-ollo'),
                ),
                const SizedBox(height: 24),

                // Account Section
                const ProfileMenuSection(title: 'Account'),
                ProfileMenuItem(
                  icon: Icons.delete_forever,
                  title: 'Delete Data',
                  onTap: () => _showDeleteDataDialog(context, ref),
                  isDestructive: true,
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {},
                  isDestructive: true,
                ),

                
                const SizedBox(height: 32),
                _buildVersionInfo(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final info = snapshot.data!;
        return Column(
          children: [
            Text(
              'Ollo v${info.version} (Build ${info.buildNumber})',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'by Ollo Labs',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.rocket_launch, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Coming Soon', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: AppTextStyles.bodyMedium),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Can\'t Wait!'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext parentContext, WidgetRef ref) {
    final controller = TextEditingController();
    
    showDialog(
      context: parentContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) {
          final isMatch = controller.text == 'Delete Data';
          
          return AlertDialog(
            title: const Text('Delete All Data?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This action will permanently delete ALL your transactions, wallets, budgets, and notes. This cannot be undone.\n\nTo confirm, please type "Delete Data" below:',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Delete Data',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(builderContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isMatch 
                    ? () async {
                        Navigator.pop(builderContext); 
                        await _performDeleteData(parentContext, ref); 
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.red.withOpacity(0.3),
                  disabledForegroundColor: Colors.white.withOpacity(0.5),
                ),
                child: const Text('Delete Data'),
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> _performDeleteData(BuildContext context, WidgetRef ref) async {
    try {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      }

      final isar = await ref.read(isarProvider.future);
      
      await isar.writeTxn(() async {
        await isar.transactions.clear();
        await isar.recurringTransactions.clear();
        await isar.bills.clear();
        await isar.debts.clear();
        await isar.wishlists.clear();
        await isar.smartNotes.clear();
        await isar.budgets.clear();
        await isar.savingGoals.clear();
        await isar.savingLogs.clear();
        
        await isar.wallets.clear();
        await isar.categorys.clear();
        
        await isar.wallets.put(defaultWallet);
        await isar.categorys.putAll(defaultCategories);
      });

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data deleted successfully. Please restart the app.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete data: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
