import 'package:flutter/material.dart';

class GamificationStats {
  final int currentStreak;
  final int totalActiveDays;
  final int totalXP;
  final int level;
  final int nextLevelXP; // Total XP needed for next level
  final int currentLevelXP; // XP earned in current level
  final double progress; // 0.0 to 1.0
  final List<GamificationBadge> badges;

  GamificationStats({
    required this.currentStreak,
    required this.totalActiveDays,
    required this.totalXP,
    required this.level,
    required this.nextLevelXP,
    required this.currentLevelXP,
    required this.progress,
    required this.badges,
  });
  
  // Empty state
  factory GamificationStats.empty() {
    return GamificationStats(
      currentStreak: 0,
      totalActiveDays: 0,
      totalXP: 0,
      level: 1,
      nextLevelXP: 500,
      currentLevelXP: 0,
      progress: 0.0,
      badges: [],
    );
  }
}

enum BadgeCategory { consistency, budget, saving, anti, misc }

class GamificationBadge {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final BadgeCategory category;
  final int xpReward;

  GamificationBadge({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    this.category = BadgeCategory.misc,
    required this.xpReward,
  });
}
