import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/screens/item/nutritional_db.dart';
import 'package:hive_flutter/adapters.dart';

class FoodDetailsDB extends StatefulWidget {
  final Food foodRecipe;
  const FoodDetailsDB({super.key, required this.foodRecipe});

  @override
  State<FoodDetailsDB> createState() => _FoodDetailsDBState();
}

bool isCollected = false;

class _FoodDetailsDBState extends State<FoodDetailsDB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth > 600;
          if (isLargeScreen) {
            //----------------Large
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: double.infinity,
                    child: imageStack()
                  ),
                ),
                //----------Details
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: contentItems(context),
                  ),
                ),
              ],
            );
          } else {
            
            // -----------Small
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 390,
                  child: imageStack(),
                ),
                const SizedBox(height: 15),
                contentItems(context)
              ],
            );
          }
        },
      ),
    );
  }

  Padding contentItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 15,right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.foodRecipe.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
      
          const SizedBox(height: 10),
          Text(
            'Category : ${widget.foodRecipe.category}',
            style: const TextStyle(fontSize: 17),
          ),
          Text(
            'Cook Time : ${widget.foodRecipe.cookTime}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 25),
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.foodRecipe.ingredients.map((ingredient) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '- $ingredient',
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          const Text(
            'How to Prepare?',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.foodRecipe.preparation,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 15),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFE78D3E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => NutritionalDB(
                    foodRecipe: widget.foodRecipe,
                  ),
                ),
              );
            },
            child: const Text(
              'View Nutritional Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Stack imageStack() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.foodRecipe.foodImagePath != null)
          kIsWeb
              ? Image.memory(
                  base64Decode(widget.foodRecipe.foodImagePath!),
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(widget.foodRecipe.foodImagePath!),
                  fit: BoxFit.cover,
                ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.8),
                widget.foodRecipe.foodImagePath != null
                    ? Colors.transparent
                    : const Color.fromARGB(119, 30, 30, 30),
              ],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
          child: widget.foodRecipe.foodImagePath == null
              ? const Icon(Linecons.food,size: 130,color: Colors.white,
                )
              : null,
        ),
        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,size: 30,)
          )
        ),
        Positioned(
          top: 40,
          right: 10,
          child: Row(
            children: [
              //----------Add to Food Plan
              IconButton(
                onPressed: () async {
                  final foodDB = Hive.box<Food>('foodBox');
                  final currentPlan = foodDB.values.where((food) => food.isAddedtoPlan).toList();

                  if (!widget.foodRecipe.isAddedtoPlan && currentPlan.length >= 4) {
                    showMessage(context, 'You are reached your limit', Colors.white, Colors.black);
                    return;
                  }

                  setState(() {
                    widget.foodRecipe.isAddedtoPlan = !widget.foodRecipe.isAddedtoPlan;
                  });

                  await foodDB.put(widget.foodRecipe.id, widget.foodRecipe);
                  foodListNotifier.value = foodDB.values.toList().cast<Food>();
                },
                icon: Icon(
                  widget.foodRecipe.isAddedtoPlan
                      ? Icons.add_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),

              //----------Add to Collection
              IconButton(
                onPressed: () async {
                  setState(() {
                    widget.foodRecipe.isCollected = !widget.foodRecipe.isCollected;
                  });

                  final foodDB = Hive.box<Food>('foodBox');
                  await foodDB.put(widget.foodRecipe.id, widget.foodRecipe);
                  foodListNotifier.value = foodDB.values.toList().cast<Food>();
                },
                icon: Icon(
                  widget.foodRecipe.isCollected
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}
