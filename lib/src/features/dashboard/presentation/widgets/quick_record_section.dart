import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';

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
                Icons.chat_bubble_outline,
                'Chat',
                () => _showComingSoonDialog(
                  context,
                  'AI Chat Assistant',
                  'Chat with Ollo AI to record transactions naturally. "Spent 50k for lunch" is all you need to say!',
                ),
              ),
              const SizedBox(width: 24),
              _buildQuickActionItem(
                Icons.camera_alt_outlined,
                'Scan',
                () => _showComingSoonDialog(
                  context,
                  'Receipt Scanner',
                  'Snap a photo of your receipt and let AI extract the details automatically.',
                ),
              ),
              const SizedBox(width: 24),
              _buildQuickActionItem(
                Icons.mic_none_outlined,
                'Voice',
                () => _showComingSoonDialog(
                  context,
                  'Voice Command',
                  'Just speak to record! "Income 5 million from Salary" and it\'s done.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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

  void _showComingSoonDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.rocket_launch, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Coming Soon', style: AppTextStyles.h3),
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
            child: const Text('Can\'t Wait!'),
          ),
        ],
      ),
    );
  }
}
