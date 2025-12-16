import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('English', 'en'),
  indonesian('Bahasa Indonesia', 'id'),
  japanese('日本語', 'ja'),
  spanish('Español', 'es'),
  hindi('हिन्दी', 'hi'),
  chinese('中文', 'zh');

  final String name;
  final String code;
  const AppLanguage(this.name, this.code);
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code');
    if (code != null) {
      state = AppLanguage.values.firstWhere(
        (e) => e.code == code,
        orElse: () => AppLanguage.english,
      );
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', language.code);
    state = language;
  }
}
