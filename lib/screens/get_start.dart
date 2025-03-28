import 'package:flutter/material.dart';
import 'package:foodpe/screens/applock/set_applock_screen.dart';
import 'package:foodpe/screens/code_Extraction/text_button_usable.dart';

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
                padding: EdgeInsets.only(top: 40),
                child:  Column(
                  children: [
                    Text('Ready to start\nyour cooking\njourney?',
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 36,height: 1.1),
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