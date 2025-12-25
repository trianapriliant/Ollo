import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/transaction.dart';
import '../../budget/data/budget_repository.dart';
import '../../budget/domain/budget.dart';
import '../../savings/data/saving_repository.dart';
import '../../savings/domain/saving_goal.dart';
import '../domain/gamification_stats.dart';

final gamificationProvider = StreamProvider<GamificationStats>((ref) {
  final transactionsStream = ref.watch(transactionStreamProvider.stream);
  final budgetsStream = ref.watch(budgetListProvider.stream);
  final savingsStream = ref.watch(savingListProvider.stream);

  return Rx.combineLatest3(
    transactionsStream,
    budgetsStream,
    savingsStream,
    (List<Transaction> transactions, List<Budget> budgets, List<SavingGoal> savings) {
      
      // --- 1. Streak Logic ---
      final sortedDates = transactions
          .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
          .toSet()
          .toList()
          ..sort((a, b) => b.compareTo(a));

      int currentStreak = 0;
      if (sortedDates.isNotEmpty) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        
        final latest = sortedDates.first;
        if (latest.isAtSameMomentAs(today) || latest.isAtSameMomentAs(yesterday)) {
          currentStreak = 1;
          for (int i = 0; i < sortedDates.length - 1; i++) {
             if (sortedDates[i].difference(sortedDates[i + 1]).inDays == 1) {
               currentStreak++;
             } else {
               break;
             }
          }
        }
      }
      
      // Calculate Active Days of all time
      final totalActiveDays = sortedDates.length;

      // --- 2. Calculate XP ---
      // Base XP: Transactions * 10 + Active * 5
      // Bonus XP for completed goals (+50) and Streaks is added below
      int totalXP = (transactions.length * 10) + (totalActiveDays * 5);
      
      // Bonus XP for completed goals
      final completedGoals = savings.where((s) => s.currentAmount >= s.targetAmount).length;
      totalXP += (completedGoals * 50);

      // Bonus XP for Streaks
      if (currentStreak >= 3) totalXP += 50;
      if (currentStreak >= 7) totalXP += 100;
      if (currentStreak >= 30) totalXP += 500;
      
      const xpPerLevel = 500;
      final level = (totalXP / xpPerLevel).floor() + 1;
      final currentLevelXP = totalXP % xpPerLevel;
      final nextLevelXP = xpPerLevel;
      final progress = currentLevelXP / nextLevelXP;

      // --- 3. Badges Logic ---
      
      // Helper: Check Impulse King (>5 tx/day)
      bool isImpulseKing = false;
      if (transactions.isNotEmpty) {
         Map<String, int> dailyCounts = {};
         for (var t in transactions) {
           final key = t.date.toIso8601String().split('T')[0];
           dailyCounts[key] = (dailyCounts[key] ?? 0) + 1;
           if (dailyCounts[key]! >= 5) {
             isImpulseKing = true;
             break; // optimization
           }
         }
      }

      // Helper: Under Budget? (Simple: Budget exists AND monthly expense < monthly budget)
      // This is approximate as it sums ALL budgets. Refined logic would check per-category.
      // For badge visualization we'll use: Has any budget AND Total Expense < Total budget limit
      bool underBudget = false;
      if (budgets.isNotEmpty) {
          double totalLimit = budgets.fold(0, (sum, b) => sum + b.amount);
          // Calculate monthly expense (rough)
          final now = DateTime.now();
          final monthlyExpense = transactions
              .where((t) => t.type == TransactionType.expense && t.date.month == now.month && t.date.year == now.year)
              .fold(0.0, (sum, t) => sum + t.amount);
          underBudget = monthlyExpense < totalLimit;
      }

      final List<GamificationBadge> allBadges = [];

      // -- Group 1: Consistency --
      allBadges.add(GamificationBadge(
        id: 'first_log', titleKey: 'badgeFirstLogTitle', descriptionKey: 'badgeFirstLogDesc',
        icon: Icons.edit_note, color: Colors.blue, isUnlocked: transactions.isNotEmpty,
        category: BadgeCategory.consistency,
        xpReward: 10,
      ));
      allBadges.add(GamificationBadge(
        id: 'streak_3', titleKey: 'badgeStreak3Title', descriptionKey: 'badgeStreak3Desc',
        icon: Icons.local_fire_department, color: Colors.orangeAccent, isUnlocked: currentStreak >= 3,
        category: BadgeCategory.consistency,
        xpReward: 20,
      ));
      allBadges.add(GamificationBadge(
        id: 'streak_7', titleKey: 'badgeStreak7Title', descriptionKey: 'badgeStreak7Desc',
        icon: Icons.whatshot, color: Colors.deepOrange, isUnlocked: currentStreak >= 7,
        category: BadgeCategory.consistency,
        xpReward: 50,
      ));
      allBadges.add(GamificationBadge(
        id: 'streak_14', titleKey: 'badgeStreak14Title', descriptionKey: 'badgeStreak14Desc',
        icon: Icons.rocket_launch, color: Colors.pink, isUnlocked: currentStreak >= 14,
        category: BadgeCategory.consistency,
        xpReward: 100,
      ));
      allBadges.add(GamificationBadge(
        id: 'streak_30', titleKey: 'badgeStreak30Title', descriptionKey: 'badgeStreak30Desc',
        icon: Icons.diamond, color: Colors.purple, isUnlocked: currentStreak >= 30,
        category: BadgeCategory.consistency,
        xpReward: 200,
      ));
      allBadges.add(GamificationBadge(
        id: 'streak_100', titleKey: 'badgeStreak100Title', descriptionKey: 'badgeStreak100Desc',
        icon: Icons.workspace_premium, color: Colors.amber, isUnlocked: currentStreak >= 100,
        category: BadgeCategory.consistency,
        xpReward: 500,
      ));

      // -- Group 2: Budgeting --
      allBadges.add(GamificationBadge(
        id: 'first_budget', titleKey: 'badgeFirstBudgetTitle', descriptionKey: 'badgeFirstBudgetDesc',
        icon: Icons.pie_chart, color: Colors.teal, isUnlocked: budgets.isNotEmpty,
        category: BadgeCategory.budget,
        xpReward: 20,
      ));
      allBadges.add(GamificationBadge(
        id: 'under_budget', titleKey: 'badgeUnderBudgetTitle', descriptionKey: 'badgeUnderBudgetDesc',
        icon: Icons.savings_outlined, color: Colors.green, isUnlocked: underBudget,
        category: BadgeCategory.budget,
        xpReward: 50,
      ));
      allBadges.add(GamificationBadge(
        id: 'multi_budgeter', titleKey: 'badgeMultiBudgeterTitle', descriptionKey: 'badgeMultiBudgeterDesc',
        icon: Icons.calculate, color: Colors.indigo, isUnlocked: budgets.length >= 3,
        category: BadgeCategory.budget,
        xpReward: 50,
      ));

      // -- Group 3: Savings --
      allBadges.add(GamificationBadge(
        id: 'first_goal', titleKey: 'badgeFirstGoalTitle', descriptionKey: 'badgeFirstGoalDesc',
        icon: Icons.flag_circle, color: Colors.cyan, isUnlocked: savings.isNotEmpty,
        category: BadgeCategory.saving,
        xpReward: 20,
      ));
      allBadges.add(GamificationBadge(
        id: 'goal_completed', titleKey: 'badgeGoalCompletedTitle', descriptionKey: 'badgeGoalCompletedDesc',
        icon: Icons.check_circle, color: Colors.greenAccent, isUnlocked: completedGoals > 0,
        category: BadgeCategory.saving,
        xpReward: 100,
      ));

      // -- Group 4: Anti-Badges (Fun) --
      allBadges.add(GamificationBadge(
        id: 'midnight_checkout', titleKey: 'badgeMidnightCheckoutTitle', descriptionKey: 'badgeMidnightCheckoutDesc',
        icon: Icons.dark_mode, color: Colors.black54, isUnlocked: transactions.any((t) => t.date.hour >= 0 && t.date.hour < 5),
        category: BadgeCategory.anti,
        xpReward: 0,
      ));
      allBadges.add(GamificationBadge(
        id: 'impulse_king', titleKey: 'badgeImpulseKingTitle', descriptionKey: 'badgeImpulseKingDesc',
        icon: Icons.shopping_cart_checkout, color: Colors.redAccent, isUnlocked: isImpulseKing,
        category: BadgeCategory.anti,
        xpReward: 0,
      ));
      
      // Helper: Count unique categories
      int uniqueCategories = transactions.map((t) => t.categoryId).toSet().length;
      
      // Helper: Total Income
      double totalIncome = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);
          
      // Helper: Thrifty (Expense < 50% Income this month)
      bool isThrifty = false;
      if (transactions.isNotEmpty) {
         final now = DateTime.now();
         final monthTxs = transactions.where((t) => t.date.month == now.month && t.date.year == now.year);
         final monthIncome = monthTxs.where((t) => t.type == TransactionType.income).fold(0.0, (sum, t) => sum + t.amount);
         final monthExpense = monthTxs.where((t) => t.type == TransactionType.expense).fold(0.0, (sum, t) => sum + t.amount);
         if (monthIncome > 0) {
           isThrifty = monthExpense < (monthIncome * 0.5);
         }
      }
      
      // -- Group: New Badges Mixed --
      allBadges.add(GamificationBadge(
        id: 'explorer', titleKey: 'badgeExplorerTitle', descriptionKey: 'badgeExplorerDesc',
        icon: Icons.explore, color: Colors.indigoAccent, isUnlocked: uniqueCategories >= 5,
        category: BadgeCategory.misc,
        xpReward: 30, // Medium
      ));
      
      allBadges.add(GamificationBadge(
        id: 'lunch_time', titleKey: 'badgeLunchTimeTitle', descriptionKey: 'badgeLunchTimeDesc',
        icon: Icons.lunch_dining, color: Colors.orange, 
        isUnlocked: transactions.any((t) => t.date.hour >= 11 && t.date.hour < 13),
        category: BadgeCategory.misc,
        xpReward: 10, // Easy
      ));

      allBadges.add(GamificationBadge(
        id: 'big_saver', titleKey: 'badgeBigSaverTitle', descriptionKey: 'badgeBigSaverDesc',
        icon: Icons.account_balance_wallet, color: Colors.green, isUnlocked: totalIncome >= 5000000,
        category: BadgeCategory.saving,
        xpReward: 100, // Hard
      ));
      
      allBadges.add(GamificationBadge(
        id: 'giver', titleKey: 'badgeGiverTitle', descriptionKey: 'badgeGiverDesc',
        icon: Icons.volunteer_activism, color: Colors.pinkAccent, 
        isUnlocked: transactions.where((t) => t.type == TransactionType.transfer).length >= 5,
        category: BadgeCategory.misc,
        xpReward: 50, // Medium
      ));
      
      allBadges.add(GamificationBadge(
        id: 'thrifty', titleKey: 'badgeThriftyTitle', descriptionKey: 'badgeThriftyDesc',
        icon: Icons.percent, color: Colors.tealAccent, isUnlocked: isThrifty,
        category: BadgeCategory.budget,
        xpReward: 50, // Medium
      ));
      
      allBadges.add(GamificationBadge(
        id: 'weekend_binge', titleKey: 'badgeWeekendBingeTitle', descriptionKey: 'badgeWeekendBingeDesc',
        icon: Icons.celebration, color: Colors.purpleAccent, 
        isUnlocked: transactions.any((t) {
            bool isWeekend = t.date.weekday == DateTime.saturday || t.date.weekday == DateTime.sunday;
            if (!isWeekend) return false;
            // Simple check: This transaction exists on weekend. 
            // Complex Logic check (Original req: 5+ txs on A weekend). 
            // Simplified: Just if user HAS 5+ txs total on weekends ever for now? 
            // Or strictly "5 in one weekend".
            // Let's go with "Total 5+ weekend transactions" for simplicity and performance
            return false; 
        }) || transactions.where((t) => t.date.weekday == DateTime.saturday || t.date.weekday == DateTime.sunday).length >= 5,
        category: BadgeCategory.anti, // Maybe fun?
        xpReward: 20,
      ));

      // -- Transaction Milestone Badges --
      allBadges.add(GamificationBadge(
        id: 'tx_50', titleKey: 'badgeTx50Title', descriptionKey: 'badgeTx50Desc',
        icon: Icons.edit_document, color: Colors.lightBlue, isUnlocked: transactions.length >= 50,
        category: BadgeCategory.misc,
        xpReward: 30,
      ));
      allBadges.add(GamificationBadge(
        id: 'tx_100', titleKey: 'badgeTx100Title', descriptionKey: 'badgeTx100Desc',
        icon: Icons.inventory_2, color: Colors.blue, isUnlocked: transactions.length >= 100,
        category: BadgeCategory.misc,
        xpReward: 50,
      ));
      allBadges.add(GamificationBadge(
        id: 'tx_500', titleKey: 'badgeTx500Title', descriptionKey: 'badgeTx500Desc',
        icon: Icons.auto_awesome, color: Colors.deepPurple, isUnlocked: transactions.length >= 500,
        category: BadgeCategory.misc,
        xpReward: 100,
      ));
      allBadges.add(GamificationBadge(
        id: 'tx_1000', titleKey: 'badgeTx1000Title', descriptionKey: 'badgeTx1000Desc',
        icon: Icons.military_tech, color: Colors.amber, isUnlocked: transactions.length >= 1000,
        category: BadgeCategory.misc,
        xpReward: 200,
      ));

      // Existing fun/misc badges
       allBadges.add(GamificationBadge(
        id: 'weekend_warrior', titleKey: 'badgeWeekendWarriorTitle', descriptionKey: 'badgeWeekendWarriorDesc',
        icon: Icons.weekend, color: Colors.teal, 
        isUnlocked: transactions.any((t) => t.date.weekday == DateTime.saturday || t.date.weekday == DateTime.sunday),
        category: BadgeCategory.misc,
        xpReward: 10,
      ));
       allBadges.add(GamificationBadge(
        id: 'early_bird', titleKey: 'badgeEarlyBirdTitle', descriptionKey: 'badgeEarlyBirdDesc',
        icon: Icons.wb_sunny, color: Colors.amber, 
        isUnlocked: transactions.any((t) => t.date.hour >= 5 && t.date.hour <= 8),
        category: BadgeCategory.misc,
        xpReward: 10,
      ));


      return GamificationStats(
        currentStreak: currentStreak,
        totalActiveDays: totalActiveDays,
        totalXP: totalXP,
        level: level,
        nextLevelXP: nextLevelXP,
        currentLevelXP: currentLevelXP,
        progress: progress,
        badges: allBadges,
      );
    },
  );
});
