import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/wallet_repository.dart';
import '../domain/wallet.dart';
import '../domain/wallet_template.dart';
import '../application/wallet_template_service.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../utils/icon_helper.dart';
import '../../../common_widgets/wallet_icon.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class AddWalletScreen extends ConsumerStatefulWidget {
  final Wallet? walletToEdit;

  const AddWalletScreen({super.key, this.walletToEdit});

  @override
  ConsumerState<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends ConsumerState<AddWalletScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  WalletType _selectedType = WalletType.bank;
  String _selectedIcon = 'account_balance_wallet'; // Default icon

  final List<String> _availableIcons = [
    // Finance
    'account_balance_wallet', 'account_balance', 'credit_card', 'payments', 'savings', 
    'monetization_on', 'wallet', 'currency_exchange', 'account_box', 'attach_money',
    'trending_up', 'pie_chart', 'currency_bitcoin', 'receipt',
    
    // Shopping
    'shopping_bag', 'shopping_cart', 'store', 'local_mall', 'redeem', 
    'card_giftcard', 'sell', 'checkroom', 'local_grocery_store',
    
    // Transport
    'directions_car', 'directions_bus', 'flight', 'train', 'local_taxi', 
    'two_wheeler', 'directions_boat', 'local_gas_station', 'commute',
    
    // Home & Living
    'home', 'apartment', 'cottage', 'weekend', 'chair', 'bed', 'kitchen',
    'water_drop', 'wifi', 'bolt', 'build', 'lock', 'key',
    
    // Food & Drink
    'fastfood', 'restaurant', 'local_cafe', 'local_bar', 'bakery_dining', 
    'lunch_dining', 'dinner_dining', 'icecream', 'coffee', 'cake', 'liquor',
    
    // Health & Wellness
    'medical_services', 'local_hospital', 'local_pharmacy', 'fitness_center', 
    'pool', 'spa', 'monitor_heart',
    
    // Entertainment
    'movie', 'sports_esports', 'music_note', 'camera_alt', 'live_tv', 
    'theater_comedy', 'sports_soccer', 'sports_basketball', 'sports_tennis', 
    'sports_golf', 'sports_football', 'sports_volleyball', 'pool', 'kitesurfing', 'surfing',
    'palette', 'brush', 'piano', 'mic', 'headphones', 'gamepad',
    
    // Nature & Outdoors
    'forest', 'terrain', 'landscape', 'beach_access', 'park', 'wb_sunny', 
    'nightlight', 'local_florist', 'grass', 'hiking',
    
    // Family & People
    'person', 'people', 'groups', 'child_friendly', 'baby_changing_station', 
    'family_restroom', 'face', 'mood',
    
    // Activity & Fitness
    'directions_run', 'directions_walk', 'directions_bike', 'fitness_center', 
    'self_improvement',
    
    // Work & Education
    'work', 'school', 'menu_book', 'computer', 'business_center', 
    'science', 'calculate', 'architecture', 'construction', 'engineering',
    
    // Tech
    'smartphone', 'laptop', 'watch', 'router',
    
    // Others
    'pets', 'child_care', 'card_travel', 'explore', 'favorite', 'star', 'delete',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.walletToEdit != null) {
      _nameController.text = widget.walletToEdit!.name;
      _balanceController.text = widget.walletToEdit!.balance.toStringAsFixed(0);
      _selectedType = widget.walletToEdit!.type;
      _selectedIcon = widget.walletToEdit!.iconPath;
    }
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    // Only auto-detect if the current icon is NOT an asset path (meaning user hasn't selected a template)
    // AND if we are NOT in edit mode (to avoid overriding user's existing choice)
    if (_selectedIcon.startsWith('assets/') || widget.walletToEdit != null) return;

    final name = _nameController.text.toLowerCase();
    String? newIcon;

    // Smart Icon Detection (Fallback for manual entry)
    if (name.contains('bri')) {
      newIcon = 'assets/wallets/bri.svg';
    } else if (name.contains('bca') || name.contains('mandiri') || name.contains('bni')) {
      newIcon = 'account_balance';
    } else if (name.contains('cash') || name.contains('tunai') || name.contains('dompet')) {
      newIcon = 'payments';
    } else if (name.contains('gopay') || name.contains('ovo') || name.contains('dana') || name.contains('shopeepay')) {
      newIcon = 'account_balance_wallet';
    } else if (name.contains('shopee') || name.contains('tokopedia') || name.contains('lazada')) {
      newIcon = 'shopping_bag';
    } else if (name.contains('jenius') || name.contains('jago') || name.contains('seabank')) {
      newIcon = 'credit_card';
    } else if (name.contains('invest') || name.contains('bibit') || name.contains('saham')) {
      newIcon = 'trending_up';
    }

    if (newIcon != null && newIcon != _selectedIcon) {
      setState(() {
        _selectedIcon = newIcon!;
      });
    }
  }

  void _selectTemplate(WalletTemplate template) {
    setState(() {
      _nameController.text = template.name;
      _selectedType = template.type;
      _selectedIcon = template.assetPath;
    });
  }

  /// Check if current icon is a custom uploaded file
  bool get _isCustomIcon {
    if (_selectedIcon.isEmpty) return false;
    if (_selectedIcon.startsWith('assets/')) return false;
    // Check if it's a file path (not a Material icon name)
    return _selectedIcon.startsWith('/') || 
           _selectedIcon.contains(':\\') ||
           _selectedIcon.contains('/app_flutter/') ||
           _selectedIcon.contains('Documents');
  }

  /// Pick image from gallery and save to app documents
  Future<void> _pickCustomIcon() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image == null) return;
      
      // Get app documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String iconsDir = '${appDir.path}/wallet_icons';
      
      // Create icons directory if not exists
      final Directory iconsDirRef = Directory(iconsDir);
      if (!await iconsDirRef.exists()) {
        await iconsDirRef.create(recursive: true);
      }
      
      // Generate unique filename
      final String fileName = 'wallet_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
      final String savedPath = '$iconsDir/$fileName';
      
      // Copy image to app directory
      await File(image.path).copy(savedPath);
      
      setState(() {
        _selectedIcon = savedPath;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Custom icon selected!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveWallet() async {
    final name = _nameController.text;
    final balance = double.tryParse(_balanceController.text) ?? 0.0;

    if (name.isEmpty) return;

    final repository = await ref.read(walletRepositoryProvider.future);

    if (widget.walletToEdit != null) {
      final updatedWallet = widget.walletToEdit!
        ..name = name
        ..balance = balance
        ..type = _selectedType
        ..iconPath = _selectedIcon;
      await repository.updateWallet(updatedWallet);
    } else {
      final newWallet = Wallet()
        ..externalId = DateTime.now().millisecondsSinceEpoch.toString()
        ..name = name
        ..balance = balance
        ..type = _selectedType
        ..iconPath = _selectedIcon;
      await repository.addWallet(newWallet);
    }

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.walletToEdit != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(isEditing ? 'Edit Wallet' : 'Add Wallet', style: AppTextStyles.h2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _saveWallet,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Save',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Templates Section - uses dynamic provider
            ref.watch(availableTemplatesProvider).when(
              data: (templates) {
                final hasBanks = templates.banks.isNotEmpty;
                final hasEWallets = templates.eWallets.isNotEmpty;
                
                if (!hasBanks && !hasEWallets) {
                  // No templates available - show import prompt
                  return Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          'No wallet templates available',
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Go to Settings → Import Icon Pack to add bank and e-wallet templates.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasBanks) ...[
                      Text(AppLocalizations.of(context)!.popularBanks, style: AppTextStyles.h3),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: templates.banks.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final template = templates.banks[index];
                            return _buildTemplateItem(template);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (hasEWallets) ...[
                      Text(AppLocalizations.of(context)!.eWallets, style: AppTextStyles.h3),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: templates.eWallets.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final template = templates.eWallets[index];
                            return _buildTemplateItem(template);
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
            
            // Manual Input Section
            Text(AppLocalizations.of(context)!.walletDetails, style: AppTextStyles.h3),
            const SizedBox(height: 16),
            
            Text(AppLocalizations.of(context)!.walletName, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g., BCA, GoPay, Cash',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.initialBalance, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixText: '${ref.watch(currencyProvider).symbol} ',
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.typeLabel, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            // Modern Pill-style Type Selector
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: WalletType.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final type = WalletType.values[index];
                  final isSelected = type == _selectedType;
                  return _buildTypeChip(type, isSelected);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.icon, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            
            // Selected Icon Preview (if asset or custom)
            if (_selectedIcon.startsWith('assets/') || _isCustomIcon) ...[
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: WalletIcon(iconPath: _selectedIcon, size: 64),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isCustomIcon ? 'Custom Icon' : 'Selected Icon',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIcon = 'account_balance_wallet'; // Reset
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.changeIcon),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Custom Asset Icons (only show if templates imported)
              ref.watch(availableTemplatesProvider).when(
                data: (templates) {
                  final allTemplates = [...templates.banks, ...templates.eWallets];
                  if (allTemplates.isEmpty) {
                    // No imported icons - show import prompt
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Import icon pack from Settings to see bank/e-wallet icons',
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.bankEWalletLogos, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: allTemplates.length,
                          itemBuilder: (context, index) {
                            final template = allTemplates[index];
                            final isSelected = _selectedIcon == template.assetPath;
                            
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = template.assetPath;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected ? Border.all(color: AppColors.primary, width: 2) : Border.all(color: Colors.grey[200]!),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: WalletIcon(iconPath: template.assetPath, size: 24),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // Upload Custom Icon Button
              Center(
                child: OutlinedButton.icon(
                  onPressed: _pickCustomIcon,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Upload Custom Icon'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(AppLocalizations.of(context)!.genericIcons, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final iconName = _availableIcons[index];
                    final isSelected = iconName == _selectedIcon;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconName;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                        ),
                        child: Icon(
                          IconHelper.getIcon(iconName),
                          color: isSelected ? AppColors.primary : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(WalletType type, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [
                    _getTypeColor(type),
                    _getTypeColor(type).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: isSelected 
              ? null 
              : Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: _getTypeColor(type).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getTypeIcon(type),
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              _getTypeLabel(type),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(WalletType type) {
    switch (type) {
      case WalletType.bank:
        return Icons.account_balance;
      case WalletType.ewallet:
        return Icons.account_balance_wallet;
      case WalletType.cash:
        return Icons.payments;
      case WalletType.creditCard:
        return Icons.credit_card;
      case WalletType.exchange:
        return Icons.trending_up;
      case WalletType.other:
        return Icons.more_horiz;
    }
  }

  Color _getTypeColor(WalletType type) {
    switch (type) {
      case WalletType.bank:
        return const Color(0xFF1976D2); // Blue
      case WalletType.ewallet:
        return const Color(0xFF7B1FA2); // Purple
      case WalletType.cash:
        return const Color(0xFF388E3C); // Green
      case WalletType.creditCard:
        return const Color(0xFFE64A19); // Deep Orange
      case WalletType.exchange:
        return const Color(0xFF00897B); // Teal
      case WalletType.other:
        return const Color(0xFF455A64); // Blue Grey
    }
  }

  String _getTypeLabel(WalletType type) {
    switch (type) {
      case WalletType.bank:
        return 'Bank';
      case WalletType.ewallet:
        return 'E-Wallet';
      case WalletType.cash:
        return 'Cash';
      case WalletType.creditCard:
        return 'Credit Card';
      case WalletType.exchange:
        return 'Investment';
      case WalletType.other:
        return 'Other';
    }
  }

  Widget _buildTemplateItem(WalletTemplate template) {
    final isSelected = _nameController.text == template.name;
    return GestureDetector(
      onTap: () => _selectTemplate(template),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppColors.primary, width: 2) : Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WalletIcon(iconPath: template.assetPath, size: 32),
            const SizedBox(height: 8),
            Text(
              template.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
