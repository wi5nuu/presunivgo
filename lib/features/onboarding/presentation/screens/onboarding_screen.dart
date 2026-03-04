import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/pu_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Exclusive Network",
      description:
          "Connect with students, alumni, and lecturers exclusively from President University.",
      icon: Icons.hub_outlined,
      color: AppColors.royalBlue,
    ),
    OnboardingData(
      title: "Career Growth",
      description:
          "Access premium job listings and internships tailored for your major.",
      icon: Icons.work_outline_rounded,
      color: AppColors.success,
    ),
    OnboardingData(
      title: "AI MentorBot",
      description:
          "Get AI-powered career advice, CV reviews, and roadmap planning 24/7.",
      icon: Icons.psychology_outlined,
      color: AppColors.warning,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _isLastPage = index == _pages.length - 1);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: page.color.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        page.icon,
                        size: 120,
                        color: page.color,
                      )
                          .animate()
                          .scale(duration: 600.ms, curve: Curves.easeOutBack)
                          .shake(hz: 2),
                      const SizedBox(height: 60),
                      Text(
                        page.title,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navy,
                                ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
                      const SizedBox(height: 24),
                      Text(
                        page.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.royalBlue,
                    dotColor: AppColors.border,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                  ),
                ),
                const SizedBox(height: 48),
                _isLastPage
                    ? PUButton(
                        text: "Get Started",
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('has_seen_onboarding', true);
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                      ).animate().fadeIn().scale()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () =>
                                _pageController.jumpToPage(_pages.length - 1),
                            child: const Text("Skip",
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                          ),
                          SizedBox(
                            width: 120,
                            child: PUButton(
                              text: "Next",
                              isFullWidth: false,
                              onPressed: () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
