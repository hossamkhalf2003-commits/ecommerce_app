import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/core/styling/app_colors.dart';
import 'package:ecommerce_app/core/styling/app_styles.dart';
import 'package:ecommerce_app/core/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/local_storage/prefs_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // The Data for the 2 pages
  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Discover Top Brands',
      'subtitle': 'Browse through thousands of products from the best brands around the world.',
      'lottie': 'assets/lottie/onboarding_1.json',
    },
    {
      'title': 'Fast & Secure Checkout',
      'subtitle': 'Experience seamless payments and get your items delivered to your doorstep quickly.',
      'lottie': 'assets/lottie/onboarding_2.json',
    },
  ];

  // The logic to save the "Seen" flag and navigate away
  Future<void> _completeOnboarding() async {
    // Grab the hard drive from Riverpod
    final prefs = ref.read(sharedPrefsProvider);
    
    // Save the flag so they never see this screen again!
    await prefs.setBool('has_seen_onboarding', true);

    // Send them to Login (destroying the back history)
    if (mounted) {
      context.goNamed(AppRoutes.loginScreen);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Skip',
                  style: AppStyles.black16w500Style.copyWith(color: AppColors.primaryColor),
                ),
              ),
            ),

            // 2. The Swipeable Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie Animation
                        Lottie.asset(
                          onboardingData[index]['lottie']!,
                          height: 300.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 40.h),
                        
                        // Text Content
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: AppStyles.primaryHeadLinesStyle,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          onboardingData[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: AppStyles.subtitlesStyles,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 3. Bottom Controls (Dots and Button)
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Custom Animated Dot Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 8.h,
                        width: _currentIndex == index ? 24.w : 8.w,
                        decoration: BoxDecoration(
                          color: _currentIndex == index 
                              ? AppColors.primaryColor 
                              : AppColors.greyColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Dynamic Button (Next vs Get Started)
                  PrimaryButtonWidget(
                    buttonText: _currentIndex == onboardingData.length - 1 
                        ? 'Get Started' 
                        : 'Next',
                    onPress: () {
                      if (_currentIndex == onboardingData.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
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