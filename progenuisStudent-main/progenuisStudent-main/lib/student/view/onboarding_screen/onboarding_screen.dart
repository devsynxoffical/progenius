// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/utils/all_texts.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/auth/login/login.dart';
import 'package:progenius/widgets/custome_button.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imagePath: 'assets/soldier1.png',
      title: AllTexts.onboardingHeading1,
      subtitle: AllTexts.onboardingTitle1,
      description: AllTexts.onboardingdiscription1,
    ),
    OnboardingPageData(
      imagePath: 'assets/soldier2.png',
      title: AllTexts.onboardingHeading2,
      subtitle: AllTexts.onboardingTitle2,
      description: AllTexts.onboardingdiscription2,
    ),
    OnboardingPageData(
      imagePath: 'assets/soldier3.png',
      title: AllTexts.onboardingHeading3,
      subtitle: AllTexts.onboardingTitle3,
      description: AllTexts.onboardingdiscription3,
    ),
  ];

  void _onNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whitColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Waves
            // Positioned(
            //   top: 0,
            //   child: SvgPicture.asset(
            //     'assets/splashTop.svg',
            //     width: screenWidth,
            //     fit: BoxFit.fitWidth,
            //   ),
            // ),
            // Positioned(
            //   bottom: 0,
            //   child: SvgPicture.asset(
            //     'assets/splashBtm.svg',
            //     width: screenWidth,
            //     fit: BoxFit.fitWidth,
            //   ),
            // ),

            // Page Content
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return SingleOnboardingPage(
                        data: _pages[index],
                        currentPage: _currentPage,
                        totalPages: _pages.length,
                      );
                    },
                  ),
                ),

                // Bottom Navigation Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    children: [
                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.secondary
                                  : Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Next/Get Started Button
                      if (_currentPage == _pages.length - 1)
                        CustomButton(
                          text: AllTexts.getStarted,
                          onPressed: () => Get.offAll(() => LoginPage()),
                          
                        )
                      else
                        GestureDetector(
                          onTap: _onNextPage,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple, Colors.pink],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageData {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

class SingleOnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final int currentPage;
  final int totalPages;

  const SingleOnboardingPage({
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: screenHeight * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: screenHeight * 0.35,
            child: Image.asset(
              data.imagePath,
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Title
          Text(
            data.title,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenHeight * 0.01),

          // Subtitle
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Description
          Text(
            data.description,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}