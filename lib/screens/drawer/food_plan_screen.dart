import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/screens/code_Extraction/app_bar_theme.dart';
import 'package:foodpe/screens/item/food_details_db.dart';

class FoodPlanScreen extends StatelessWidget {
  const FoodPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List<String> addedCategory = ['BreakFast','Lunch','Snacks','Dinner'];
    
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            OurAppBarTheme(
              title: 'Food Plan',
              onTap: () {
                Navigator.of(context).pop();  
              },
            ),
      
            ValueListenableBuilder(
              valueListenable: foodListNotifier,
              builder: (context, foodList, child) {
                final addedplan =
                    foodList.where((food) => food.isAddedtoPlan).toList()
                    ..sort((a,b) => a.addedtoList!.compareTo(b.addedtoList!));
                if (addedplan.isEmpty) {
                  return const Center(
                    child: Text('No added to you plan'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 15,left: 15,right: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addedplan.length,
                    itemBuilder: (context, index) {
                      final foodRecipe = addedplan[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => FoodDetailsDB(
                                  foodRecipe: foodRecipe),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addedCategory[index],style: const TextStyle(fontSize: 26,fontWeight: FontWeight.w600,),),
                              Card(
                                child: SizedBox(
                                  height: 220,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: SizedBox(
                                          height: double.infinity,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: foodRecipe.foodImagePath !=
                                                    null
                                                ? kIsWeb
                                                    ? Image.memory(
                                                        base64Decode(foodRecipe
                                                            .foodImagePath!),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(foodRecipe
                                                            .foodImagePath!),
                                                        fit: BoxFit.cover,
                                                      )
                                                : const Icon(
                                                    Linecons.food,
                                                    color: Color(0xFF5D5D5D),
                                                    size: 100,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  foodRecipe.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25,
                                                    height: 0.8,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text('Authored : ${foodRecipe.category}',style: const TextStyle(fontSize: 17,height: 0.8,),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  foodRecipe.cookTime,
                                                  style: const TextStyle(fontSize: 17,height: 0.8,),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Nutritional Information',
                                                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                                                ),
                                                                            
                                                Text(
                                                  'Calories : ${foodRecipe.calories}',
                                                  style: const TextStyle(fontSize: 17,),
                                                ),
                                                                            
                                                Text(
                                                  'Protein : ${foodRecipe.protein}',
                                                  style: const TextStyle(fontSize: 17,),
                                                ),
                                                                            
                                                Text(
                                                  'Carbohydrates : ${foodRecipe.carbohydrates}',
                                                  style: const TextStyle(fontSize: 17,),
                                                ),
                                                                            
                                                Text(
                                                  'Fats : ${foodRecipe.fats}',
                                                  style: const TextStyle(fontSize: 17,),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      
          ],
        ),
      ),
    );
  }
}