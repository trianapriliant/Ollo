import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/product_ids.dart';
import '../domain/subscription_model.dart';
import '../domain/vip_codes.dart';

/// Service for handling in-app purchases via RevenueCat
class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  /// RevenueCat API key for Android
  /// TODO: Replace with your actual RevenueCat API key
  static const String _androidApiKey = 'goog_QAyatfwhsqRLKXNtXVsszNCmAWk';

  /// RevenueCat API key for iOS (if needed in future)
  static const String _iosApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';

  bool _isInitialized = false;
  final _statusController = StreamController<SubscriptionStatus>.broadcast();

  /// Stream of subscription status changes
  Stream<SubscriptionStatus> get statusStream => _statusController.stream;

  /// Current subscription status
  SubscriptionStatus _currentStatus = SubscriptionStatus.free;
  SubscriptionStatus get currentStatus => _currentStatus;

  /// Initialize RevenueCat SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check for VIP status first (local check)
      final vipStatus = await _checkLocalVipStatus();
      if (vipStatus != null) {
        _currentStatus = vipStatus;
        _statusController.add(_currentStatus);
        _isInitialized = true;
        return;
      }

      // Configure RevenueCat
      final configuration = PurchasesConfiguration(_androidApiKey);
      await Purchases.configure(configuration);

      // Listen for customer info changes
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _updateStatusFromCustomerInfo(customerInfo);
      });

      // Get initial customer info
      final customerInfo = await Purchases.getCustomerInfo();
      _updateStatusFromCustomerInfo(customerInfo);

      _isInitialized = true;
      debugPrint('RevenueCat initialized successfully');
    } catch (e) {
      debugPrint('RevenueCat initialization failed: $e');
      // Fall back to local check
      await _checkLocalPremiumStatus();
      _isInitialized = true;
    }
  }

  /// Update subscription status from RevenueCat customer info
  void _updateStatusFromCustomerInfo(CustomerInfo customerInfo) {
    final entitlements = customerInfo.entitlements.active;

    if (entitlements.containsKey(ProductIds.vipEntitlement)) {
      _currentStatus = const SubscriptionStatus(
        tier: SubscriptionTier.vip,
        isActive: true,
      );
    } else if (entitlements.containsKey(ProductIds.premiumEntitlement)) {
      final entitlement = entitlements[ProductIds.premiumEntitlement]!;
      final tier = _getTierFromProductId(entitlement.productIdentifier);
      
      _currentStatus = SubscriptionStatus(
        tier: tier,
        isActive: true,
        expiryDate: entitlement.expirationDate != null
            ? DateTime.parse(entitlement.expirationDate!)
            : null,
        originalPurchaseDate: entitlement.originalPurchaseDate,
        productIdentifier: entitlement.productIdentifier,
      );
    } else {
      _currentStatus = SubscriptionStatus.free;
    }

    _statusController.add(_currentStatus);
  }

  /// Get subscription tier from product identifier
  SubscriptionTier _getTierFromProductId(String productId) {
    switch (productId) {
      case ProductIds.monthly:
        return SubscriptionTier.monthly;
      case ProductIds.sixMonth:
        return SubscriptionTier.sixMonth;
      case ProductIds.annual:
        return SubscriptionTier.annual;
      case ProductIds.lifetime:
        return SubscriptionTier.lifetime;
      default:
        return SubscriptionTier.free;
    }
  }

  /// Get available offerings (subscription options)
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('Failed to get offerings: $e');
      return null;
    }
  }

  /// Purchase a package
  Future<PurchaseResult> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      _updateStatusFromCustomerInfo(customerInfo);
      return PurchaseResult.success;
    } on PurchasesErrorCode catch (e) {
      debugPrint('Purchase failed: $e');
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseResult.cancelled;
      }
      return PurchaseResult.error;
    } catch (e) {
      debugPrint('Purchase error: $e');
      return PurchaseResult.error;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _updateStatusFromCustomerInfo(customerInfo);
      return _currentStatus.hasPremiumAccess;
    } catch (e) {
      debugPrint('Restore failed: $e');
      return false;
    }
  }

  /// Check for local VIP/Developer status (for grandfathered users)
  Future<SubscriptionStatus?> _checkLocalVipStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isVip = prefs.getBool('is_vip') ?? false;
      if (isVip) {
        // Check if it's specifically a developer
        final isDeveloper = prefs.getBool('is_developer') ?? false;
        return SubscriptionStatus(
          tier: isDeveloper ? SubscriptionTier.developer : SubscriptionTier.vip,
          isActive: true,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check for local premium status (fallback)
  Future<void> _checkLocalPremiumStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isPremium = prefs.getBool('is_premium') ?? false;
      if (isPremium) {
        _currentStatus = const SubscriptionStatus(
          tier: SubscriptionTier.lifetime,
          isActive: true,
        );
      }
    } catch (e) {
      debugPrint('Local premium check failed: $e');
    }
  }

  // VIP codes are now managed in vip_codes.dart for easier maintenance

  /// Redeem VIP code (each code can only be used once)
  Future<VipRedemptionResult> redeemVipCode(String code) async {
    final normalizedCode = code.toUpperCase().trim();
    
    // Check if code is valid (using VipCodes class)
    if (!VipCodes.isValidCode(normalizedCode)) {
      return VipRedemptionResult.invalidCode;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if it's a developer code (can override existing VIP)
      final isDeveloperCode = VipCodes.isDeveloperCode(normalizedCode);
      
      // Check if this device already has VIP (but allow developer to upgrade)
      final existingVip = prefs.getBool('is_vip') ?? false;
      final existingDeveloper = prefs.getBool('is_developer') ?? false;
      
      if (existingVip && !isDeveloperCode) {
        // Already VIP and not trying to use developer code
        return VipRedemptionResult.alreadyVip;
      }
      
      if (existingDeveloper && isDeveloperCode) {
        // Already a developer, no need to upgrade
        return VipRedemptionResult.alreadyVip;
      }
      
      // Check if code has been used before (locally tracked)
      // BUT allow developer code to bypass this if upgrading from VIP
      final usedCodes = prefs.getStringList('used_vip_codes') ?? [];
      final isUpgradingFromVip = existingVip && isDeveloperCode && !existingDeveloper;
      
      if (usedCodes.contains(normalizedCode) && !isUpgradingFromVip) {
        return VipRedemptionResult.codeAlreadyUsed;
      }
      
      // Mark code as used (if not already)
      if (!usedCodes.contains(normalizedCode)) {
        usedCodes.add(normalizedCode);
        await prefs.setStringList('used_vip_codes', usedCodes);
      }
      
      // Activate VIP or Developer
      await prefs.setBool('is_vip', true);
      await prefs.setBool('is_developer', isDeveloperCode); // Store developer flag!
      await prefs.setString('vip_code', normalizedCode);
      await prefs.setString('vip_activated_at', DateTime.now().toIso8601String());
      
      _currentStatus = SubscriptionStatus(
        tier: isDeveloperCode ? SubscriptionTier.developer : SubscriptionTier.vip,
        isActive: true,
      );
      _statusController.add(_currentStatus);
      
      debugPrint('${isDeveloperCode ? "Developer" : "VIP"} activated with code: $normalizedCode');
      return VipRedemptionResult.success;
    } catch (e) {
      debugPrint('VIP code redemption failed: $e');
      return VipRedemptionResult.error;
    }
  }

  /// Check if a code has been used
  Future<bool> isCodeUsed(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usedCodes = prefs.getStringList('used_vip_codes') ?? [];
      return usedCodes.contains(code.toUpperCase().trim());
    } catch (e) {
      return false;
    }
  }

  /// Get remaining VIP codes count (for admin purposes)
  Future<int> getRemainingCodesCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usedCodes = prefs.getStringList('used_vip_codes') ?? [];
      return VipCodes.allCodes.length - usedCodes.length;
    } catch (e) {
      return VipCodes.allCodes.length;
    }
  }

  /// Set premium status manually (for development/testing)
  Future<void> setDebugPremiumStatus(SubscriptionTier tier) async {
    if (!kDebugMode) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    if (tier == SubscriptionTier.free) {
      await prefs.setBool('is_premium', false);
      await prefs.setBool('is_vip', false);
      _currentStatus = SubscriptionStatus.free;
    } else if (tier == SubscriptionTier.vip) {
      await prefs.setBool('is_vip', true);
      _currentStatus = const SubscriptionStatus(
        tier: SubscriptionTier.vip,
        isActive: true,
      );
    } else {
      await prefs.setBool('is_premium', true);
      _currentStatus = SubscriptionStatus(
        tier: tier,
        isActive: true,
      );
    }
    
    _statusController.add(_currentStatus);
  }

  /// Dispose resources
  void dispose() {
    _statusController.close();
  }
}

/// Result of a purchase attempt
enum PurchaseResult {
  success,
  cancelled,
  error,
}

/// Result of VIP code redemption
enum VipRedemptionResult {
  success,
  invalidCode,
  codeAlreadyUsed,
  alreadyVip,
  error,
}
