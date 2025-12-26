import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../savings/data/saving_repository.dart';
import '../../savings/domain/saving_goal.dart';
import 'widgets/deposit_bottom_sheet.dart';

class SavingDetailScreen extends ConsumerWidget {
  final SavingGoal goal;

  const SavingDetailScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific goal to get live updates
    final goalAsync = ref.watch(savingListProvider.select((value) => value.value?.firstWhere((g) => g.id == goal.id, orElse: () => goal)));
    
    final currentGoal = goalAsync ?? goal;
    final progress = (currentGoal.currentAmount / currentGoal.targetAmount).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              context.push('/savings/edit', extra: currentGoal);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (currentGoal.type == SavingType.emergency ? Colors.red : Colors.blue).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                currentGoal.type == SavingType.emergency ? Icons.warning_amber_rounded : Icons.savings,
                size: 48,
                color: currentGoal.type == SavingType.emergency ? Colors.red : Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            
            // Name & Amount
            Text(currentGoal.name, style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(currentGoal.currentAmount),
              style: AppTextStyles.h1.copyWith(fontSize: 36),
            ),
            Text(
              'of ${NumberFormat.compact(locale: 'id_ID').format(currentGoal.targetAmount)} goal',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 16,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentGoal.type == SavingType.emergency ? Colors.red : Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(progress * 100).toStringAsFixed(1)}%', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  '${NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0).format(currentGoal.targetAmount - currentGoal.currentAmount)} left',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDepositSheet(context, currentGoal, isDeposit: false),
                    icon: const Icon(Icons.remove, color: Colors.red),
                    label: const Text('Withdraw'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDepositSheet(context, currentGoal, isDeposit: true),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Deposit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  void _showDepositSheet(BuildContext context, SavingGoal goal, {required bool isDeposit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DepositBottomSheet(goal: goal, isDeposit: isDeposit),
    );
  }
}
