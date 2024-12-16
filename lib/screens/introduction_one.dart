import 'package:flutter/material.dart';
import 'package:foodpe/screens/get_start.dart';
import 'package:foodpe/screens/introduction_two.dart';

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
              child:Padding(
                padding: const EdgeInsets.only(top: 35),
                child:  Column(
                  children: [
                
                    //----------Description
                    const Text.rich(
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
                
                    const SizedBox(height: 20,),
                
                    //------Next button
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const IntroductionTwo()));
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                        backgroundColor: const Color(0xFFE27619),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: const Text('Next',style: TextStyle(fontSize: 20),),
                    ),
    
                    //-------Skip Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const GetStart()));
                        },
                        child: const Text('Skip',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)),
                    )
    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
