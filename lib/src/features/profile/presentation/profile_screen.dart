import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../localization/generated/app_localizations.dart';
import '../../settings/presentation/reorder_menu_screen.dart';
import '../../settings/presentation/card_theme_selection_screen.dart';
import '../../settings/presentation/color_palette_screen.dart';

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
        title: Text(AppLocalizations.of(context)!.profile, style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'developer') {
                DeveloperOptionsHelper.showLoginDialog(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'developer',
                child: Row(
                  children: [
                    const Icon(Icons.terminal, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.developerOptions),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Footer Layer (Behind everything)
          Positioned(
            bottom: -20, // Slight offset to hide the bottom edge if needed
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'OLLO',
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 10,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1.0
                    ..color = AppColors.primary.withOpacity(0.1), // Subtle outline
                ),
              ),
            ),
          ),
          
          // Content Layer
          profileAsync.when(
            data: (profile) => LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Container(
                      color: AppColors.background, // Opaque background to act as curtain
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            // Modular Header
                            ProfileHeader(profile: profile),

                            const SizedBox(height: 16),
                            
                            // Modular Premium Card
                            const PremiumStatusCard(),

                            const SizedBox(height: 32),

                            // Future Features Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.futureFeatures),
                            ProfileMenuItem(
                              icon: Icons.cloud_sync_outlined,
                              title: AppLocalizations.of(context)!.backupRecovery,
                              onTap: () => context.push('/backup'),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.auto_awesome_outlined,
                              title: AppLocalizations.of(context)!.aiAutomation,
                              onTap: () => _showComingSoonDialog(context, AppLocalizations.of(context)!.aiAutomation, AppLocalizations.of(context)!.comingSoonDesc),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.feedback_outlined,
                              title: AppLocalizations.of(context)!.feedbackRoadmap,
                              onTap: () => context.push('/roadmap'),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.file_download_outlined,
                              title: AppLocalizations.of(context)!.dataExport,
                              onTap: () {
                                 context.push('/data-export');
                              },
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.file_upload_outlined,
                              title: AppLocalizations.of(context)!.importData,
                              onTap: () => context.push('/data-import'),
                            ),
                            const SizedBox(height: 24),

                            // Data Management Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.dataManagement),
                            ProfileMenuItem(
                              icon: Icons.category,
                              title: AppLocalizations.of(context)!.categories,
                              onTap: () => context.push('/categories'),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.account_balance_wallet,
                              title: AppLocalizations.of(context)!.wallets,
                              onTap: () => context.go('/wallet'),
                            ),
                            const SizedBox(height: 24),

                            // Preferences Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.preferences),
                            ProfileMenuItem(
                              icon: Icons.grid_view_rounded,
                              title: AppLocalizations.of(context)!.customizeMenu,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ReorderMenuScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.palette,
                              title: AppLocalizations.of(context)!.cardAppearance,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CardThemeSelectionScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.color_lens_outlined,
                              title: AppLocalizations.of(context)!.colorPalette,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ColorPaletteScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // General Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.general),
                            ProfileMenuItem(
                              icon: Icons.settings,
                              title: AppLocalizations.of(context)!.settings,
                              onTap: () => context.push('/settings'),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.help_outline,
                              title: AppLocalizations.of(context)!.helpSupport,
                              onTap: () => context.push('/help-support'),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.chat_bubble_outline,
                              title: AppLocalizations.of(context)!.sendFeedback,
                              onTap: () => context.push('/send-feedback'),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.info_outline,
                              title: AppLocalizations.of(context)!.aboutOllo,
                              onTap: () => context.push('/about-ollo'),
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.history,
                              title: AppLocalizations.of(context)!.updateLog ?? 'Update Log',
                              onTap: () => context.push('/update-log'),
                            ),
                            const SizedBox(height: 24),

                            // Account Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.account),
                            ProfileMenuItem(
                              icon: Icons.delete_forever,
                              title: AppLocalizations.of(context)!.deleteData,
                              onTap: () => _showDeleteDataDialog(context, ref),
                              isDestructive: true,
                            ),
                            const SizedBox(height: 16),
                            ProfileMenuItem(
                              icon: Icons.logout,
                              title: AppLocalizations.of(context)!.logout,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.exitAppTitle),
                                    content: Text(AppLocalizations.of(context)!.exitAppConfirm),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close dialog
                                          SystemNavigator.pop(); // Exit app
                                        },
                                        child: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              isDestructive: true,
                            ),

                            
                            const SizedBox(height: 32),
                            _buildVersionInfo(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ],
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
            Text(AppLocalizations.of(context)!.comingSoon, style: AppTextStyles.h3),
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
            child: Text(AppLocalizations.of(context)!.cantWait),
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
          final confirmationText = AppLocalizations.of(parentContext)!.deleteDataConfirmationText;
          final isMatch = controller.text == confirmationText;
          
          return AlertDialog(
            title: Text(AppLocalizations.of(parentContext)!.deleteAllData),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(AppLocalizations.of(parentContext)!.deleteAllDataConfirm(confirmationText)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: confirmationText,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(builderContext),
                child: Text(AppLocalizations.of(parentContext)!.cancel),
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
                child: Text(AppLocalizations.of(parentContext)!.deleteData),
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.dataDeletedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.dataDeleteFailed(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }
}
