import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/drawer/food_quotes.dart';
import 'package:foodpe/screens/drawer/meal_palanner_screen.dart';
import 'package:foodpe/screens/drawer/privacy_policy.dart';
import 'package:foodpe/screens/drawer/settings.dart';
import 'package:foodpe/screens/drawer/your_special.dart';
import 'package:foodpe/screens/user_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DrawerHeader(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: userNotifier,
              builder: (BuildContext context,User user,Widget? child) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => UserScreen(user: user)));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                          image: user.imagePath != null
                              ? DecorationImage(
                                image:FileImage(File(user.imagePath!)))
                              : null,
                        ),
                        child: user.imagePath == null
                              ? const Icon(Icons.person,size: 70,color: Colors.grey,)
                              : null,
                      ),
                    ),
            
                    Text(user.name,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                    Text(user.email,style: const TextStyle(fontSize: 20),),
                  ],
                );
              },
            ),

            const SizedBox(height: 10,),
          
            const Divider(),
        
            const SizedBox(height: 10,),
            
            //----------Privacy & Policy
            _buildDrawerItem(
              icon: Icons.privacy_tip_outlined,
              text: 'Privacy & Policy',
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => PrivacyPolicy()));
              }
            ),
            
            //----------Your specials
            _buildDrawerItem(
              icon: Icons.archive_outlined,
              text: 'Your Specials',
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const YourSpecial()));
              }
            ),
        
            //----------Food Quotes
            _buildDrawerItem(
              icon: Linecons.food,
              text: 'Food Quotes',
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const FoodQuotes()));
              }
            ),
        
            //----------Meal Planner
            _buildDrawerItem(
              icon: Icons.fastfood_rounded,
              text: 'Meal Planner',
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MealPlannerScreen()));
              }
            ),
            
            //----------Settings
            _buildDrawerItem(
              icon: Icons.settings_outlined,
              text: 'Settings',
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
              }
            ),
          ],
        ),
        
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap
  }){
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:  8.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 15,),
              Text(text,style: const TextStyle(fontSize: 20),)
            ],
          ),
        ),
      ),
    );
  }
}