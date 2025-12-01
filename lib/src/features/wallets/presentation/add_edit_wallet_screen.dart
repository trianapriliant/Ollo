import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../wallets/domain/wallet.dart';
import '../../wallets/data/wallet_repository.dart';
import '../../settings/presentation/currency_provider.dart';
import '../../../utils/icon_helper.dart';

class AddEditWalletScreen extends ConsumerStatefulWidget {
  final Wallet? wallet;

  const AddEditWalletScreen({super.key, this.wallet});

  @override
  ConsumerState<AddEditWalletScreen> createState() => _AddEditWalletScreenState();
}

class _AddEditWalletScreenState extends ConsumerState<AddEditWalletScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  late Color _selectedColor;
  late String _selectedIcon;

  final List<Color> _colors = [
    const Color(0xFF2196F3), // Blue
    const Color(0xFF4CAF50), // Green
    const Color(0xFFFF9800), // Orange
    const Color(0xFFE91E63), // Pink
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
  ];

  final List<String> _icons = [
    'account_balance_wallet',
    'credit_card',
    'savings',
    'attach_money',
    'account_balance',
    'payments',
    'shopping_bag',
    'home',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.wallet != null) {
      _nameController.text = widget.wallet!.name;
      _balanceController.text = widget.wallet!.balance.toStringAsFixed(0);
      _selectedColor = Color(widget.wallet!.colorValue);
      _selectedIcon = widget.wallet!.iconPath;
    } else {
      _selectedColor = _colors[0];
      _selectedIcon = _icons[0];
    }
    
    // Listen to changes for live preview
    _nameController.addListener(() => setState(() {}));
    _balanceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.wallet != null ? 'Edit Wallet' : 'New Wallet',
          style: AppTextStyles.h3,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Preview
            Center(
              child: Container(
                width: double.infinity,
                height: 180,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _selectedColor,
                      _selectedColor.withAlpha(179), // 0.7 * 255
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _selectedColor.withAlpha(102), // 0.4 * 255
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51), // 0.2 * 255
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            IconHelper.getIcon(_selectedIcon),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(26), // 0.1 * 255
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Debit Card', // Placeholder type
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text.isEmpty ? 'Wallet Name' : _nameController.text,
                          style: GoogleFonts.inter(
                            color: Colors.white.withAlpha(204), // 0.8 * 255
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currency.format(double.tryParse(_balanceController.text) ?? 0),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Input Fields
            Text('Wallet Details', style: AppTextStyles.h3),
            const SizedBox(height: 20),
            
            _buildTextField(
              controller: _nameController,
              label: 'Wallet Name',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _balanceController,
              label: 'Initial Balance',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 32),
            
            // Color Picker
            Text('Appearance', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            Text('Color', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  final isSelected = _selectedColor.value == color.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected 
                            ? Border.all(color: AppColors.textPrimary, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha(102), // 0.4 * 255
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: isSelected 
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            Text('Icon', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final iconName = _icons[index];
                  final isSelected = _selectedIcon == iconName;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = iconName),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                        ),
                      ),
                      child: Icon(
                        IconHelper.getIcon(iconName),
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveWallet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Wallet',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.textSecondary),
          labelText: label,
          labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _saveWallet() async {
    final name = _nameController.text;
    final balance = double.tryParse(_balanceController.text) ?? 0.0;

    if (name.isEmpty) return;

    final repo = await ref.read(walletRepositoryProvider.future);
    
    if (widget.wallet != null) {
      final updatedWallet = widget.wallet!
        ..name = name
        ..balance = balance
        ..colorValue = _selectedColor.value
        ..iconPath = _selectedIcon;
      await repo.addWallet(updatedWallet);
    } else {
      final newWallet = Wallet(
        name: name,
        balance: balance,
        colorValue: _selectedColor.value,
        iconPath: _selectedIcon,
        externalId: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      await repo.addWallet(newWallet);
    }

    if (mounted) context.pop();
  }
}
