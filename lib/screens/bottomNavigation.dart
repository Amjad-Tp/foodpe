import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/add_screen.dart';
import 'package:foodpe/screens/code_Extraction/color.dart';
import 'package:foodpe/screens/collections_screen.dart';
import 'package:foodpe/screens/home_screen.dart';
import 'package:foodpe/screens/user_screen.dart';
import 'package:hive_flutter/adapters.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late final User user;
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    final userBox = Hive.box<User>('userBox');
    user = userBox.get('userData')!;

    _screens = [
      HomeScreen(user: user),
      const CollectionsScreen(),
      const AddScreen(),
      UserScreen(user: user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            selectedItemColor:
                isDarkMode ? darkModeColor : const Color(0xFFE27619),
            unselectedItemColor: Colors.grey,
            iconSize: 27,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline),
                activeIcon: Icon(Icons.bookmark),
                label: 'My Collections',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_rounded),
                activeIcon: Icon(Icons.add_circle),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.circleUser),
                activeIcon: Icon(FontAwesomeIcons.solidCircleUser),
                label: 'User',
              ),
            ],
          ),
        );
      },
    );
  }
}
