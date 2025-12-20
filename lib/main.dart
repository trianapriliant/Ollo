import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'src/features/notifications/utils/timezone_helper.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'src/features/onboarding/data/onboarding_repository.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  TimezoneHelper.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(OnboardingRepository(sharedPreferences)),
      ],
      child: const OlloApp(),
    ),
  );
}
