import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../budget/presentation/budget_screen.dart';

class DashboardMenuGrid extends StatelessWidget {
  const DashboardMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.pie_chart_outline,
        label: 'Budget',
        color: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BudgetScreen()),
          );
        },
      ),
      _MenuItem(
        icon: Icons.repeat,
        label: 'Recurring',
        color: Colors.blue,
        onTap: () {
          // TODO: Navigate to Recurring Screen
        },
      ),
      _MenuItem(
        icon: Icons.savings_outlined,
        label: 'Savings',
        color: Colors.green,
        onTap: () {
          // TODO: Navigate to Savings Screen
        },
      ),
      _MenuItem(
        icon: Icons.receipt_long,
        label: 'Bills',
        color: Colors.red,
        onTap: () {
          // TODO: Navigate to Bills Screen
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Menu', style: AppTextStyles.h2),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menuItems.map((item) => _buildMenuCard(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildMenuCard(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        children: [
          Container(
            width: 56, // Fixed width for consistency
            height: 56,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: item.color, size: 24),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 64, // Limit text width
            child: Text(
              item.label,
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
