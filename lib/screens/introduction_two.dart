import 'package:flutter/material.dart';
import 'package:foodpe/screens/get_start.dart';
import 'package:foodpe/screens/introduction_one.dart';

class IntroductionTwo extends StatelessWidget {
  const IntroductionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //---------image
          SizedBox(
            height: 600,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                  'assets/images/avacado_toast.jpg',
                  fit: BoxFit.cover,
                  ),
            ),
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
                padding: const EdgeInsets.only(top: 25),
                child:  Column(
                  children: [
    
                    //----------Description
                    const Text('Save & Share',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20),),
                    const Text('Save your favorite recipes for quick access,\nand share your creations with the\ncommunity! Choose Your Skill Level\nfrom beginner to advanced, choose recipes\nbased on your cooking experience',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 18),
                        textAlign: TextAlign.center,
                    ),
    
                    const SizedBox(height: 15,),
    
                    //------Next button
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const GetStart()));
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
    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //-------Back Button
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const IntroductionOne()));
                            },
                            child: const Text('Back',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)),
                        ),
    
                        //-------Skip Button
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const GetStart()));
                            },
                            child: const Text('Skip',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)),
                        )
                      ],
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