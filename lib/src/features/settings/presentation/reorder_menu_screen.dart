import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../localization/generated/app_localizations.dart';
import '../../dashboard/presentation/dashboard_menu_order_provider.dart';

class ReorderMenuScreen extends ConsumerStatefulWidget {
  const ReorderMenuScreen({super.key});

  @override
  ConsumerState<ReorderMenuScreen> createState() => _ReorderMenuScreenState();
}

class _ReorderMenuScreenState extends ConsumerState<ReorderMenuScreen> {
  late List<DashboardMenuItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(ref.read(dashboardMenuOrderProvider));
  }

  String _getLabel(BuildContext context, DashboardMenuItem item) {
    final l10n = AppLocalizations.of(context)!;
    switch (item) {
      case DashboardMenuItem.budget:
        return l10n.budget;
      case DashboardMenuItem.recurring:
        return l10n.recurring;
      case DashboardMenuItem.savings:
        return l10n.savings;
      case DashboardMenuItem.bills:
        return l10n.bills;
      case DashboardMenuItem.debts:
        return l10n.debts;
      case DashboardMenuItem.wishlist:
        return l10n.wishlist;
      case DashboardMenuItem.cards:
        return l10n.cards;
      case DashboardMenuItem.notes:
        return l10n.notes;
      case DashboardMenuItem.reimburse:
        return l10n.reimburse;
    }
  }

  IconData _getIcon(DashboardMenuItem item) {
    switch (item) {
      case DashboardMenuItem.budget:
        return Icons.pie_chart_outline;
      case DashboardMenuItem.recurring:
        return Icons.repeat;
      case DashboardMenuItem.savings:
        return Icons.savings_outlined;
      case DashboardMenuItem.bills:
        return Icons.receipt_long;
      case DashboardMenuItem.debts:
        return Icons.handshake_outlined;
      case DashboardMenuItem.wishlist:
        return Icons.card_giftcard;
      case DashboardMenuItem.cards:
        return Icons.credit_card;
      case DashboardMenuItem.notes:
        return Icons.checklist;
      case DashboardMenuItem.reimburse:
        return Icons.currency_exchange;
    }
  }

  Color _getColor(DashboardMenuItem item) {
    switch (item) {
      case DashboardMenuItem.budget:
        return Colors.orange;
      case DashboardMenuItem.recurring:
        return Colors.blue;
      case DashboardMenuItem.savings:
        return Colors.green;
      case DashboardMenuItem.bills:
        return Colors.red;
      case DashboardMenuItem.debts:
        return Colors.purple;
      case DashboardMenuItem.wishlist:
        return Colors.pink;
      case DashboardMenuItem.cards:
        return Colors.indigo;
      case DashboardMenuItem.notes:
        return Colors.teal;
      case DashboardMenuItem.reimburse:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.customizeMenu, style: AppTextStyles.h2),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(dashboardMenuOrderProvider.notifier).resetToDefault();
              setState(() {
                _items = ref.read(dashboardMenuOrderProvider);
              });
            },
            child: Text(l10n.resetMenu, style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(16),
        children: _items
            .map((item) => Card(
                  key: ValueKey(item),
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getColor(item).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getIcon(item), color: _getColor(item)),
                    ),
                    title: Text(
                      _getLabel(context, item),
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                  ),
                ))
            .toList(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
          ref.read(dashboardMenuOrderProvider.notifier).updateOrder(List.of(_items));
        },
      ),
    );
  }
}
