import 'package:flutter/material.dart';
import 'package:foodpe/screens/applock/set_applock_screen.dart';
import 'package:foodpe/screens/introduction_two.dart';

class GetStart extends StatelessWidget {
  const GetStart({super.key});

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
                  'assets/images/splash-2.jpg',
                  fit: BoxFit.cover,),
            ),
          ),
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                '30+ Premium Recipe',
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ),
          ),
    
          //----------container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                  color: const Color(0xFF162128),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, -5))
                  ]),
              child:Padding(
                padding: const EdgeInsets.only(top: 40),
                child:  Column(
                  children: [
                    const Text('Ready to start\nyour cooking\njourney?',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 36,height: 1.1),
                        textAlign: TextAlign.center,
                    ),
    
                    const SizedBox(height: 35,),
    
                    //------Next button
                    TextButton(
                      onPressed: (){
                        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=> LoginScreen()), (Route<dynamic> route) => false);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=> const SetApplockScreen()), (Route<dynamic> route) => false);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                        backgroundColor: const Color(0xFFE27619),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: const Text('Get Start',style: TextStyle(fontSize: 20),),
                    ),
    
                    //-------Back Button
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const IntroductionTwo()));
                            },
                            child: const Text('Back',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),)),
                        ),
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