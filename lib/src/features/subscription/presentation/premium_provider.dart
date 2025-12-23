import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/revenuecat_service.dart';
import '../domain/subscription_model.dart';

/// Provider for checking if user has premium access
final isPremiumProvider = Provider<bool>((ref) {
  final status = ref.watch(subscriptionStatusProvider);
  return status.hasPremiumAccess;
});

/// Provider for checking if user has VIP access
final isVipProvider = Provider<bool>((ref) {
  final status = ref.watch(subscriptionStatusProvider);
  return status.hasVipAccess;
});

/// Provider for checking if user has Developer access
final isDeveloperProvider = Provider<bool>((ref) {
  final status = ref.watch(subscriptionStatusProvider);
  return status.tier.isDeveloper;
});

/// Provider for current subscription tier
final subscriptionTierProvider = Provider<SubscriptionTier>((ref) {
  final status = ref.watch(subscriptionStatusProvider);
  return status.tier;
});

/// Main provider for subscription status
final subscriptionStatusProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionStatus>((ref) {
  return SubscriptionNotifier();
});

/// State notifier for subscription management
class SubscriptionNotifier extends StateNotifier<SubscriptionStatus> {
  SubscriptionNotifier() : super(SubscriptionStatus.free) {
    _initialize();
  }

  StreamSubscription<SubscriptionStatus>? _statusSubscription;

  Future<void> _initialize() async {
    try {
      await RevenueCatService.instance.initialize();
      
      // Set initial state
      state = RevenueCatService.instance.currentStatus;
      
      // Listen for updates
      _statusSubscription = RevenueCatService.instance.statusStream.listen(
        (status) => state = status,
      );
    } catch (e) {
      // Keep free status on error
      state = SubscriptionStatus.free;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    return await RevenueCatService.instance.restorePurchases();
  }

  /// Redeem VIP code
  Future<VipRedemptionResult> redeemVipCode(String code) async {
    return await RevenueCatService.instance.redeemVipCode(code);
  }

  /// Set debug status (development only)
  Future<void> setDebugStatus(SubscriptionTier tier) async {
    await RevenueCatService.instance.setDebugPremiumStatus(tier);
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}

// ============== Legacy Provider for Backward Compatibility ==============

/// Legacy simple boolean provider (for backward compatibility)
/// @deprecated Use isPremiumProvider instead
final legacyIsPremiumProvider = Provider<bool>((ref) {
  return ref.watch(isPremiumProvider);
});
