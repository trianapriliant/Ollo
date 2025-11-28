import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // User Info Placeholder
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.accentBlue,
                child: Icon(Icons.person, size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text('Norlanda', style: AppTextStyles.h2),
              Text('norlanda@example.com', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 32),

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
                onTap: () => context.go('/wallet'), // Navigate to Wallet tab
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
