import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VoiceLanguage {
  indonesian('Bahasa Indonesia', 'id_ID'),
  english('English (US)', 'en_US'),
  japanese('日本語 (Japanese)', 'ja_JP'),
  chinese('中文 (Mandarin)', 'zh_CN'),
  korean('한국어 (Korean)', 'ko_KR');

  final String name;
  final String code; // Locale ID for SpeechToText
  const VoiceLanguage(this.name, this.code);
}

final voiceLanguageProvider = StateNotifierProvider<VoiceLanguageNotifier, VoiceLanguage>((ref) {
  return VoiceLanguageNotifier();
});

class VoiceLanguageNotifier extends StateNotifier<VoiceLanguage> {
  VoiceLanguageNotifier() : super(VoiceLanguage.indonesian) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('voice_language_code');
    if (code != null) {
      state = VoiceLanguage.values.firstWhere(
        (e) => e.code == code,
        orElse: () => VoiceLanguage.indonesian,
      );
    }
  }

  Future<void> setLanguage(VoiceLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voice_language_code', language.code);
    state = language;
  }
}
