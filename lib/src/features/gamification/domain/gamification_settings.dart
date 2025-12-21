import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamificationSettings {
  final bool showDashboardLevel;
  final bool hideLockedBadges; // Spoiler Mode
  final bool enableNotifications;

  const GamificationSettings({
    this.showDashboardLevel = true,
    this.hideLockedBadges = false,
    this.enableNotifications = true,
  });

  GamificationSettings copyWith({
    bool? showDashboardLevel,
    bool? hideLockedBadges,
    bool? enableNotifications,
  }) {
    return GamificationSettings(
      showDashboardLevel: showDashboardLevel ?? this.showDashboardLevel,
      hideLockedBadges: hideLockedBadges ?? this.hideLockedBadges,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showDashboardLevel': showDashboardLevel,
      'hideLockedBadges': hideLockedBadges,
      'enableNotifications': enableNotifications,
    };
  }

  factory GamificationSettings.fromJson(Map<String, dynamic> json) {
    return GamificationSettings(
      showDashboardLevel: json['showDashboardLevel'] ?? true,
      hideLockedBadges: json['hideLockedBadges'] ?? false,
      enableNotifications: json['enableNotifications'] ?? true,
    );
  }
}

class GamificationSettingsNotifier extends StateNotifier<GamificationSettings> {
  GamificationSettingsNotifier() : super(const GamificationSettings()) {
    _loadSettings();
  }

  static const _key = 'gamification_settings';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      try {
        state = GamificationSettings.fromJson(jsonDecode(jsonString));
      } catch (_) {
        // Fallback to default if corrupted
      }
    }
  }

  Future<void> _saveSettings(GamificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }

  Future<void> toggleDashboardLevel(bool value) async {
    state = state.copyWith(showDashboardLevel: value);
    await _saveSettings(state);
  }

  Future<void> toggleSpoilerMode(bool value) async {
    state = state.copyWith(hideLockedBadges: value);
    await _saveSettings(state);
  }

  Future<void> toggleNotifications(bool value) async {
    state = state.copyWith(enableNotifications: value);
    await _saveSettings(state);
  }
}

final gamificationSettingsProvider = StateNotifierProvider<GamificationSettingsNotifier, GamificationSettings>((ref) {
  return GamificationSettingsNotifier();
});
