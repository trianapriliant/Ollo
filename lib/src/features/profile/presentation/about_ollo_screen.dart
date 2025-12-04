import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class AboutOlloScreen extends StatelessWidget {
  const AboutOlloScreen({super.key});

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
        title: Text('About Ollo', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 3D Mascot Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                image: const DecorationImage(
                  image: AssetImage('assets/images/ollo_mascot_3d.png'),
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
            const SizedBox(height: 32),

            // Philosophy Section
            Text(
              'Your Financial Companion',
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Ollo lahir dari keyakinan bahwa mengelola keuangan seharusnya tidak rumit. Kami ingin menciptakan teman finansial yang cerdas, ramah, dan membantu Anda mencapai impian finansial Anda, satu langkah demi satu langkah.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Social Media Section
            Text(
              'Connect with us',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  icon: FontAwesomeIcons.instagram,
                  color: const Color(0xFFE1306C),
                  url: 'https://instagram.com/ollo.app',
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  icon: FontAwesomeIcons.xTwitter,
                  color: Colors.black,
                  url: 'https://x.com/ollo_app',
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  icon: FontAwesomeIcons.tiktok,
                  color: Colors.black,
                  url: 'https://tiktok.com/@ollo.app',
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  icon: FontAwesomeIcons.linkedinIn,
                  color: const Color(0xFF0077B5),
                  url: 'https://linkedin.com/company/ollo-app',
                ),
              ],
            ),
            
            const SizedBox(height: 48),
            Text(
              'Version 1.0.0',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String url;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.url,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error silently or show snackbar
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FaIcon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}
