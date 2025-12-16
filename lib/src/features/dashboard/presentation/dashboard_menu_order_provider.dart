import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DashboardMenuItem {
  budget,
  recurring,
  savings,
  bills,
  debts,
  wishlist,
  cards,
  notes,
  reimburse;

  String get id => name;

  static DashboardMenuItem fromId(String id) {
    return DashboardMenuItem.values.firstWhere(
      (e) => e.name == id,
      orElse: () => DashboardMenuItem.budget,
    );
  }
}

final dashboardMenuOrderProvider =
    StateNotifierProvider<DashboardMenuOrderNotifier, List<DashboardMenuItem>>(
        (ref) {
  return DashboardMenuOrderNotifier();
});

class DashboardMenuOrderNotifier extends StateNotifier<List<DashboardMenuItem>> {
  static const String _prefsKey = 'dashboard_menu_order';

  DashboardMenuOrderNotifier() : super(_defaultOrder) {
    _loadOrder();
  }

  static const List<DashboardMenuItem> _defaultOrder = [
    DashboardMenuItem.budget,
    DashboardMenuItem.recurring,
    DashboardMenuItem.savings,
    DashboardMenuItem.bills,
    DashboardMenuItem.debts,
    DashboardMenuItem.wishlist,
    DashboardMenuItem.cards,
    DashboardMenuItem.notes,
    DashboardMenuItem.reimburse,
  ];

  Future<void> _loadOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedOrder = prefs.getStringList(_prefsKey);

    if (savedOrder != null && savedOrder.isNotEmpty) {
      final List<DashboardMenuItem> loadedOrder = [];
      final Set<DashboardMenuItem> seenItems = {};

      for (final id in savedOrder) {
        try {
          final item = DashboardMenuItem.fromId(id);
          if (!seenItems.contains(item)) {
            loadedOrder.add(item);
            seenItems.add(item);
          }
        } catch (_) {
          // Ignore invalid items
        }
      }

      // Add any missing items (in case of app updates adding new menu items)
      for (final item in DashboardMenuItem.values) {
        if (!seenItems.contains(item)) {
          loadedOrder.add(item);
        }
      }

      state = loadedOrder;
    } else {
      state = _defaultOrder;
    }
  }

  Future<void> updateOrder(List<DashboardMenuItem> newOrder) async {
    state = newOrder;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      newOrder.map((e) => e.id).toList(),
    );
  }

  Future<void> resetToDefault() async {
    state = _defaultOrder;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
