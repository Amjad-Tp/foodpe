import 'package:flutter/material.dart';
import 'package:foodpe/screens/introduction_one.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:foodpe/screens/introduction_two.dart';
import 'package:foodpe/screens/get_start.dart';

class SplashHandling extends StatelessWidget {
  SplashHandling({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: const [
              // Page 1: Introduction One
              IntroductionOne(),

              // Page 2: Introduction Two
              IntroductionTwo(),

              // Page 3: Get Started
              GetStart(),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: _pageController, // PageController
                count: 3, // Number of pages
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Color(0xFFE27619),
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}