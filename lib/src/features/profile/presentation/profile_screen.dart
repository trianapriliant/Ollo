import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../profile/domain/user_profile.dart';
import '../../subscription/presentation/premium_provider.dart';
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
                _showDeveloperLoginDialog(context, ref);
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
                // Profile Image
                GestureDetector(
                  onTap: () => _showEditProfileDialog(context, ref, profile),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.accentBlue,
                        backgroundImage: profile.profileImagePath != null
                            ? FileImage(File(profile.profileImagePath!))
                            : null,
                        child: profile.profileImagePath == null
                            ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Name & Email
                Text(profile.name, style: AppTextStyles.h2),
                if (profile.email != null)
                  Text(profile.email!, style: AppTextStyles.bodyMedium),
                
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _showEditProfileDialog(context, ref, profile),
                  child: Text('Edit Profile', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                ),

                const SizedBox(height: 32),
                
                // Premium Status Card
                Consumer(
                  builder: (context, ref, _) {
                    final isPremium = ref.watch(isPremiumProvider);
                    return GestureDetector(
                      onTap: () => _showPremiumDebugDialog(context, ref),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isPremium 
                                ? [const Color(0xFFFFD700), const Color(0xFFFFA500)] // Gold for Premium
                                : [const Color(0xFF4A90E2), const Color(0xFF50E3C2)], // Blue/Teal for Free (Upgrade CTA)
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isPremium ? Colors.orange : Colors.blue).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPremium ? Icons.verified : Icons.star_border,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isPremium ? 'Premium Member' : 'Upgrade to Premium',
                                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isPremium ? 'You have unlimited access!' : 'Unlock all features & remove limits.',
                                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.9)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Future Features Section
                _buildSectionHeader('Future Features'),
                _buildMenuItem(
                  context,
                  icon: Icons.cloud_sync_outlined,
                  title: 'Backup & Recovery',
                  onTap: () => _showComingSoonDialog(context, 'Backup & Recovery', 'Securely backup your data to the cloud and restore it on any device.'),
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.auto_awesome_outlined,
                  title: 'AI Automation',
                  onTap: () => _showComingSoonDialog(context, 'AI Automation', 'Let AI categorize your transactions and provide smart financial insights.'),
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.feedback_outlined,
                  title: 'Feedback & Roadmap',
                  onTap: () => _showComingSoonDialog(context, 'Feedback & Roadmap', 'Vote on new features and share your thoughts with the developer.'),
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.file_download_outlined,
                  title: 'Data Export',
                  onTap: () {
                    // Check premium status later, for now show coming soon or redirect to paywall if implemented
                    // For this task, we treat it as a placeholder for the "house"
                     _showComingSoonDialog(context, 'Data Export', 'Export your financial data to CSV or Excel formats. (Premium Feature)');
                  },
                ),
                const SizedBox(height: 24),

                // Data Management Section
                _buildSectionHeader('Data Management'),
                _buildMenuItem(
                  context,
                  icon: Icons.category,
                  title: 'Categories',
                  onTap: () => context.push('/categories'),
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Wallets',
                  onTap: () => context.go('/wallet'),
                ),
                const SizedBox(height: 24),

                // General Section
                _buildSectionHeader('General'),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => context.push('/settings'),
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => context.push('/help-support'),
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Send Feedback',
                  onTap: () => context.push('/send-feedback'),
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About Ollo',
                  onTap: () => context.push('/about-ollo'),
                ),
                const SizedBox(height: 24),

                // Account Section
                _buildSectionHeader('Account'),
                _buildMenuItem(
                  context,
                  icon: Icons.delete_forever,
                  title: 'Delete Data',
                  onTap: () => _showDeleteDataDialog(context, ref),
                  isDestructive: true,
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {},
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
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

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserProfile profile) {
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final updatedProfile = UserProfile(
                    name: profile.name,
                    email: profile.email,
                    currencyCode: profile.currencyCode,
                    profileImagePath: image.path,
                  )..id = profile.id;
                  
                  await ref.read(userProfileRepositoryProvider.future).then((repo) {
                    repo.updateUserProfile(updatedProfile);
                  });
                  if (context.mounted) Navigator.pop(context); // Close dialog to refresh or show success
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.accentBlue,
                backgroundImage: profile.profileImagePath != null
                    ? FileImage(File(profile.profileImagePath!))
                    : null,
                child: profile.profileImagePath == null
                    ? const Icon(Icons.camera_alt, size: 30, color: AppColors.primary)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email (Optional)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedProfile = UserProfile(
                name: nameController.text,
                email: emailController.text.isEmpty ? null : emailController.text,
                currencyCode: profile.currencyCode,
                profileImagePath: profile.profileImagePath,
              )..id = profile.id;

              await ref.read(userProfileRepositoryProvider.future).then((repo) {
                repo.updateUserProfile(updatedProfile);
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red[50] : AppColors.accentBlue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDestructive ? Colors.red : AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
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
                        Navigator.pop(builderContext); // Close confirmation dialog
                        await _performDeleteData(parentContext, ref); // Use stable parent context
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
      // Show loading
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
        
        // Clear Wallets and Categories (Factory Reset)
        await isar.wallets.clear();
        await isar.categorys.clear();
        
        // Re-seed default data immediately in the same transaction
        await isar.wallets.put(defaultWallet);
        await isar.categorys.putAll(defaultCategories);
        
        // Keep UserProfile
      });
      
      // No need to call seedWallets/seedCategories separately anymore

      // Close loading
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); 
        
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

  void _showPremiumDebugDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Mode'),
        content: const Text('Set Premium Status manually for testing purposes.'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(isPremiumProvider.notifier).setPremium(false);
              context.pop();
            },
            child: const Text('Set FREE'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(isPremiumProvider.notifier).setPremium(true);
              context.pop();
            },
            child: const Text('Set PREMIUM'),
          ),
        ],
      ),
    );
  }

  void _showDeveloperLoginDialog(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Access'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter developer password',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == '304021') {
                Navigator.pop(context); // Close login dialog
                _showDeveloperOptionsDialog(context, ref);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect password')),
                );
              }
            },
            child: const Text('Enter'),
          ),
        ],
      ),
    );
  }

  void _showDeveloperOptionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.orange),
              title: const Text('Reset Onboarding'),
              subtitle: const Text('Clear onboarding status and return to intro screen.'),
              onTap: () async {
                Navigator.pop(context); // Close dialog
                await ref.read(onboardingRepositoryProvider).resetOnboarding();
                if (context.mounted) {
                   context.go('/onboarding');
                }
              },
            ),
             // Add more options here later if needed (e.g. Splash Screen test)
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
