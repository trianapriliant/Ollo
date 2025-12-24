import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class SendFeedbackScreen extends StatelessWidget {
  const SendFeedbackScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context) async {
    const phoneNumber = '6283862181940'; // 083862181940
    final message = AppLocalizations.of(context)!.whatsappMessage;
    final url = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch WhatsApp');
    }
  }

  Future<void> _launchTelegram(BuildContext context) async {
    const username = 'trianapriliant';
    final url = Uri.parse('https://t.me/$username');
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch Telegram');
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final subject = 'Ollo App Feedback';
    final body = AppLocalizations.of(context)!.whatsappMessage;
    final url = Uri.parse('mailto:ollo.expenses@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}');
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch Email');
    }
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
        title: Text(AppLocalizations.of(context)!.sendFeedbackTitle, style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 3D Mascot Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                image: const DecorationImage(
                  image: AssetImage('assets/images/ollo_feedback_mascot_3d.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Title & Description
            Text(
              AppLocalizations.of(context)!.weValueYourVoice,
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.feedbackDescription,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // WhatsApp Button
            _buildContactButton(
              context: context,
              onPressed: () => _launchWhatsApp(context),
              icon: FontAwesomeIcons.whatsapp,
              label: AppLocalizations.of(context)!.chatViaWhatsApp,
              color: const Color(0xFF25D366), // WhatsApp Green
            ),
            const SizedBox(height: 12),

            // Telegram Button
            _buildContactButton(
              context: context,
              onPressed: () => _launchTelegram(context),
              icon: FontAwesomeIcons.telegram,
              label: 'Chat via Telegram',
              color: const Color(0xFF0088CC), // Telegram Blue
            ),
            const SizedBox(height: 12),

            // Email Button
            _buildContactButton(
              context: context,
              onPressed: () => _launchEmail(context),
              icon: Icons.email_outlined,
              label: 'Send Email',
              color: const Color(0xFF7C4DFF), // Purple
              useFaIcon: false,
            ),
            
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.repliesInHours,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool useFaIcon = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
          shadowColor: color.withOpacity(0.4),
        ),
        icon: useFaIcon 
            ? FaIcon(icon, color: Colors.white, size: 20)
            : Icon(icon, color: Colors.white, size: 22),
        label: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
