import 'package:flutter/material.dart';
import 'package:foodpe/screens/applock/set_applock_screen.dart';
import 'package:foodpe/screens/code_Extraction/text_button_usable.dart';

class IntroductionOne extends StatelessWidget {
  const IntroductionOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //---------image
          Opacity(
            opacity: 0.6,
            child: Image.asset(
                'assets/images/delicious-burger-with-fresh-ingredients.jpg'),
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '20+ Premium Recipe',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ),
            ),
          ),
    
          //----------container
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
                padding: EdgeInsets.only(top: 35),
                child:  Column(
                  children: [
                
                    //----------Description
                    Text.rich(
                      TextSpan(
                        text: 'Welcome to ',style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w300),
                        children: [
                          TextSpan(
                            text: 'FoodPe ',style: TextStyle(fontWeight: FontWeight.w600)
                          ),
                          TextSpan(
                            text: 'your go-to place for\neasy, delicious recipes! Explore Recipes,\nFind recipes by searching or browsing\nthrough popular categories. Let your\ningredients inspire you!'
                          )
                        ]
                      ),
                      textAlign: TextAlign.center,
                    ),

                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 65.0),
              child: TextButtonUsable(
                backgroundColor: const Color(0xFFE27619),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (context) => const SetApplockScreen()), (Route<dynamic> route) => false),
                text: 'Get Start'
              ),
            ),
          ),
        ],
      ),
    );
  }
}