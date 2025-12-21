import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../localization/generated/app_localizations.dart';
import 'dart:io';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../profile/data/user_profile_repository.dart';
import '../domain/gamification_stats.dart';
import '../application/gamification_provider.dart';


class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final statsAsync = ref.watch(gamificationProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 4),
            // Profile Header
            profileAsync.when(
              data: (profile) => _buildProfileHeader(
                context,
                profile.name, 
                profile.profileImagePath, 
                statsAsync.value?.level ?? 1,
                statsAsync.value?.progress ?? 0.0,
                statsAsync.value?.currentLevelXP ?? 0,
                statsAsync.value?.nextLevelXP ?? 500,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => _buildProfileHeader(context, 'User', null, 1, 0.0, 0, 500),
            ),
            
            const SizedBox(height: 32),
            
            // Tab Section (Badges, History, Stats)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    l10n.currentStreak, 
                    '${statsAsync.value?.currentStreak ?? 0} ${l10n.days}', 
                    Icons.local_fire_department, 
                    Colors.orange
                  ),
                  _buildStatCard(
                    l10n.totalActive, 
                    '${statsAsync.value?.totalActiveDays ?? 0} ${l10n.days}', 
                    Icons.calendar_today, 
                    Colors.blue
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Badges Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.achievements,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${statsAsync.value?.totalXP ?? 0} XP',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  statsAsync.when(
                    data: (stats) => _buildBadgesGrid(context, stats.badges),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('Failed to load badges'),
                  ),
                ],
              ),
            ),
             const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String? imagePath, int level, double progress, int currentXP, int nextXP) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Progress Ring
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: progress, 
                strokeWidth: 4,
                backgroundColor: AppColors.accentBlue.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: imagePath != null
                    ? DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover)
                    : null,
                color: AppColors.accentBlue,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
               child: imagePath == null
                  ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                  : null,
            ),
            // Rank Badge
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '${l10n.level} $level',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          _getLevelTitle(context, level),
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currentXP / $nextXP XP',
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  String _getLevelTitle(BuildContext context, int level) {
    final l10n = AppLocalizations.of(context)!;
    if (level < 5) return l10n.levelRookie;
    if (level < 10) return l10n.levelNovice;
    if (level < 20) return l10n.levelBudgetWarrior;
    if (level < 30) return l10n.levelMoneyNinja;
    if (level < 50) return l10n.levelFinanceSensei;
    return l10n.levelWealthTycoon;
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesGrid(BuildContext context, List<GamificationBadge> badges) {
    // Helper to filter badges by category
    List<GamificationBadge> getBadges(BadgeCategory cat) => badges.where((b) => b.category == cat).toList();

    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBadgeSection(context, l10n.badgeSectionConsistency, getBadges(BadgeCategory.consistency)),
        _buildBadgeSection(context, l10n.badgeSectionBudget, getBadges(BadgeCategory.budget)),
        _buildBadgeSection(context, l10n.badgeSectionSaving, getBadges(BadgeCategory.saving)),
        _buildBadgeSection(context, l10n.badgeSectionMisc, [...getBadges(BadgeCategory.misc), ...getBadges(BadgeCategory.anti)]),
      ],
    );
  }

  Widget _buildBadgeSection(BuildContext context, String title, List<GamificationBadge> sectionBadges) {
    if (sectionBadges.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: sectionBadges.map((badge) => _buildBadgeItem(context, badge)).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBadgeItem(BuildContext context, GamificationBadge badge) {
    return Container(
      width: 100, // Fixed width for grid feel
      child: Column(
        children: [
          Tooltip(
            message: _getLocalizedBadgeDescription(context, badge.descriptionKey), // Helper needed? Or mapping?
            // Actually, wait, AppLocalizations getter is dynamic. We can't access property by string key easily in standard Flutter arb.
            // We need a helper method to map string keys to getters.
             // OR, just use the generated keys directly if we can access the map, but usually we can't.
             // Workaround: We will use a switch case or map for now since we have a defined list of badges.
             // BETTER: Since we control the keys, let's just make a helper function here.
            triggerMode: TooltipTriggerMode.tap,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    gradient: badge.isUnlocked
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [badge.color.withOpacity(0.8), badge.color],
                          )
                        : null,
                    color: badge.isUnlocked ? null : Colors.grey[100],
                    boxShadow: badge.isUnlocked
                        ? [
                            BoxShadow(
                              color: badge.color.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    badge.icon,
                    color: badge.isUnlocked ? Colors.white : Colors.grey[400],
                    size: 32,
                  ),
                ),
                Positioned(
                  bottom: -6,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: badge.isUnlocked ? badge.color : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '${badge.xpReward} XP',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: badge.isUnlocked ? badge.color : Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getLocalizedBadgeTitle(context, badge.titleKey),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: badge.isUnlocked ? FontWeight.w600 : FontWeight.normal,
              color: badge.isUnlocked ? AppColors.textPrimary : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getLocalizedBadgeTitle(BuildContext context, String key) {
     final l10n = AppLocalizations.of(context)!;
     // Map keys to getters manually
     switch (key) {
       case 'badgeFirstStepTitle': return l10n.badgeFirstStepTitle;
       case 'badgeFirstLogTitle': return l10n.badgeFirstLogTitle;
       case 'badgeWeekWarriorTitle': return l10n.badgeWeekWarriorTitle;
       case 'badgeStreak3Title': return l10n.badgeStreak3Title;
       case 'badgeStreak7Title': return l10n.badgeStreak7Title;
       case 'badgeStreak14Title': return l10n.badgeStreak14Title;
       case 'badgeStreak30Title': return l10n.badgeStreak30Title;
       case 'badgeStreak100Title': return l10n.badgeStreak100Title;
       case 'badgeWeeklyLoggerTitle': return l10n.badgeWeeklyLoggerTitle;
       case 'badgeFirstBudgetTitle': return l10n.badgeFirstBudgetTitle;
       case 'badgeUnderBudgetTitle': return l10n.badgeUnderBudgetTitle;
       case 'badgeBudgetMasterTitle': return l10n.badgeBudgetMasterTitle;
       case 'badgeMultiBudgeterTitle': return l10n.badgeMultiBudgeterTitle;
       case 'badgeFirstGoalTitle': return l10n.badgeFirstGoalTitle;
       case 'badgeGoalCompletedTitle': return l10n.badgeGoalCompletedTitle;
       case 'badgeGoalSprintTitle': return l10n.badgeGoalSprintTitle;
       case 'badgeMidnightCheckoutTitle': return l10n.badgeMidnightCheckoutTitle;
       case 'badgeImpulseKingTitle': return l10n.badgeImpulseKingTitle;

       case 'badgeExplorerTitle': return l10n.badgeExplorerTitle;
       case 'badgeLunchTimeTitle': return l10n.badgeLunchTimeTitle;
       case 'badgeBigSaverTitle': return l10n.badgeBigSaverTitle;
       case 'badgeGiverTitle': return l10n.badgeGiverTitle;
       case 'badgeThriftyTitle': return l10n.badgeThriftyTitle;
       case 'badgeWeekendBingeTitle': return l10n.badgeWeekendBingeTitle;
       
       case 'badgeConsistentSaverTitle': return l10n.badgeConsistentSaverTitle;
       case 'badgeBigSpenderTitle': return l10n.badgeBigSpenderTitle;
       case 'badgeSaverTitle': return l10n.badgeSaverTitle;
       case 'badgeNightOwlTitle': return l10n.badgeNightOwlTitle;
       case 'badgeEarlyBirdTitle': return l10n.badgeEarlyBirdTitle;
       case 'badgeWeekendWarriorTitle': return l10n.badgeWeekendWarriorTitle;
       case 'badgeWealthTitle': return l10n.badgeWealthTitle;
       default: return key;
     }
  }

  String _getLocalizedBadgeDescription(BuildContext context, String key) {
     final l10n = AppLocalizations.of(context)!;
     switch (key) {
       case 'badgeFirstStepDesc': return l10n.badgeFirstStepDesc;
       case 'badgeFirstLogDesc': return l10n.badgeFirstLogDesc;
       case 'badgeWeekWarriorDesc': return l10n.badgeWeekWarriorDesc;
       case 'badgeStreak3Desc': return l10n.badgeStreak3Desc;
       case 'badgeStreak7Desc': return l10n.badgeStreak7Desc;
       case 'badgeStreak14Desc': return l10n.badgeStreak14Desc;
       case 'badgeStreak30Desc': return l10n.badgeStreak30Desc;
       case 'badgeStreak100Desc': return l10n.badgeStreak100Desc;
       case 'badgeWeeklyLoggerDesc': return l10n.badgeWeeklyLoggerDesc;
       case 'badgeFirstBudgetDesc': return l10n.badgeFirstBudgetDesc;
       case 'badgeUnderBudgetDesc': return l10n.badgeUnderBudgetDesc;
       case 'badgeBudgetMasterDesc': return l10n.badgeBudgetMasterDesc;
       case 'badgeMultiBudgeterDesc': return l10n.badgeMultiBudgeterDesc;
       case 'badgeFirstGoalDesc': return l10n.badgeFirstGoalDesc;
       case 'badgeGoalCompletedDesc': return l10n.badgeGoalCompletedDesc;
       case 'badgeGoalSprintDesc': return l10n.badgeGoalSprintDesc;
       case 'badgeMidnightCheckoutDesc': return l10n.badgeMidnightCheckoutDesc;
       case 'badgeImpulseKingDesc': return l10n.badgeImpulseKingDesc;

       case 'badgeExplorerDesc': return l10n.badgeExplorerDesc;
       case 'badgeLunchTimeDesc': return l10n.badgeLunchTimeDesc;
       case 'badgeBigSaverDesc': return l10n.badgeBigSaverDesc;
       case 'badgeGiverDesc': return l10n.badgeGiverDesc;
       case 'badgeThriftyDesc': return l10n.badgeThriftyDesc;
       case 'badgeWeekendBingeDesc': return l10n.badgeWeekendBingeDesc;

       case 'badgeConsistentSaverDesc': return l10n.badgeConsistentSaverDesc;
       case 'badgeBigSpenderDesc': return l10n.badgeBigSpenderDesc;
       case 'badgeSaverDesc': return l10n.badgeSaverDesc;
       case 'badgeNightOwlDesc': return l10n.badgeNightOwlDesc;
       case 'badgeEarlyBirdDesc': return l10n.badgeEarlyBirdDesc;
       case 'badgeWeekendWarriorDesc': return l10n.badgeWeekendWarriorDesc;
       case 'badgeWealthDesc': return l10n.badgeWealthDesc;
       default: return key;
     }
  }
}
