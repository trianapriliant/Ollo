import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../budget/presentation/budget_screen.dart';
import '../../../../localization/generated/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard_menu_order_provider.dart';

class DashboardMenuGrid extends ConsumerWidget {
  const DashboardMenuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuOrder = ref.watch(dashboardMenuOrderProvider);
    final menuItems = menuOrder.map((item) => _createMenuItem(context, item)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.menu, style: AppTextStyles.h2),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: menuItems.map((item) => Padding(
              padding: const EdgeInsets.only(right: 20), // Slightly larger spacing
              child: _buildMenuCard(item),
            )).toList(),
          ),
        ),
      ],
    );
  }

  _MenuItem _createMenuItem(BuildContext context, DashboardMenuItem item) {
    switch (item) {
      case DashboardMenuItem.budget:
        return _MenuItem(
          icon: Icons.pie_chart_outline,
          label: AppLocalizations.of(context)!.budget,
          color: Colors.orange,
          onTap: () => context.push('/budget'),
        );
      case DashboardMenuItem.recurring:
        return _MenuItem(
          icon: Icons.repeat,
          label: AppLocalizations.of(context)!.recurring,
          color: Colors.blue,
          onTap: () => context.push('/recurring'),
        );
      case DashboardMenuItem.savings:
        return _MenuItem(
          icon: Icons.savings_outlined,
          label: AppLocalizations.of(context)!.savings,
          color: Colors.green,
          onTap: () => context.push('/savings'),
        );
      case DashboardMenuItem.bills:
        return _MenuItem(
          icon: Icons.receipt_long,
          label: AppLocalizations.of(context)!.bills,
          color: Colors.red,
          onTap: () {
            context.push('/bills');
          },
        );
      case DashboardMenuItem.debts:
        return _MenuItem(
          icon: Icons.handshake_outlined,
          label: AppLocalizations.of(context)!.debts,
          color: Colors.purple,
          onTap: () {
            context.push('/debts');
          },
        );
      case DashboardMenuItem.wishlist:
        return _MenuItem(
          icon: Icons.card_giftcard,
          label: AppLocalizations.of(context)!.wishlist,
          color: Colors.pink,
          onTap: () {
            context.push('/wishlist');
          },
        );
      case DashboardMenuItem.cards:
        return _MenuItem(
          icon: Icons.credit_card,
          label: AppLocalizations.of(context)!.cards,
          color: Colors.indigo,
          onTap: () => context.push('/cards'),
        );
      case DashboardMenuItem.notes:
        return _MenuItem(
          icon: Icons.checklist,
          label: AppLocalizations.of(context)!.notes,
          color: Colors.teal,
          onTap: () => context.push('/smart-notes'),
        );
      case DashboardMenuItem.reimburse:
        return _MenuItem(
          icon: Icons.currency_exchange,
          label: AppLocalizations.of(context)!.reimburse,
          color: Colors.orangeAccent,
          onTap: () => context.push('/reimburse'),
        );
    }
  }

  Widget _buildMenuCard(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: item.color, size: 24),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
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
