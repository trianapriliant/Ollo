import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferences _prefs;
  static const _onboardingCompleteKey = 'onboarding_complete';

  OnboardingRepository(this._prefs);

  bool isOnboardingComplete() {
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingCompleteKey, true);
  }

  Future<void> resetOnboarding() async {
    await _prefs.remove(_onboardingCompleteKey);
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError('Initialize this provider in main.dart');
});
