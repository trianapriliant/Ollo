import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../localization/generated/app_localizations.dart';

class BugReportScreen extends ConsumerStatefulWidget {
  const BugReportScreen({super.key});

  @override
  ConsumerState<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends ConsumerState<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  
  String _selectedFeature = 'Quick Record';
  String _selectedSeverity = 'Medium';
  
  String _appVersion = '';
  String _deviceInfo = '';
  String _osVersion = '';
  String _language = '';

  final List<String> _features = [
    'Quick Record',
    'Transactions',
    'Budget',
    'Cards',
    'Wallets',
    'Categories',
    'Debts',
    'Bills',
    'Wishlist',
    'Savings',
    'Statistics',
    'Backup/Restore',
    'Settings',
    'Other',
  ];

  final Map<String, Color> _severityColors = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'High': Colors.deepOrange,
    'Critical': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    String device = '';
    String os = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = '${androidInfo.brand} ${androidInfo.model}';
      os = 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.utsname.machine;
      os = '${iosInfo.systemName} ${iosInfo.systemVersion}';
    }

    setState(() {
      _appVersion = 'Beta ${packageInfo.version}';
      _deviceInfo = device;
      _osVersion = os;
      _language = Localizations.localeOf(context).languageCode.toUpperCase();
    });
  }

  String _generateReport() {
    final now = DateTime.now();
    final dateStr = '${now.day} ${_getMonthName(now.month)} ${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return '''
BUG REPORT - Ollo

App: $_appVersion
Date: $dateStr
Device: $_deviceInfo
OS: $_osVersion
Language: $_language

---

Feature: $_selectedFeature
Severity: $_selectedSeverity
Title: ${_titleController.text}

Description:
${_descriptionController.text}
${_stepsController.text.isNotEmpty ? '''

Steps to Reproduce:
${_stepsController.text}''' : ''}

---
Sent via Ollo App
''';
  }


  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Future<void> _sendViaEmail() async {
    final report = _generateReport();
    final subject = Uri.encodeComponent('[Bug Report] ${_titleController.text}');
    final body = Uri.encodeComponent(report);
    final uri = Uri.parse('mailto:trianaprilianto3@gmail.com?subject=$subject&body=$body');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendViaWhatsApp() async {
    final report = _generateReport();
    final encoded = Uri.encodeComponent(report);
    // Using wa.me with phone number (Indonesian format without +)
    final uri = Uri.parse('https://wa.me/6283862181940?text=$encoded');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }


  Future<void> _sendViaTelegram() async {
    final report = _generateReport();
    final encoded = Uri.encodeComponent(report);
    // Using Telegram direct message link
    final uri = Uri.parse('https://t.me/+6283862181940?text=$encoded');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }


  void _showSendOptions() {
    if (!_formKey.currentState!.validate()) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.bugReportSendVia,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSendOption(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _sendViaEmail();
                  },
                ),
                _buildSendOption(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _sendViaWhatsApp();
                  },
                ),
                _buildSendOption(
                  icon: Icons.send,
                  label: 'Telegram',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _sendViaTelegram();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSendOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature) {
      case 'Quick Record': return Icons.flash_on;
      case 'Transactions': return Icons.receipt_long;
      case 'Budget': return Icons.account_balance_wallet;
      case 'Cards': return Icons.credit_card;
      case 'Wallets': return Icons.wallet;
      case 'Categories': return Icons.category;
      case 'Debts': return Icons.money_off;
      case 'Bills': return Icons.receipt;
      case 'Wishlist': return Icons.favorite;
      case 'Savings': return Icons.savings;
      case 'Statistics': return Icons.bar_chart;
      case 'Backup/Restore': return Icons.backup;
      case 'Settings': return Icons.settings;
      default: return Icons.more_horiz;
    }
  }

  void _showFeaturePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.bugReportFeature,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _features.length,
                itemBuilder: (context, index) {
                  final feature = _features[index];
                  final isSelected = feature == _selectedFeature;
                  return ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primary.withOpacity(0.15)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getFeatureIcon(feature),
                        color: isSelected ? AppColors.primary : Colors.grey[600],
                        size: 22,
                      ),
                    ),
                    title: Text(
                      feature,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected 
                        ? Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                        : null,
                    onTap: () {
                      setState(() => _selectedFeature = feature);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override

  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.bugReport, style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accentBlue.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.bugReportDeviceInfo, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('App', _appVersion),
                      _buildInfoRow('Device', _deviceInfo),
                      _buildInfoRow('OS', _osVersion),
                      _buildInfoRow('Language', _language),

                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Feature Dropdown
                Text(l10n.bugReportFeature, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showFeaturePicker(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_getFeatureIcon(_selectedFeature), color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedFeature,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Severity Selector
                Text(l10n.bugReportSeverity, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: _severityColors.entries.map((entry) {
                    final isSelected = _selectedSeverity == entry.key;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSeverity = entry.key),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? entry.value : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: entry.value,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              entry.key,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected ? Colors.white : entry.value,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Bug Title
                Text(l10n.bugReportTitle, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: l10n.bugReportTitleHint,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.bugReportTitleRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Bug Description
                Text(l10n.bugReportDescription, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.bugReportDescriptionHint,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.bugReportDescriptionRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Steps to Reproduce (Optional)
                Row(
                  children: [
                    Text(l10n.bugReportSteps, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(l10n.optional, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600])),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stepsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.bugReportStepsHint,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Send Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _showSendOptions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          l10n.bugReportSend,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600])),
          Text(value.isEmpty ? '...' : value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
