import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TransactionThemeType {
  classic,
  pastel,
  vibrant,
  ocean,
  warm,
  monochrome,
  neon,
  luxury,
  minty,
  seaside,
  neonFever,
  lavender,
  jolly,
}

class TransactionTheme {
  final TransactionThemeType type;
  final String name;
  final Color incomeColor;
  final Color expenseColor;
  final Color transferColor;

  const TransactionTheme({
    required this.type,
    required this.name,
    required this.incomeColor,
    required this.expenseColor,
    required this.transferColor,
  });

  static const classic = TransactionTheme(
    type: TransactionThemeType.classic,
    name: 'Classic',
    incomeColor: Colors.green,
    expenseColor: Colors.red,
    transferColor: Colors.blue,
  );

  static const pastel = TransactionTheme(
    type: TransactionThemeType.pastel,
    name: 'Pastel',
    incomeColor: Color(0xFF77DD77), // Pastel Green
    expenseColor: Color(0xFFFF6961), // Pastel Red
    transferColor: Color(0xFFAEC6CF), // Pastel Blue
  );

  static const vibrant = TransactionTheme(
    type: TransactionThemeType.vibrant,
    name: 'Vibrant',
    incomeColor: Color(0xFF00FF00), // Lime
    expenseColor: Color(0xFFFF00FF), // Magenta
    transferColor: Color(0xFF00FFFF), // Cyan
  );

  static const ocean = TransactionTheme(
    type: TransactionThemeType.ocean,
    name: 'Ocean',
    incomeColor: Color(0xFF4DB6AC), // Teal
    expenseColor: Color(0xFFE57373), // Red lighten
    transferColor: Color(0xFF0288D1), // Light Blue
  );
  
  static const warm = TransactionTheme(
    type: TransactionThemeType.warm,
    name: 'Warm',
    incomeColor: Color(0xFFFFB74D), // Orange
    expenseColor: Color(0xFFD32F2F), // Dark Red
    transferColor: Color(0xFF8D6E63), // Brown
  );

  static const monochrome = TransactionTheme(
    type: TransactionThemeType.monochrome,
    name: 'Monochrome',
    incomeColor: Color(0xFF000000), // Black
    expenseColor: Color(0xFF616161), // Dark Grey
    transferColor: Color(0xFFBDBDBD), // Light Grey
  );

  static const neon = TransactionTheme(
    type: TransactionThemeType.neon,
    name: 'Neon',
    incomeColor: Color(0xFF00E5FF), // Cyan Accent
    expenseColor: Color(0xFFFF4081), // Pink Accent
    transferColor: Color(0xFFFFEA00), // Yellow Accent
  );

  static const luxury = TransactionTheme(
    type: TransactionThemeType.luxury,
    name: 'Luxury',
    incomeColor: Color(0xFFC5A000), // Gold
    expenseColor: Color(0xFF2C3E50), // Midnight Blue
    transferColor: Color(0xFF7F8C8D), // Slate Grey
  );

  // COMMUNITY THEMES

  static const minty = TransactionTheme(
    type: TransactionThemeType.minty,
    name: 'Minty',
    incomeColor: Color(0xFF26A69A), // Mint
    expenseColor: Color(0xFF00695C), // Teal
    transferColor: Color(0xFF78909C), // Blue Grey
  );

  static const seaside = TransactionTheme(
    type: TransactionThemeType.seaside,
    name: 'Seaside',
    incomeColor: Color(0xFF00ACC1), // Cyan
    expenseColor: Color(0xFF1565C0), // Dark Blue
    transferColor: Color(0xFF64B5F6), // Light Blue
  );

  static const neonFever = TransactionTheme(
    type: TransactionThemeType.neonFever,
    name: 'Neon Fever',
    incomeColor: Color(0xFFAFB42B), // Lime (Darkened)
    expenseColor: Color(0xFFFF5252), // Salmon Red
    transferColor: Color(0xFF1B5E20), // Dark Green
  );

  static const lavender = TransactionTheme(
    type: TransactionThemeType.lavender,
    name: 'Lavender',
    incomeColor: Color(0xFF9C27B0), // Amethyst
    expenseColor: Color(0xFFD81B60), // Deep Pink
    transferColor: Color(0xFF039BE5), // Sky Blue
  );

  static const jolly = TransactionTheme(
    type: TransactionThemeType.jolly,
    name: 'Jolly Lime',
    incomeColor: Color(0xFF43A047), // Sea Green
    expenseColor: Color(0xFF546E7A), // Muted Blue
    transferColor: Color(0xFFC0CA33), // Lime
  );

  static List<TransactionTheme> get values => [
    classic, 
    pastel, 
    vibrant, 
    ocean, 
    warm,
    monochrome,
    neon,
    luxury,
    minty,
    seaside,
    neonFever,
    lavender,
    jolly,
  ];
  
  static TransactionTheme fromType(TransactionThemeType type) {
    return values.firstWhere((e) => e.type == type, orElse: () => classic);
  }
}

class ColorPaletteNotifier extends StateNotifier<TransactionTheme> {
  ColorPaletteNotifier() : super(TransactionTheme.classic) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('transaction_color_theme') ?? 0;
    state = TransactionTheme.fromType(TransactionThemeType.values[themeIndex]);
  }

  Future<void> setTheme(TransactionThemeType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('transaction_color_theme', type.index);
    state = TransactionTheme.fromType(type);
  }
}

final colorPaletteProvider = StateNotifierProvider<ColorPaletteNotifier, TransactionTheme>((ref) {
  return ColorPaletteNotifier();
});
