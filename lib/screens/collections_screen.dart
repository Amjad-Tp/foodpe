import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/screens/item/food_details_db.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Align(alignment: Alignment.topLeft, child: Text('Collections',style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500),)),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: foodListNotifier,
                builder: (context, foodList, child) {
                  final collectedFood = foodList.where((food) => food.isCollected).toList();
                  if (collectedFood.isEmpty) {
                    return const Center(
                      child: Text('No collected items found.'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListView.builder(
                      itemCount: collectedFood.length,
                      itemBuilder: (context, index) {
                        final foodRecipe = collectedFood[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (ctx) => FoodDetailsDB(
                                    foodRecipe: foodRecipe),
                              ));
                            },
                            onLongPress: () {
                              collectionRemoveConfirmation(context,foodRecipe);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: foodRecipe.foodImagePath !=
                                              null
                                          ? Image.file(
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          foodRecipe.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                            height: 0.8,
                                          ),
                                        ),
                                        Text(
                                          foodRecipe.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future <void> collectionRemoveConfirmation(BuildContext context, Food foodRecipe) async{

    bool isDarkMode = themeNotifier.value;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF077B92) : Colors.white,
          title: const Text('Remove item'),
          content: Text("Are sure to remove '${foodRecipe.title}' ?",style: const TextStyle(fontSize: 18),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
            ),
            TextButton(
              onPressed: () {
                collectionRemove(foodRecipe, foodRecipe.id!);
                Navigator.of(context).pop();
              },
              child: Text('Remove',style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
            )
          ],
        );
      },
    );
  }
}
