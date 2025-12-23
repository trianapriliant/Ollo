/// RevenueCat product identifiers for Ollo Premium
/// 
/// These IDs must match the products configured in:
/// 1. RevenueCat Dashboard
/// 2. Google Play Console
class ProductIds {
  ProductIds._();

  // ============== Subscription Products ==============

  /// Monthly subscription - IDR 15,000/month with 7-day free trial
  static const String monthly = 'ollo_premium_monthly';

  /// 6-month subscription - IDR 75,000 (~17% discount)
  static const String sixMonth = 'ollo_premium_6month';

  /// Annual subscription - IDR 120,000 (~33% discount)
  static const String annual = 'ollo_premium_annual';

  // ============== Non-Consumable Products ==============

  /// Lifetime purchase - IDR 199,000 one-time
  static const String lifetime = 'ollo_premium_lifetime';

  // ============== Entitlement Identifiers ==============

  /// Main premium entitlement that unlocks all premium features
  static const String premiumEntitlement = 'premium';

  /// VIP entitlement for grandfathered users
  static const String vipEntitlement = 'vip';

  // ============== Helper Methods ==============

  /// List of all subscription product IDs
  static const List<String> subscriptionProductIds = [
    monthly,
    sixMonth,
    annual,
  ];

  /// List of all non-consumable product IDs
  static const List<String> nonConsumableProductIds = [
    lifetime,
  ];

  /// All product IDs
  static const List<String> allProductIds = [
    monthly,
    sixMonth,
    annual,
    lifetime,
  ];
}
