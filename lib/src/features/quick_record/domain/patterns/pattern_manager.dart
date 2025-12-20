import 'pattern_base.dart';
import 'patterns_id.dart';
import 'patterns_en.dart';
import 'patterns_jp.dart';
import 'patterns_ko.dart';
import 'patterns_zh.dart';

class PatternManager {
  /// Returns the category patterns based on the provided language code.
  /// Defaults to Indonesian if the language is not found.
  static Map<String, CategoryPattern> getPatterns(String languageCode) {
    if (languageCode.startsWith('en')) {
      return englishPatterns;
    }
    if (languageCode.startsWith('ja')) {
      return japanesePatterns;
    }
    if (languageCode.startsWith('ko')) {
      return koreanPatterns;
    }
    if (languageCode.startsWith('zh')) {
      return mandarinPatterns;
    }
    
    // Default to Indonesian (includes mixed English/Indonesian slang)
    return indonesianPatterns;
  }
}
