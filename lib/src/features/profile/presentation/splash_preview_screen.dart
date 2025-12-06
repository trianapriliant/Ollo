import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';

class SplashPreviewScreen extends StatefulWidget {
  const SplashPreviewScreen({super.key});

  @override
  State<SplashPreviewScreen> createState() => _SplashPreviewScreenState();
}

class _SplashPreviewScreenState extends State<SplashPreviewScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate splash delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pop(); // Return to previous screen after delay
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match native splash background
      body: Center(
        child: Image.asset(
          'assets/logo.png', // The generated splash image (Logo+Text)
          width: MediaQuery.of(context).size.width * 0.5, // Verify scale later
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
