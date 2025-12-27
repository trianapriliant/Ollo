import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../savings/data/saving_repository.dart';
import '../../savings/domain/saving_goal.dart';
import '../../savings/domain/saving_log.dart';
import '../../../localization/generated/app_localizations.dart';
import 'add_edit_saving_screen.dart';

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> {
  bool _sortByProgress = false;

  List<SavingGoal> _sortSavings(List<SavingGoal> savings) {
    if (!_sortByProgress) return savings;
    final sorted = List<SavingGoal>.from(savings);
    sorted.sort((a, b) {
      final progressA = a.currentAmount / a.targetAmount;
      final progressB = b.currentAmount / b.targetAmount;
      return progressB.compareTo(progressA); // High to low
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final savingsAsync = ref.watch(savingListProvider);
    final currency = ref.watch(currencyProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.savings, style: AppTextStyles.h2),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'home') {
                context.go('/home');
              }
              if (value == 'sort_progress') {
                setState(() => _sortByProgress = !_sortByProgress);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_sortByProgress ? l10n.sortByProgress : 'Sort cleared'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'sort_progress',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _sortByProgress 
                            ? Colors.green.withOpacity(0.2)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.trending_up, size: 18, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.sortByProgress, style: AppTextStyles.bodyMedium),
                    if (_sortByProgress) ...[
                      const Spacer(),
                      const Icon(Icons.check, size: 18, color: Colors.green),
                    ],
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'home',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.home, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: savingsAsync.when(
        data: (savings) {
          final sortedSavings = _sortSavings(savings);
          final totalSavings = sortedSavings.fold<double>(0, (sum, item) => sum + item.currentAmount);

          // Calculate Growth
          return FutureBuilder<List<SavingLog>>(
            future: ref.read(savingRepositoryProvider).getAllLogs(),
            builder: (context, snapshot) {
              final logs = snapshot.data ?? [];
              final now = DateTime.now();
              final startOfMonth = DateTime(now.year, now.month, 1);
              
              double netFlowThisMonth = 0;
              for (var log in logs) {
                if (log.date.isAfter(startOfMonth)) {
                  if (log.type == SavingLogType.deposit || log.type == SavingLogType.interest) {
                    netFlowThisMonth += log.amount;
                  } else if (log.type == SavingLogType.withdraw) {
                    netFlowThisMonth -= log.amount;
                  }
                }
              }

              final startBalance = totalSavings - netFlowThisMonth;
              double growthPercent = 0;
              if (startBalance > 0) {
                growthPercent = (netFlowThisMonth / startBalance) * 100;
              } else if (netFlowThisMonth > 0) {
                growthPercent = 100; // If started from 0 and added money, treat as 100% growth (or handle differently)
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Big Summary Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.totalSavings,
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currency.format(totalSavings),
                              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        growthPercent >= 0 ? Icons.trending_up : Icons.trending_down,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${growthPercent >= 0 ? '+' : ''}${l10n.growthThisMonth(growthPercent.toStringAsFixed(1))}',
                                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Text(l10n.financialBuckets, style: AppTextStyles.h3),
                      const SizedBox(height: 16),

                      if (sortedSavings.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Column(
                              children: [
                                Icon(Icons.savings_outlined, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text(l10n.noSavingsYet, style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey)),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sortedSavings.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final goal = sortedSavings[index];
                            return _buildSavingItem(context, goal, currency);
                          },
                        ),
                      const SizedBox(height: 80), // Bottom padding for FAB
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'savings_fab',
        onPressed: () {
          context.push('/savings/add');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSavingItem(BuildContext context, SavingGoal goal, Currency currency) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final isCompleted = progress >= 1.0;

    return InkWell(
      onTap: () => context.push('/saving-detail', extra: goal),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (goal.type == SavingType.emergency ? Colors.red : Colors.blue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    goal.type == SavingType.emergency ? Icons.warning_amber_rounded : Icons.savings,
                    color: goal.type == SavingType.emergency ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        goal.type.name.toUpperCase(),
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currency.format(goal.currentAmount),
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'of ${currency.format(goal.targetAmount)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : (goal.type == SavingType.emergency ? Colors.red : Colors.blue),
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
