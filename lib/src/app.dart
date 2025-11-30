import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';

import 'routing/app_router.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'features/common/data/isar_provider.dart';

class OlloApp extends ConsumerStatefulWidget {
  const OlloApp({super.key});

  @override
  ConsumerState<OlloApp> createState() => _OlloAppState();
}

class _OlloAppState extends ConsumerState<OlloApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Isar and then remove splash
    // We can't await here directly, but we can trigger it.
    // Actually, it's better to watch the provider in build or use a FutureBuilder/Provider listener.
    // But for simplicity, let's just remove it after a slight delay or when the first frame is done,
    // assuming Isar loads fast or the UI handles loading states.
    // Ideally: await ref.read(isarProvider.future); FlutterNativeSplash.remove();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      // Ensure Isar is ready
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
    );
  }
}
