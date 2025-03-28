import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/screens/applock/set_applock_screen.dart';
import 'package:foodpe/screens/bottomNavigation.dart';
import 'package:foodpe/screens/splash_handling.dart';
import 'package:hive_flutter/adapters.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', width: 150),
          ],
        ),
      ),
    );
  }

  Future<void> splashTime(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final settingsBox = Hive.box('settingsBox');

    if (kIsWeb) {
      final isFirstTimeWeb = settingsBox.get('isFirstTimeWeb', defaultValue: true);

      if (isFirstTimeWeb) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const SetApplockScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const BottomNavigation(),
          ),
        );
      }
    } else {
      final isUserLogged = settingsBox.get('isUserLogged', defaultValue: false);

      if (isUserLogged) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => const BottomNavigation(),
            ),
          );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) =>  SplashHandling(),
          ),
        );
      }
    }
  }
}
