import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';

import 'routing/app_router.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'features/common/data/isar_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/generated/app_localizations.dart';
import 'features/settings/presentation/language_provider.dart';

class OlloApp extends ConsumerStatefulWidget {
  const OlloApp({super.key});

  @override
  ConsumerState<OlloApp> createState() => _OlloAppState();
}

class _OlloAppState extends ConsumerState<OlloApp> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      await ref.read(isarProvider.future);
    } catch (e) {
      debugPrint('Error initializing app: $e');
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Ollo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      locale: Locale(language.code),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('id'), // Indonesian
      ],
    );
  }
}
