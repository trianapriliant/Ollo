import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../profile/domain/user_profile.dart';

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
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Send Feedback',
                  onTap: () => _showComingSoonDialog(context, 'Send Feedback', 'We would love to hear your thoughts!'),
                ),
                const SizedBox(height: 24),

                // Account Section
                _buildSectionHeader('Account'),
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
}
