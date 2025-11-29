import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../data/wallet_repository.dart';
import '../domain/wallet.dart';
import '../domain/wallet_template.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../utils/icon_helper.dart';
import '../../../common_widgets/wallet_icon.dart';

class AddWalletScreen extends ConsumerStatefulWidget {
  const AddWalletScreen({super.key});

  @override
  ConsumerState<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends ConsumerState<AddWalletScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  WalletType _selectedType = WalletType.bank;
  String _selectedIcon = 'account_balance_wallet'; // Default icon

  final List<String> _availableIcons = [
    'account_balance_wallet', 'account_balance', 'credit_card', 'payments',
    'attach_money', 'savings', 'shopping_bag', 'shopping_cart',
    'store', 'local_mall', 'redeem', 'card_giftcard',
    'directions_car', 'directions_bus', 'flight', 'train',
    'home', 'apartment', 'school', 'work',
    'fastfood', 'restaurant', 'local_cafe', 'local_bar',
    'medical_services', 'local_hospital', 'fitness_center', 'pool',
    'movie', 'sports_esports', 'music_note', 'camera_alt',
  ];

  @override
  void initState() {
    super.initState();
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
    if (_selectedIcon.startsWith('assets/')) return;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Add Wallet', style: AppTextStyles.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Templates Section
            Text('Popular Banks', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: bankTemplates.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final template = bankTemplates[index];
                  return _buildTemplateItem(template);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text('E-Wallets', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: eWalletTemplates.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final template = eWalletTemplates[index];
                  return _buildTemplateItem(template);
                },
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            
            // Manual Input Section
            Text('Wallet Details', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            
            Text('Wallet Name', style: AppTextStyles.bodyMedium),
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
            Text('Initial Balance', style: AppTextStyles.bodyMedium),
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
            Text('Type', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<WalletType>(
                  value: _selectedType,
                  isExpanded: true,
                  items: WalletType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Icon', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            
            // Selected Icon Preview (if asset)
            if (_selectedIcon.startsWith('assets/')) ...[
              Center(
                child: Column(
                  children: [
                    WalletIcon(iconPath: _selectedIcon, size: 48),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIcon = 'account_balance_wallet'; // Reset
                        });
                      },
                      child: const Text('Change Icon'),
                    ),
                  ],
                ),
              ),
            ] else ...[
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = _nameController.text;
                  final balance = double.tryParse(_balanceController.text) ?? 0.0;

                  if (name.isEmpty) return;

                  final newWallet = Wallet()
                    ..id = DateTime.now().millisecondsSinceEpoch.toString() // Generate unique ID
                    ..name = name
                    ..balance = balance
                    ..type = _selectedType
                    ..iconPath = _selectedIcon;

                  final repository = await ref.read(walletRepositoryProvider.future);
                  await repository.addWallet(newWallet);

                  if (context.mounted) {
                    context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text('Save Wallet', style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
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
