import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MainCardTheme {
  classic(
    'themeClassic',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)], // Blue -> Teal (Original restored)
    ),
  ),
  sunset(
    'themeSunset',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFA8BFF), Color(0xFF2BD2FF), Color(0xFF2BFF88)], // Multi-color bright gradient
      stops: [0.0, 0.5, 1.0],
    ),
  ),
  ocean(
    'themeOcean',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF43E97B), Color(0xFF38F9D7)], // Turquoise -> Aqua (Simpler bright)
    ),
  ),
  berry(
    'themeBerry',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF78CA0), Color(0xFFFE9A8B)], // Pink -> Peach
    ),
  ),
  forest(
    'themeForest',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFf9d423), Color(0xFFff4e50)], // Yellow -> Red (Bright "Summer") - replacing Forest with something brighter
    ),
  ),
  midnight(
    'themeMidnight',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00F260), Color(0xFF0575E6)], // Bright Green -> Blue (Replacing dark midnight)
    ),
  ),
  oasis(
    'themeOasis',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEAE5C9), Color(0xFF6CC6CB)], // Beige -> Turquoise (User requested)
    ),
  ),
  lavender(
    'themeLavender',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF9FA5D5), Color(0xFFE8F5C8)], // Lavender -> Pale Lime (User requested)
    ),
  ),
  cottonCandy(
    'themeCottonCandy',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEAD6EE), Color(0xFFA0F1EA)], // Pink -> Mint (User requested)
    ),
  ),
  mint(
    'themeMint',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6DECAF), Color(0xFF6DECAF)], // Saturated Mint
    ),
  ),
  peach(
    'themePeach',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF9999), Color(0xFFFF9999)], // Saturated Peach
    ),
  ),
  softBlue(
    'themeSoftBlue',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7699D4), Color(0xFF7699D4)], // Making Blue slightly deeper too
    ),
  ),
  lilac(
    'themeLilac',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFB39DDB), Color(0xFFB39DDB)], // Flat Lilac
    ),
  ),
  lemon(
    'themeLemon',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF7D754), Color(0xFFF7D754)], // Flat Lemon
    ),
  ),
  argon(
    'themeArgon',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF03001e), // Deep Purple/Navy
        Color(0xFF7303c0), // Purple
        Color(0xFFec38bc), // Pink
        Color(0xFFfdeff9), // Light Pink
      ],
      stops: [0.0, 0.33, 0.66, 1.0],
    ),
  ),
  velvetSun(
    'themeVelvetSun',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFe1eec3), Color(0xFFf05053)], // Light green → Red
    ),
  ),
  summer(
    'themeSummer',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF22c1c3), Color(0xFFfdbb2d)], // Teal → Yellow
    ),
  ),
  brokenHearts(
    'themeBrokenHearts',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFd9a7c7), Color(0xFFfffcdc)], // Pink → Light cream
    ),
  ),
  relay(
    'themeRelay',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF3a1c71), // Dark purple
        Color(0xFFd76d77), // Pink
        Color(0xFFffaf7b), // Peach
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  ),
  cinnamint(
    'themeCinnamint',
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4ac29a), Color(0xFFbdfff3)], // Green → Light mint
    ),
  );

  final String localizationKey;
  final Gradient gradient;

  const MainCardTheme(this.localizationKey, this.gradient);
}

final mainCardThemeProvider =
    StateNotifierProvider<MainCardThemeNotifier, MainCardTheme>((ref) {
  return MainCardThemeNotifier();
});

class MainCardThemeNotifier extends StateNotifier<MainCardTheme> {
  static const String _prefsKey = 'main_card_theme';

  MainCardThemeNotifier() : super(MainCardTheme.classic) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_prefsKey);
    if (themeName != null) {
      state = MainCardTheme.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => MainCardTheme.classic,
      );
    }
  }

  Future<void> setTheme(MainCardTheme theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, theme.name);
  }
}
