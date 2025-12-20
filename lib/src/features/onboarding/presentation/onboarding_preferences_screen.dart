import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../settings/presentation/language_provider.dart';
import '../../settings/presentation/voice_language_provider.dart';
import '../../notifications/application/notification_service.dart';
import '../data/onboarding_repository.dart';

import 'package:ollo/src/features/wallets/domain/wallet.dart';
import 'package:ollo/src/features/wallets/data/wallet_repository.dart';
import 'package:ollo/src/features/profile/data/user_profile_repository.dart';
import 'package:ollo/src/features/profile/domain/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OnboardingPreferencesScreen extends ConsumerStatefulWidget {
  const OnboardingPreferencesScreen({super.key});

  @override
  ConsumerState<OnboardingPreferencesScreen> createState() => _OnboardingPreferencesScreenState();
}

class _OnboardingPreferencesScreenState extends ConsumerState<OnboardingPreferencesScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _pickedImageFile;

  final _formKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();
  
  int _currentPage = 0;
  bool _notificationsEnabled = false;

  // Simple localization map for this screen
  final Map<String, Map<String, String>> _i18n = {
    'en': {
      'step1_title': 'Select Language',
      'step1_desc': 'Choose your preferred language for the application interface.',
      'step2_title': 'Voice Command',
      'step2_desc': 'Select the language you will use for voice commands and quick recording.',
      'step3_title': 'Smart Notifications',
      'step3_desc': 'Enable daily reminders to keep your tracking on streak.',
      'step4_title': 'Your Profile',
      'step4_desc': 'Tell us a bit about yourself. This information will be displayed in your profile.',
      'step5_title': 'First Wallet',
      'step5_desc': 'Let\'s setup your main cash wallet. Enter your current cash on hand.',
      'next': 'Next',
      'finish': 'Get Started',
      'daily_reminders': 'Daily Reminders',
      'reminders_subtitle': 'Get valid reminders to record your expenses.',
      'fullname': 'Full Name',
      'name_hint': 'e.g. John Doe',
      'email': 'Email (Optional)',
      'email_hint': 'user@example.com',
      'wallet_name': 'Cash',
      'initial_balance': 'Initial Balance',
      'balance_hint': 'e.g. 500000',
      'setup_wallet_guide': 'You can add more wallets (Bank, E-Wallet) later in the Wallet menu.',
    },
    'id': {
      'step1_title': 'Pilih Bahasa',
      'step1_desc': 'Pilih bahasa utama untuk antarmuka aplikasi.',
      'step2_title': 'Perintah Suara',
      'step2_desc': 'Pilih bahasa yang akan digunakan untuk perintah suara dan pencatatan cepat.',
      'step3_title': 'Notifikasi Pintar',
      'step3_desc': 'Aktifkan pengingat harian agar pencatatan keuanganmu tetap rutin.',
      'step4_title': 'Profil Kamu',
      'step4_desc': 'Ceritakan sedikit tentang dirimu. Informasi ini akan ditampilkan di profilmu.',
      'step5_title': 'Dompet Pertama',
      'step5_desc': 'Mari atur dompet tunai utamamu. Masukkan jumlah uang tunai yang kamu pegang saat ini.',
      'next': 'Lanjut',
      'finish': 'Mulai Sekarang',
      'daily_reminders': 'Pengingat Harian',
      'reminders_subtitle': 'Dapatkan pengingat untuk mencatat pengeluaranmu.',
      'fullname': 'Nama Lengkap',
      'name_hint': 'cth. Budi Santoso',
      'email': 'Email (Opsional)',
      'email_hint': 'user@example.com',
      'wallet_name': 'Tunai',
      'initial_balance': 'Saldo Awal',
      'balance_hint': 'cth. 500000',
      'setup_wallet_guide': 'Kamu bisa menambah dompet lain (Bank, E-Wallet) nanti di menu Dompet.',
    },
  };

  @override
  void dispose() {
    _pageController.dispose();
    _balanceController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _t(String key) {
    final langCode = ref.read(languageProvider).code;
    return _i18n[langCode]?[key] ?? _i18n['en']![key]!;
  }

  void _onNext() {
    if (_currentPage == 3) {
       // Validate Profile Step
       if (_profileFormKey.currentState != null && !_profileFormKey.currentState!.validate()) {
         return;
       }
    }
    
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = File(pickedFile.path);
      });
    }
  }

  Widget _buildProfileSetupCard() {
    return Form(
      key: _profileFormKey,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                           color: Colors.black.withOpacity(0.1),
                           blurRadius: 10,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
                      child: _pickedImageFile == null
                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                         padding: const EdgeInsets.all(8),
                         decoration: const BoxDecoration(
                           color: AppColors.primary,
                           shape: BoxShape.circle,
                         ),
                         child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: _t('fullname'),
                hintText: _t('name_hint'),
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: _t('email'),
                hintText: _t('email_hint'),
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSetupCard() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.account_balance_wallet, color: Colors.green[700], size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('wallet_name'),
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    Text(
                      'Default Wallet',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _t('initial_balance'),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              decoration: InputDecoration(
                hintText: _t('balance_hint'),
                hintStyle: GoogleFonts.outfit(color: Colors.grey[400]),
                prefixText: ref.read(languageProvider) == AppLanguage.indonesian ? 'Rp ' : '\$ ',
                prefixStyle: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter initial balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _t('setup_wallet_guide'),
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finishOnboarding() async {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    final repo = ref.read(onboardingRepositoryProvider);
    await repo.completeOnboarding();
    
    // Save User Profile
    try {
      final profileRepo = await ref.read(userProfileRepositoryProvider.future);
      final currentProfile = await profileRepo.getUserProfile();
      
      currentProfile.name = _nameController.text;
      currentProfile.email = _emailController.text.isNotEmpty ? _emailController.text : null;
      if (_pickedImageFile != null) {
        currentProfile.profileImagePath = _pickedImageFile!.path;
      }
      
      await profileRepo.updateUserProfile(currentProfile);
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }

    // Create Default Wallet
    try {
      final walletRepo = await ref.read(walletRepositoryProvider.future);
      final initialBalance = double.tryParse(_balanceController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      
      final wallet = Wallet.create(
        name: _t('wallet_name'),
        balance: initialBalance,
        iconPath: 'assets/icons/wallet.png', 
        colorValue: 0xFF4CAF50, // Green
        type: WalletType.cash,
      );
      
      await walletRepo.addWallet(wallet);
    } catch (e) {
      debugPrint('Error creating default wallet: $e');
    }

    // Schedule Notifications
    if (_notificationsEnabled) {
       final notificationService = ref.read(notificationServiceProvider);
       await notificationService.scheduleDailyNotification(
        id: 0,
        title: ref.read(languageProvider) == AppLanguage.indonesian ? 'Evaluasi Harian' : 'Daily Evaluation',
        body: ref.read(languageProvider) == AppLanguage.indonesian 
            ? 'Jangan lupa catat pengeluaranmu hari ini!' 
            : 'Don\'t forget to track your expenses and evaluate your day!',
        hour: 20,
        minute: 0,
      );
    }

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = ref.watch(languageProvider);
    final currentVoiceLanguage = ref.watch(voiceLanguageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= _currentPage ? AppColors.primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), 
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  // Step 1: App Language
                  _buildStep(
                    title: _t('step1_title'),
                    description: _t('step1_desc'),
                    content: _buildLanguageSelector(currentLanguage),
                  ),

                  // Step 2: Voice Language
                  _buildStep(
                    title: _t('step2_title'),
                    description: _t('step2_desc'),
                    content: _buildVoiceLanguageSelector(currentVoiceLanguage),
                  ),

                  // Step 3: Notifications
                  _buildStep(
                    title: _t('step3_title'),
                    description: _t('step3_desc'),
                    content: _buildNotificationCard(),
                  ),

                  // Step 4: Profile Setup
                  _buildStep(
                    title: _t('step4_title'),
                    description: _t('step4_desc'),
                    content: _buildProfileSetupCard(),
                  ),

                  // Step 5: First Wallet
                  _buildStep(
                    title: _t('step5_title'),
                    description: _t('step5_desc'),
                    content: _buildWalletSetupCard(),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            Container(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentPage == 4 ? _t('finish') : _t('next'),
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required String title, required String description, required Widget content}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          content,
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(AppLanguage current) {
    return Column(
      children: AppLanguage.values.map((lang) {
        final isSelected = lang == current;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => ref.read(languageProvider.notifier).setLanguage(lang),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[200]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    lang.name,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                  else
                    Icon(Icons.circle_outlined, color: Colors.grey[300], size: 24),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVoiceLanguageSelector(VoiceLanguage current) {
    return Column(
      children: VoiceLanguage.values.map((lang) {
        final isSelected = lang == current;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => ref.read(voiceLanguageProvider.notifier).setLanguage(lang),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orangeAccent.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.orangeAccent : Colors.grey[200]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.name,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.orange[800] : AppColors.textPrimary,
                        ),
                      ),
                      if (lang == VoiceLanguage.indonesian)
                        Text(
                          'Recommended',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(Icons.check_circle, color: Colors.orange[800], size: 24)
                  else
                    Icon(Icons.circle_outlined, color: Colors.grey[300], size: 24),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active_rounded, color: Colors.purple, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            _t('daily_reminders'),
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _t('reminders_subtitle'),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (val) async {
              setState(() => _notificationsEnabled = val);
              if (val) {
                final notificationService = ref.read(notificationServiceProvider);
                await notificationService.requestPermissions();
              }
            },
            title: Text(
              _notificationsEnabled ? 'Active' : 'Enable',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: _notificationsEnabled ? Colors.purple : Colors.grey,
              ),
            ),
            secondary: Icon(
              _notificationsEnabled ? Icons.check_circle : Icons.circle_outlined,
              color: _notificationsEnabled ? Colors.purple : Colors.grey,
            ),
            activeColor: Colors.purple,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }
}
