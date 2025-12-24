import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../localization/generated/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    // Navigate to preferences setup instead of finishing
    context.push('/onboarding/preferences');
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    
    final List<OnboardingPageData> pages = [
      // Page 1: Quick Record (previously page 4)
      OnboardingPageData(
        title: tr.onboardingQuickTitle,
        subtitle: tr.onboardingQuickSubtitle,
        description: tr.onboardingQuickDesc,
        imagePath: 'assets/images/onboarding_quickrecord.png',
        color: const Color(0xFF009688), // Teal
      ),
      // Page 2: Statistics
      OnboardingPageData(
        title: tr.onboardingStatsTitle,
        subtitle: tr.onboardingStatsSubtitle,
        description: tr.onboardingStatsDesc,
        imagePath: 'assets/images/onboarding_statistics.png',
        color: const Color(0xFF2196F3),
      ),
      // Page 3: Management
      OnboardingPageData(
        title: tr.onboardingMgmtTitle,
        subtitle: tr.onboardingMgmtSubtitle,
        description: tr.onboardingMgmtDesc,
        imagePath: 'assets/images/onboarding_management.png',
        color: const Color(0xFF1565C0), // Dark Blue
      ),
      // Page 4: Savings (previously page 1, now purple to match 3D wallet image)
      OnboardingPageData(
        title: tr.onboardingSavingsTitle,
        subtitle: tr.onboardingSavingsSubtitle,
        description: tr.onboardingSavingsDesc,
        imagePath: 'assets/images/onboarding_savings.png',
        color: const Color(0xFF7B1FA2), // Purple (matching wallet 3D)
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: pages[index]);
                },
              ),
            ),
            
            // Bottom Controls Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 32 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                              ? pages[_currentPage].color 
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Next Button
                  GestureDetector(
                    onTap: () {
                      if (_currentPage < pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastEaseInToSlowEaseOut,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: pages[_currentPage].color,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: pages[_currentPage].color.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == pages.length - 1 ? tr.onboardingGetStarted : tr.onboardingNext,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ],
                      ),
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
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Area with Background Shape
        Expanded(
          flex: 6,
          child: Stack(
            children: [
              // Abstract Background Shape
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: -20,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // Main Image
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                         BoxShadow(
                           color: data.color.withOpacity(0.2),
                           blurRadius: 20,
                           offset: const Offset(0, 10),
                         ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.asset(
                        data.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Text Content
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Text(
                   data.title.toUpperCase(),
                   style: GoogleFonts.outfit(
                     color: data.color,
                     fontWeight: FontWeight.bold,
                     fontSize: 14,
                     letterSpacing: 2.0,
                   ),
                 ),
                 const SizedBox(height: 12),
                 Text(
                   data.subtitle,
                   style: GoogleFonts.outfit(
                     fontSize: 40,
                     fontWeight: FontWeight.bold,
                     color: AppColors.textPrimary,
                     height: 1.1,
                   ),
                 ),
                 const SizedBox(height: 16),
                 Text(
                   data.description,
                   style: GoogleFonts.outfit(
                     fontSize: 16,
                     color: Colors.grey[600],
                     height: 1.6,
                   ),
                 ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPageData {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color color;

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}
