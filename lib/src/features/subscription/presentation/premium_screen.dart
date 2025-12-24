import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../constants/app_text_styles.dart';
import '../application/revenuecat_service.dart';
import '../domain/subscription_model.dart';
import 'premium_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  Offerings? _offerings;
  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _error;
  int _selectedPlanIndex = 1; // Default to Annual (best value)

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await RevenueCatService.instance.getOfferings();
      setState(() {
        _offerings = offerings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _purchase(Package package) async {
    setState(() => _isPurchasing = true);
    
    final result = await RevenueCatService.instance.purchasePackage(package);
    
    setState(() => _isPurchasing = false);
    
    if (result == PurchaseResult.success && mounted) {
      _showSuccessDialog();
    } else if (result == PurchaseResult.error && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase failed. Please try again.')),
      );
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);
    
    final success = await ref.read(subscriptionStatusProvider.notifier).restorePurchases();
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success 
            ? 'Purchases restored successfully!' 
            : 'No previous purchases found.'),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text('Welcome to Premium!', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Thank you for your support. Enjoy all premium features!',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tier = ref.watch(subscriptionTierProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final isVip = ref.watch(isVipProvider);
    final isDeveloper = ref.watch(isDeveloperProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDeveloper
                        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)] // Dark developer gradient
                        : isVip
                            ? [const Color(0xFF9C27B0), const Color(0xFFE040FB)]
                            : isPremium
                                ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                                : [const Color(0xFF4A90E2), const Color(0xFF50E3C2)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        isDeveloper
                            ? Icons.code // Code icon for developer
                            : isVip
                                ? Icons.workspace_premium
                                : isPremium
                                    ? Icons.verified
                                    : Icons.star,
                        size: 64,
                        color: isDeveloper ? const Color(0xFF00D9FF) : Colors.white, // Cyan for developer
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isDeveloper
                            ? 'Developer'
                            : isVip
                                ? 'VIP Member'
                                : isPremium
                                    ? l10n.premiumMember
                                    : 'Ollo Premium',
                        style: AppTextStyles.h1.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Status Badge
                  if (isPremium || isVip || isDeveloper)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDeveloper
                            ? const Color(0xFF1A1A2E).withOpacity(0.3)
                            : isVip
                                ? const Color(0xFF9C27B0).withOpacity(0.1)
                                : const Color(0xFFFFD700).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDeveloper
                              ? const Color(0xFF00D9FF).withOpacity(0.5)
                              : isVip
                                  ? const Color(0xFF9C27B0).withOpacity(0.3)
                                  : const Color(0xFFFFD700).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isDeveloper ? Icons.code : Icons.check_circle,
                            color: isDeveloper 
                                ? const Color(0xFF00D9FF) 
                                : isVip 
                                    ? const Color(0xFF9C27B0) 
                                    : const Color(0xFFFFD700),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isDeveloper 
                                      ? 'Developer Mode Active'
                                      : 'Current Plan: ${tier.displayName}',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDeveloper ? const Color(0xFF00D9FF) : null,
                                  ),
                                ),
                                Text(
                                  isDeveloper 
                                      ? 'Full Access & Debug Features'
                                      : isVip 
                                          ? 'Early Access & Exclusive Benefits'
                                          : 'All premium features unlocked',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDeveloper 
                                        ? Colors.white70 
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isPremium || isVip || isDeveloper) const SizedBox(height: 24),

                  // Pricing Section (only for non-premium users) - NOW AT TOP
                  if (!isPremium && !isVip && !isDeveloper) ...[
                    Text('Choose Your Plan', style: AppTextStyles.h2),
                    const SizedBox(height: 16),
                    
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_error != null)
                      _buildHorizontalPricing()
                    else
                      _buildHorizontalPricingCards(),
                    
                    const SizedBox(height: 32),
                  ],

                  // Features Section
                  Text('Premium Features', style: AppTextStyles.h2),
                  const SizedBox(height: 16),
                  _buildFeatureItem(Icons.mic, 'Voice Quick Record', 'Add transactions with your voice'),
                  _buildFeatureItem(Icons.analytics, 'Advanced Statistics', 'Deep insights into your finances'),
                  _buildFeatureItem(Icons.file_download, 'Data Export', 'Export to CSV and Excel'),
                  _buildFeatureItem(Icons.document_scanner, 'Smart Scan', 'Scan receipts automatically'),
                  _buildFeatureItem(Icons.palette, 'Premium Themes', 'Exclusive gradient themes'),
                  _buildFeatureItem(Icons.account_balance_wallet, 'Unlimited Wallets', 'No limits on wallets'),

                  if (isVip && !isDeveloper) ...[
                    const SizedBox(height: 24),
                    Text('VIP Exclusive', style: AppTextStyles.h2),
                    const SizedBox(height: 16),
                    _buildFeatureItem(Icons.access_time, 'Early Access', 'Get new features first', isVipFeature: true),
                    _buildFeatureItem(Icons.support_agent, 'Priority Support', 'Fast-track bug reports', isVipFeature: true),
                    _buildFeatureItem(Icons.auto_awesome, 'Beta Features', 'Try experimental features', isVipFeature: true),
                  ],

                  // Developer Exclusive Benefits
                  if (isDeveloper) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text('Developer Exclusive', style: AppTextStyles.h2.copyWith(color: const Color(0xFF00D9FF))),
                        const SizedBox(width: 8),
                        const Icon(Icons.code, color: Color(0xFF00D9FF), size: 20),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(Icons.favorite, 'Built This App', 'Thank you for creating Ollo! 💖', isDeveloperFeature: true),
                    _buildFeatureItem(Icons.all_inclusive, 'Everything Unlocked', 'All features, forever', isDeveloperFeature: true),
                    _buildFeatureItem(Icons.bug_report, 'Debug Access', 'Developer tools & testing', isDeveloperFeature: true),
                  ],

                  // Restore Purchases
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: _restorePurchases,
                      child: const Text('Restore Purchases'),
                    ),
                  ),

                  // VIP Code Redemption
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => _showVipCodeDialog(),
                      child: const Text('Have a VIP code?'),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle, {bool isVipFeature = false, bool isDeveloperFeature = false}) {
    final Color accentColor;
    if (isDeveloperFeature) {
      accentColor = const Color(0xFF00D9FF); // Cyan for developer
    } else if (isVipFeature) {
      accentColor = const Color(0xFF9C27B0); // Purple for VIP
    } else {
      accentColor = const Color(0xFF4A90E2); // Blue for regular premium
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDeveloperFeature 
                  ? const Color(0xFF1A1A2E)
                  : accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDeveloperFeature ? const Color(0xFF00D9FF) : null,
                )),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(
            isDeveloperFeature ? Icons.verified : Icons.check_circle, 
            color: isDeveloperFeature ? const Color(0xFF00D9FF) : Colors.green, 
            size: 20,
          ),
        ],
      ),
    );
  }

  // New horizontal pricing layout (like reference image)
  Widget _buildHorizontalPricing() {
    return Column(
      children: [
        // Top row: Monthly and Annual side-by-side
        Row(
          children: [
            Expanded(
              child: _buildHorizontalPricingCard(
                index: 0,
                title: 'Monthly',
                price: 'IDR 15,000',
                subtitle: 'Billed Monthly',
                onTap: () => setState(() => _selectedPlanIndex = 0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHorizontalPricingCard(
                index: 1,
                title: 'Annual',
                price: 'IDR 120,000',
                subtitle: 'Billed Annually',
                badge: 'SAVE 33%',
                onTap: () => setState(() => _selectedPlanIndex = 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row: 6 Months and Lifetime
        Row(
          children: [
            Expanded(
              child: _buildHorizontalPricingCard(
                index: 2,
                title: '6 Months',
                price: 'IDR 75,000',
                subtitle: 'Billed Semi-Annually',
                badge: 'SAVE 17%',
                onTap: () => setState(() => _selectedPlanIndex = 2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHorizontalPricingCard(
                index: 3,
                title: 'Lifetime',
                price: 'IDR 199,000',
                subtitle: 'One-time Payment',
                badge: 'FOREVER',
                onTap: () => setState(() => _selectedPlanIndex = 3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Subscribe button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isPurchasing ? null : () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isPurchasing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Subscribe Now',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalPricingCards() {
    final offering = _offerings?.current;
    if (offering == null) return _buildHorizontalPricing();

    final packages = offering.availablePackages;
    if (packages.isEmpty) return _buildHorizontalPricing();

    // Group packages into pairs for rows
    List<Widget> rows = [];
    for (int i = 0; i < packages.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: _buildHorizontalPricingCard(
                index: i,
                title: _getPackageTitle(packages[i].packageType),
                price: packages[i].storeProduct.priceString,
                subtitle: _getBillingPeriod(packages[i].packageType),
                badge: _getSavingsBadge(packages[i].packageType),
                onTap: () {
                  setState(() => _selectedPlanIndex = i);
                  _purchase(packages[i]);
                },
              ),
            ),
            if (i + 1 < packages.length) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _buildHorizontalPricingCard(
                  index: i + 1,
                  title: _getPackageTitle(packages[i + 1].packageType),
                  price: packages[i + 1].storeProduct.priceString,
                  subtitle: _getBillingPeriod(packages[i + 1].packageType),
                  badge: _getSavingsBadge(packages[i + 1].packageType),
                  onTap: () {
                    setState(() => _selectedPlanIndex = i + 1);
                    _purchase(packages[i + 1]);
                  },
                ),
              ),
            ] else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < packages.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }

  Widget _buildHorizontalPricingCard({
    required int index,
    required String title,
    required String price,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedPlanIndex == index;
    
    return GestureDetector(
      onTap: _isPurchasing ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with selection indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[700],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Price
            Text(
              price,
              style: AppTextStyles.h3.copyWith(
                color: isSelected ? const Color(0xFF4A90E2) : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Badge (if any)
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF50E3C2) : const Color(0xFF50E3C2).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Subtitle
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _getPackageTitle(PackageType type) {
    switch (type) {
      case PackageType.monthly:
        return 'Monthly';
      case PackageType.sixMonth:
        return '6 Months';
      case PackageType.annual:
        return 'Annual';
      case PackageType.lifetime:
        return 'Lifetime';
      default:
        return 'Plan';
    }
  }

  String _getBillingPeriod(PackageType type) {
    switch (type) {
      case PackageType.monthly:
        return 'Billed Monthly';
      case PackageType.sixMonth:
        return 'Billed Semi-Annually';
      case PackageType.annual:
        return 'Billed Annually';
      case PackageType.lifetime:
        return 'One-time Payment';
      default:
        return '';
    }
  }

  String? _getSavingsBadge(PackageType type) {
    switch (type) {
      case PackageType.sixMonth:
        return 'SAVE 17%';
      case PackageType.annual:
        return 'SAVE 33%';
      case PackageType.lifetime:
        return 'FOREVER';
      default:
        return null;
    }
  }

  Widget _buildFallbackPricing() {
    return Column(
      children: [
        _buildPricingCard(
          title: 'Monthly',
          price: 'IDR 15,000',
          period: '/month',
          badge: '7-day free trial',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildPricingCard(
          title: '6 Months',
          price: 'IDR 75,000',
          period: '/6 months',
          originalPrice: 'IDR 90,000',
          badge: 'Save 17%',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildPricingCard(
          title: 'Annual',
          price: 'IDR 120,000',
          period: '/year',
          originalPrice: 'IDR 180,000',
          badge: 'Best Value',
          isPopular: true,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildPricingCard(
          title: 'Lifetime',
          price: 'IDR 199,000',
          period: 'one-time',
          badge: 'Forever',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPricingCards() {
    final offering = _offerings?.current;
    if (offering == null) return _buildFallbackPricing();

    return Column(
      children: offering.availablePackages.map((package) {
        final product = package.storeProduct;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPricingCard(
            title: product.title,
            price: product.priceString,
            period: _getPeriodString(package.packageType),
            onTap: () => _purchase(package),
          ),
        );
      }).toList(),
    );
  }

  String _getPeriodString(PackageType type) {
    switch (type) {
      case PackageType.monthly:
        return '/month';
      case PackageType.sixMonth:
        return '/6 months';
      case PackageType.annual:
        return '/year';
      case PackageType.lifetime:
        return 'one-time';
      default:
        return '';
    }
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String period,
    String? originalPrice,
    String? badge,
    bool isPopular = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isPurchasing ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPopular ? const Color(0xFFFFD700).withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPopular ? const Color(0xFFFFD700) : Colors.grey[300]!,
            width: isPopular ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPopular ? const Color(0xFFFFD700) : const Color(0xFF4A90E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.h3.copyWith(
                          color: isPopular ? const Color(0xFFD4A000) : null,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(period, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  if (originalPrice != null)
                    Text(
                      originalPrice,
                      style: AppTextStyles.bodySmall.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isPopular ? const Color(0xFFD4A000) : Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showVipCodeDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Enter VIP Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'XXXX-XXXX-XXXX-XXXX',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 19, // 16 chars + 3 dashes
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your 16-character VIP code',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await ref
                  .read(subscriptionStatusProvider.notifier)
                  .redeemVipCode(controller.text);
              
              if (mounted) {
                Navigator.of(context).pop();
                
                String message;
                Color bgColor;
                
                switch (result) {
                  case VipRedemptionResult.success:
                    message = 'Welcome to VIP! 🎉';
                    bgColor = Colors.green;
                    break;
                  case VipRedemptionResult.invalidCode:
                    message = 'Invalid code. Please check and try again.';
                    bgColor = Colors.red;
                    break;
                  case VipRedemptionResult.codeAlreadyUsed:
                    message = 'This code has already been used.';
                    bgColor = Colors.orange;
                    break;
                  case VipRedemptionResult.alreadyVip:
                    message = 'You are already a VIP member!';
                    bgColor = Colors.blue;
                    break;
                  case VipRedemptionResult.error:
                    message = 'An error occurred. Please try again.';
                    bgColor = Colors.red;
                    break;
                }
                
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: bgColor),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            child: const Text('Redeem', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
