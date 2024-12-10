import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/screens/applock/applock_screen.dart';
import 'package:foodpe/screens/introduction_one.dart';
import 'package:hive_flutter/adapters.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  void _startSplashScreen() async {
    await splashTime(context);
  }

  @override
  Widget build(BuildContext context) {
    getAllFoods();
    return Scaffold(
      backgroundColor: const Color(0xFF162128),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', width: 100),
            const SizedBox(height: 10),
            const Text('FoodPe',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Future<void> splashTime(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    final settingsBox = Hive.box('settingsBox');
    final isSetApplock = settingsBox.get('isSetApplock', defaultValue: false);

    if (isSetApplock) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => ApplockScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const IntroductionOne(),
        ),
      );
    }
  }
}
