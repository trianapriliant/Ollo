import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';
import '../../../onboarding/data/onboarding_repository.dart';
import '../splash_preview_screen.dart';

class DeveloperOptionsHelper {
  static void showLoginDialog(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Access'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter developer password',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == '304021') {
                Navigator.pop(context); // Close login dialog
                _showOptionsDialog(context, ref);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect password')),
                );
              }
            },
            child: const Text('Enter'),
          ),
        ],
      ),
    );
  }

  static void _showOptionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.orange),
              title: const Text('Reset Onboarding'),
              subtitle: const Text('Clear onboarding status and return to intro screen.'),
              onTap: () async {
                Navigator.pop(context); // Close dialog
                await ref.read(onboardingRepositoryProvider).resetOnboarding();
                if (context.mounted) {
                  context.go('/onboarding');
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.preview, color: AppColors.primary),
              title: const Text('Preview Splash Screen'),
              subtitle: const Text('View the startup splash screen animation.'),
              onTap: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SplashPreviewScreen()),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
