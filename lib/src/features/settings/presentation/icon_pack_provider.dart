import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum IconPack { material, iconoir }

class IconPackNotifier extends StateNotifier<IconPack> {
  IconPackNotifier() : super(IconPack.material) {
    _loadIconPack();
  }

  static const String _prefKey = 'icon_pack';

  Future<void> _loadIconPack() async {
    final prefs = await SharedPreferences.getInstance();
    final packIndex = prefs.getInt(_prefKey) ?? 0;
    state = IconPack.values[packIndex];
  }

  Future<void> setIconPack(IconPack pack) async {
    state = pack;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, pack.index);
  }
}

final iconPackProvider = StateNotifierProvider<IconPackNotifier, IconPack>((ref) {
  return IconPackNotifier();
});
