import 'package:flutter/material.dart';
import 'package:foodpe/screens/introduction_one.dart';
import 'package:foodpe/screens/introduction_two.dart';
import 'package:foodpe/screens/get_start.dart';

class SplashHandling extends StatefulWidget {
  const SplashHandling({super.key});

  @override
  _SplashHandlingState createState() => _SplashHandlingState();
}

class _SplashHandlingState extends State<SplashHandling> {
  final PageController _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // Listen to page changes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //---------PageView
          PageView(
            controller: _pageController,
            children: [
              // Page 1: Introduction One
              IntroductionOne(pageController: _pageController),

              // Page 2: Introduction Two
              IntroductionTwo(pageController: _pageController),

              // Page 3: Get Started
              GetStart(),
            ],
          ),

          //---------Progress Bar with Rounded Ends
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / 3,
                  minHeight: 15,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE27619),
                  ),
                  backgroundColor: const Color(0xFFC1C1C1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
