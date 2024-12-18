import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/model/food_model.dart';

Future<void> publishingFood(
  String name,
  String cookTime,
  String category,
  String preperation,
  String calories,
  String protein,
  String carbohydrates,
  String fats,
  List<String> ingredients,
  BuildContext context, [
  String? addFoodImagePath,
]) async {
  
  if (name.isEmpty ||
      cookTime.isEmpty ||
      category.isEmpty ||
      ingredients.isEmpty ||
      preperation.isEmpty ||
      calories.isEmpty ||
      protein.isEmpty ||
      carbohydrates.isEmpty ||
      fats.isEmpty) {
    return showMessage(context, 'You missed fill out any item', Colors.white);
  }

  final foodRecipeItem = Food(
    foodImagePath: addFoodImagePath,
    title: name,
    cookTime: cookTime,
    category: category,
    ingredients: ingredients,
    preparation: preperation,
    calories: calories,
    protein: protein,
    carbohydrates: carbohydrates,
    fats: fats,
  );

  addFoodRecipe(foodRecipeItem);

  showMessage(
      context, 'Your Food Recipe added succefully', Colors.white, Colors.black);
}
