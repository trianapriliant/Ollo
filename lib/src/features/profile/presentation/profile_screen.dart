import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/icon_helper.dart';
import '../../settings/presentation/icon_pack_provider.dart';
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
import '../../settings/presentation/bug_report_screen.dart';
import '../../settings/presentation/icon_pack_screen.dart';

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
                            const SizedBox(height: 8),
                            // Modular Header - centered layout
                            ProfileHeader(profile: profile),

                            const SizedBox(height: 12),
                            
                            // Modular Premium Card
                            const PremiumStatusCard(),

                            const SizedBox(height: 16),

                            // Data Management Section (MOVED TO TOP)
                            ProfileMenuSection(title: AppLocalizations.of(context)!.dataManagement),
                            ProfileMenuItem(
                              iconName: 'category',
                              title: AppLocalizations.of(context)!.categories,
                              onTap: () => context.push('/categories'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'wallet',
                              title: AppLocalizations.of(context)!.wallets,
                              onTap: () => context.go('/wallet'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'download', // downloading -> download
                              title: 'Import Wallet Templates',
                              onTap: () => context.push('/import-wallet-templates'),
                            ),
                            const SizedBox(height: 16),

                            // Preferences Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.preferences),
                            ProfileMenuItem(
                              iconName: 'sort', 
                              title: AppLocalizations.of(context)!.customizeMenu,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ReorderMenuScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'palette',
                              title: AppLocalizations.of(context)!.cardAppearance,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CardThemeSelectionScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'color_lens', // color_lens_outlined -> color_lens
                              title: AppLocalizations.of(context)!.colorPalette,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ColorPaletteScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'widgets', // widgets_outlined -> widgets
                              title: 'Icon Pack',
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const IconPackScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Future Features Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.futureFeatures),
                            ProfileMenuItem(
                              iconName: 'cloud_sync', // cloud_sync_outlined -> cloud_sync
                              title: AppLocalizations.of(context)!.backupRecovery,
                              onTap: () => context.push('/backup'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'auto_awesome', // auto_awesome_outlined -> auto_awesome
                              title: AppLocalizations.of(context)!.aiAutomation,
                              onTap: () => _showComingSoonDialog(context, AppLocalizations.of(context)!.aiAutomation, AppLocalizations.of(context)!.comingSoonDesc),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'feedback', // feedback_outlined -> feedback
                              title: AppLocalizations.of(context)!.feedbackRoadmap,
                              onTap: () => context.push('/roadmap'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'file_download', // file_download_outlined -> file_download
                              title: AppLocalizations.of(context)!.dataExport,
                              onTap: () {
                                 context.push('/data-export');
                              },
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'file_upload', // file_upload_outlined -> file_upload
                              title: AppLocalizations.of(context)!.importData,
                              onTap: () => context.push('/data-import'),
                            ),
                            const SizedBox(height: 16),

                            // General Section
                            ProfileMenuSection(title: AppLocalizations.of(context)!.general),
                            ProfileMenuItem(
                              iconName: 'settings',
                              title: AppLocalizations.of(context)!.settings,
                              onTap: () => context.push('/settings'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'help_outline', // help_outline -> help
                              title: AppLocalizations.of(context)!.helpSupport,
                              onTap: () => context.push('/help-support'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'chat_bubble_outline', // chat_bubble_outline -> chat_bubble
                              title: AppLocalizations.of(context)!.sendFeedback,
                              onTap: () => context.push('/send-feedback'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'bug_report', // bug_report_outlined -> bug_report
                              title: AppLocalizations.of(context)!.bugReport,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const BugReportScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'info_outline', // info_outline -> info
                              title: AppLocalizations.of(context)!.aboutOllo,
                              onTap: () => context.push('/about-ollo'),
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'history',
                              title: AppLocalizations.of(context)!.updateLog ?? 'Update Log',
                              onTap: () => context.push('/update-log'),
                            ),
                            const SizedBox(height: 16),

                            // Account Section (MOVED TO BOTTOM)
                            ProfileMenuSection(title: AppLocalizations.of(context)!.account),
                            ProfileMenuItem(
                              iconName: 'delete_forever',
                              title: AppLocalizations.of(context)!.deleteData,
                              onTap: () => _showDeleteDataDialog(context, ref),
                              isDestructive: true,
                            ),
                            const SizedBox(height: 8),
                            ProfileMenuItem(
                              iconName: 'logout',
                              title: AppLocalizations.of(context)!.logout,
                              onTap: () => _showLogoutDialog(context),
                              isDestructive: true,
                            ),

                            
                            const SizedBox(height: 24),
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
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rocket Icon with gradient background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Consumer(
                  builder: (context, ref, _) => IconHelper.getIconWidget(
                    'rocket', // rocket_launch_rounded -> rocket
                    color: Colors.white,
                    size: 32,
                    pack: ref.watch(iconPackProvider),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Coming Soon Title
              Text(
                AppLocalizations.of(context)!.comingSoon,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Feature Title
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.cantWait,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Exit Icon with gradient background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Consumer(
                    builder: (context, ref, _) => IconHelper.getIconWidget(
                    'logout', // exit_to_app_rounded -> logout
                    color: Colors.white,
                    size: 32,
                    pack: ref.watch(iconPackProvider),
                  )
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                AppLocalizations.of(context)!.exitAppTitle,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                AppLocalizations.of(context)!.exitAppConfirm,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.deepOrange.withOpacity(0.4),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.logout,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
          final confirmationText = AppLocalizations.of(parentContext)!.deleteDataConfirmationText;
          final isMatch = controller.text == confirmationText;
          
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning Icon with gradient background
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade400, Colors.red.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    AppLocalizations.of(parentContext)!.deleteAllData,
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Description
                  Text(
                    AppLocalizations.of(parentContext)!.deleteAllDataConfirm(confirmationText),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirmation TextField
                  TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                      hintText: confirmationText,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(builderContext),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(parentContext)!.cancel,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isMatch 
                              ? () async {
                                  Navigator.pop(builderContext); 
                                  await _performDeleteData(parentContext, ref); 
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.red.withOpacity(0.3),
                            disabledForegroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: isMatch ? 4 : 0,
                            shadowColor: Colors.red.withOpacity(0.4),
                          ),
                          child: Text(
                            AppLocalizations.of(parentContext)!.deleteData,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
