import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../quick_record/presentation/quick_record_modal.dart';

class QuickRecordSection extends StatelessWidget {
  const QuickRecordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Record', style: AppTextStyles.h2),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildQuickActionItem(
                context,
                Icons.chat_bubble_outline,
                'Chat',
                'chat',
              ),
              const SizedBox(width: 24),
              _buildQuickActionItem(
                context,
                Icons.camera_alt_outlined,
                'Scan',
                'scan',
              ),
              const SizedBox(width: 24),
              _buildQuickActionItem(
                context,
                Icons.mic_none_outlined,
                'Voice',
                'voice',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(BuildContext context, IconData icon, String label, String mode) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
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
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
