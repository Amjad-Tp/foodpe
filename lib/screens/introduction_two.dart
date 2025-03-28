import 'package:flutter/material.dart';
import 'package:foodpe/screens/code_Extraction/text_button_usable.dart';

class IntroductionTwo extends StatelessWidget {
  final PageController pageController;

  const IntroductionTwo({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //---------Background Image
          SizedBox(
            height: 600,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/avacado_toast.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          //---------Top Text
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '20+ Premium Recipe',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),

          //----------Bottom Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    //----------Title
                    Text(
                      'Save & Share',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),

                    //----------Description
                    Text(
                      'Save your favorite recipes for quick access,\nand share your creations with the\ncommunity! Choose Your Skill Level\nfrom beginner to advanced, choose recipes\nbased on your cooking experience',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          //----------Next Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 65.0),
              child: TextButtonUsable(
                backgroundColor: const Color(0xFFE27619),
                onPressed: (){
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                text: 'Next'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
