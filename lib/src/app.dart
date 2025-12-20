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
import 'features/recurring/application/recurring_transaction_service.dart';
import 'features/notifications/application/notification_service.dart';

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
      // Process recurring transactions and bills
      final recurringService = await ref.read(recurringTransactionServiceFutureProvider.future);
      await recurringService.processDueTransactions();
      
      // Initialize Notifications
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.init();
      await notificationService.requestPermissions();
      
      // Schedule Daily Reminder (8:00 PM)
      await notificationService.scheduleDailyNotification(
        id: 0,
        title: 'Daily Evaluation',
        body: 'Don\'t forget to track your expenses and evaluate your day!',
        hour: 20,
        minute: 0,
      );

      // Schedule Weekly Evaluation (Sunday 8 PM)
      await notificationService.scheduleWeeklyNotification(
        id: 1,
        title: 'Weekly Evaluation',
        body: 'It\'s Sunday! Time to review your weekly spending and reset your budget.',
        hour: 20,
        minute: 0,
      );

      // Schedule Monthly Evaluation (28th 8 PM)
      await notificationService.scheduleMonthlyNotification(
        id: 2,
        title: 'Monthly Evaluation',
        body: 'The month is ending. Check your total expenses and plan for next month!',
        hour: 20,
        minute: 0,
      );
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
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
