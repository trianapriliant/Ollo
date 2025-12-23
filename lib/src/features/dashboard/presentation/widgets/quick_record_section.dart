import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../quick_record/presentation/quick_record_modal.dart';
import '../../../subscription/presentation/premium_provider.dart';
import '../../../subscription/presentation/widgets/premium_gate_widget.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../transactions/domain/transaction.dart';

class QuickRecordSection extends ConsumerWidget {
  const QuickRecordSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final isVip = ref.watch(isVipProvider);
    final hasPremiumAccess = isPremium || isVip;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.quickRecord, style: AppTextStyles.h2),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Chat - Free feature
              _buildQuickActionItem(
                context,
                ref,
                Icons.chat_bubble_outline,
                AppLocalizations.of(context)!.chatAction,
                'chat',
                isPremiumFeature: false,
                hasPremiumAccess: hasPremiumAccess,
              ),
              const SizedBox(width: 24),
              // Scan - Premium feature
              _buildQuickActionItem(
                context,
                ref,
                Icons.camera_alt_outlined,
                AppLocalizations.of(context)!.scanAction,
                'scan',
                isPremiumFeature: true,
                hasPremiumAccess: hasPremiumAccess,
              ),
              const SizedBox(width: 24),
              // Voice - Premium feature (flagship)
              _buildQuickActionItem(
                context,
                ref,
                Icons.mic_none_outlined,
                AppLocalizations.of(context)!.voiceAction,
                'voice',
                isPremiumFeature: true,
                hasPremiumAccess: hasPremiumAccess,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    String label,
    String mode, {
    required bool isPremiumFeature,
    required bool hasPremiumAccess,
  }) {
    final isLocked = isPremiumFeature && !hasPremiumAccess;

    return GestureDetector(
      onTap: () async {
        // If locked, navigate to premium screen
        if (isLocked) {
          context.push('/premium');
          return;
        }

        final result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: QuickRecordModal(initialMode: mode),
          ),
        );

        if (result is Transaction && context.mounted) {
          context.push('/add-transaction', extra: result);
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey[200] : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: isLocked ? Colors.grey : AppColors.primary,
                ),
              ),
              // Premium badge for locked features
              if (isLocked)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isLocked ? Colors.grey : null,
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: 4),
                const Icon(Icons.lock, size: 12, color: Color(0xFFFFD700)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
