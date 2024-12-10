import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:foodpe/screens/code_Extraction/app_bar_theme.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/screens/drawer/edit_food_screen.dart';
import 'package:hive_flutter/adapters.dart';

class YourSpecial extends StatefulWidget {
  const YourSpecial({super.key});

  @override
  State<YourSpecial> createState() => _YourSpecialState();
}

bool isCollected = false;

class _YourSpecialState extends State<YourSpecial> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Column(
          children: [
            //------Appbar
            OurAppBarTheme(
              title: 'Your Specials',
              onTap: (){
                Navigator.pop(context);
              }
            ),
            
            //----------List
            ValueListenableBuilder(
              valueListenable: foodListNotifier,
              builder: (BuildContext context,List<Food> food,Widget? child) {
                if(food.isEmpty){
                  return const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(child: Text('No items added'),),
                  );
                }else{
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0,left: 10,right: 10),
                      child: ListView.builder(
                        itemCount: food.length,
                        itemBuilder: (context, index) {
                          final foodRecipe = food[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    child: foodRecipe.foodImagePath == null 
                                        ? const Icon(Linecons.food,size: 80,color: Colors.grey,)
                                        : ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image(
                                            image: FileImage(File(foodRecipe.foodImagePath!)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  ),
                                
                                  ListTile(
                                    title: Text(foodRecipe.title,style: const TextStyle(fontSize: 20),),
                                    subtitle: Text(foodRecipe.category,style: const TextStyle(fontSize: 17),),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            final settingsBox = Hive.box('settingsBox');
                                            final userEmail = settingsBox.get('userEmail');

                                            final updatedFood = await Navigator.of(context).push<Food>(
                                              MaterialPageRoute(
                                                builder: (ctx) => EditFoodScreen(foodRecipe: foodRecipe, index: index),
                                              ),
                                            );

                                            if (updatedFood != null) {
                                              editFoodRecipe(userEmail, updatedFood);
                                            }
                                          },
                                          icon: const Icon(Icons.mode_edit_outline_outlined, size: 27),
                                        ),
                                
                                        IconButton(
                                          onPressed: () async{
                                            await deleteConfirmation(context, index);
                                          },
                                          icon: const Icon(Icons.delete_outline_rounded,size: 28,)
                                        ),
                                        
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteConfirmation(BuildContext context, int index) async{
    final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this recipe?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    deleteFoodRecipe(index);
  }
  }
}