/// Subscription tier enumeration for different user access levels
enum SubscriptionTier {
  /// Free tier - limited features
  free,

  /// Monthly subscription - all premium features
  monthly,

  /// 6-month subscription - discounted
  sixMonth,

  /// Annual subscription - best value
  annual,

  /// Lifetime purchase - one-time payment
  lifetime,

  /// VIP tier - grandfathered users with extra perks
  vip,

  /// Developer tier - app developer special access
  developer,
}

/// Extension methods for SubscriptionTier
extension SubscriptionTierExtension on SubscriptionTier {
  /// Check if tier has premium access
  bool get isPremium => this != SubscriptionTier.free;

  /// Check if tier is VIP
  bool get isVip => this == SubscriptionTier.vip || this == SubscriptionTier.developer;

  /// Check if tier is Developer
  bool get isDeveloper => this == SubscriptionTier.developer;

  /// Get display name for the tier
  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.monthly:
        return 'Premium Monthly';
      case SubscriptionTier.sixMonth:
        return 'Premium 6-Month';
      case SubscriptionTier.annual:
        return 'Premium Annual';
      case SubscriptionTier.lifetime:
        return 'Premium Lifetime';
      case SubscriptionTier.vip:
        return 'VIP';
      case SubscriptionTier.developer:
        return 'Developer';
    }
  }
}

/// Subscription status model
class SubscriptionStatus {
  final SubscriptionTier tier;
  final DateTime? expiryDate;
  final bool isActive;
  final String? originalPurchaseDate;
  final String? productIdentifier;

  const SubscriptionStatus({
    required this.tier,
    this.expiryDate,
    required this.isActive,
    this.originalPurchaseDate,
    this.productIdentifier,
  });

  /// Default free status
  static const SubscriptionStatus free = SubscriptionStatus(
    tier: SubscriptionTier.free,
    isActive: true,
  );

  /// Check if user has premium access
  bool get hasPremiumAccess => isActive && tier.isPremium;

  /// Check if user has VIP access
  bool get hasVipAccess => isActive && tier.isVip;

  /// Check if subscription is expiring soon (within 7 days)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    if (tier == SubscriptionTier.lifetime || tier == SubscriptionTier.vip || tier == SubscriptionTier.developer) {
      return false;
    }
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
  }

  /// Copy with new values
  SubscriptionStatus copyWith({
    SubscriptionTier? tier,
    DateTime? expiryDate,
    bool? isActive,
    String? originalPurchaseDate,
    String? productIdentifier,
  }) {
    return SubscriptionStatus(
      tier: tier ?? this.tier,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      originalPurchaseDate: originalPurchaseDate ?? this.originalPurchaseDate,
      productIdentifier: productIdentifier ?? this.productIdentifier,
    );
  }

  @override
  String toString() {
    return 'SubscriptionStatus(tier: $tier, isActive: $isActive, expiryDate: $expiryDate)';
  }
}
