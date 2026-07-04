import 'package:flutter/material.dart';
import '../main_shell.dart';
import 'onboarding_data.dart';
import 'pages/welcome_page.dart';
import 'pages/age_page.dart';
import 'pages/height_weight_page.dart';
import 'pages/cycle_info_page.dart';
import 'pages/last_period_page.dart';
import 'pages/goal_page.dart';
import 'pages/conditions_page.dart';
import 'pages/lifestyle_page.dart';
import 'pages/menstrual_history_page1.dart';
import 'pages/menstrual_history_page2.dart';
import 'pages/pain_page.dart';
import 'pages/all_set_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 12;
  final OnboardingData _data = OnboardingData();

  static const primary = Color(0xFF6C3EAB);
  static const bg = Color(0xFFF7F3FF);

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    // Save to Firestore later
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            if (_currentPage > 0 && _currentPage < _totalPages - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: List.generate(_totalPages - 2, (i) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i < _currentPage
                              ? primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  // 0
                  WelcomePage(onNext: _nextPage),
                  // 1
                  AgePage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 2
                  HeightWeightPage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 3
                  CycleInfoPage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 4
                  LastPeriodPage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 5
                  GoalPage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 6
                  ConditionsPage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 7
                  LifestylePage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 8
                  MenstrualHistoryPage1(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 9
                  MenstrualHistoryPage2(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 10
                  PainPage(data: _data, onNext: _nextPage, onBack: _prevPage),
                  // 11
                  AllSetPage(data: _data, onFinish: _finishOnboarding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}