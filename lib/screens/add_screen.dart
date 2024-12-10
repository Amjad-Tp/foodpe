import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/screens/code_Extraction/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  String? addFoodImagePath;

  final _nameController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _preparationController = TextEditingController();

  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbohydratesController = TextEditingController();
  final _fatsController = TextEditingController();

  final List<TextEditingController> _ingredientsControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {

    final isDarkMode = themeNotifier.value;
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              const Text(
                "Recipe Image:",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () async {
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      addFoodImagePath = pickedFile.path;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF545454) : const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                    image: addFoodImagePath != null
                        ? DecorationImage(
                            image: FileImage(File(addFoodImagePath!)),
                            fit: BoxFit.cover)
                        : null,
                  ),
                  child: addFoodImagePath == null
                      ? const Icon(
                          Icons.image_outlined,
                          color: Colors.grey,
                          size: 60,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: _nameController,
                        hintText: 'Recipe Title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Give the good title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
      
                      //----------CookTime
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Cook time(average time)',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: CustomTextfield(
                              controller: _cookTimeController,
                              hintText: '2hr 30min',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Give the Cook Time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //-------Category
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: CustomTextfield(
                              controller: _categoryController,
                              hintText: 'eg: Breakfast, Lunch, Snacks Dinner',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Fill this category field';
                                } else if (value.trim() != 'Breakfast' &&
                                    value.trim() != 'Lunch' &&
                                    value.trim() != 'Snacks' &&
                                    value.trim() != 'Dinner') {
                                  showMessage(context,
                                      'You only have 4 categories, Breakfast, Lunch, Snacks and Dinner. please enter this correctly.',Colors.white,Colors.black);
                                  return 'Please Enter correctly';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //Ingredients
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Ingredients",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w500),
                          )),
      
                      Column(
                        children: List.generate(_ingredientsControllers.length,
                            (index) {
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: CustomTextfield(
                                controller: _ingredientsControllers[index],
                                hintText: 'Ingredients ${index + 1}',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Give Ingredients properly';
                                  }
                                  return null;
                                },
                              ));
                        }),
                      ),
      
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _ingredientsControllers
                                .add(TextEditingController());
                          });
                        },
                        label: const Text(
                          'Ingredient',
                          style: TextStyle(fontSize: 18),
                        ),
                        icon: const Icon(Icons.add_rounded),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //Cooking Process
                      MultilineTextfield(
                          controller: _preparationController,
                          hintText: 'Describe your cooking process here...',
                          errorText: 'Explain your your cooking process'),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //Nutritional Information
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Nutritional Information",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w500),
                          )),
      
                      //Calories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                              width: 150,
                              child: Text(
                                'Calories',
                                style: TextStyle(fontSize: 20),
                              )),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: NutritionalTextField(
                              controller: _caloriesController,
                              suffixText: 'kcal',
                              errorText: 'Give the Calories of your food'
                            )
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //Protien
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                              width: 150,
                              child: Text(
                                'Protien',
                                style: TextStyle(fontSize: 20),
                              )),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: NutritionalTextField(
                              controller: _proteinController,
                              suffixText: 'g.',
                              errorText: 'Give the Protien of your food'
                            )
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //Carbohydrates
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                              width: 150,
                              child: Text(
                                'Carbohydrates',
                                style: TextStyle(fontSize: 20),
                              )),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: NutritionalTextField(
                              controller: _carbohydratesController,
                              suffixText: 'g.',
                              errorText: 'Give the Carbohydrates of your food'
                            )
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //Fats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                              width: 150,
                              child: Text(
                                'Fats',
                                style: TextStyle(fontSize: 20),
                              )),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: NutritionalTextField(
                              controller: _fatsController,
                              suffixText: 'g.',
                              errorText: 'Give the Fats of your food'
                            )
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
      
                      //Publish Button--------
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            publishingFood();
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 8),
                          backgroundColor: isDarkMode ? const Color(0xFF033842) : const Color(0xFFE08C43),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Publish',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
      
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> publishingFood() async {
    final name = _nameController.text;
    final cookTime = _cookTimeController.text;
    final category = _categoryController.text.trim();
    final preperation = _preparationController.text;
    final calories = _caloriesController.text;
    final carbohydrates = _carbohydratesController.text;
    final protein = _proteinController.text;
    final fats = _fatsController.text;

    final ingredients = _ingredientsControllers
        .map((controller) => controller.text.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();

    if (name.isEmpty ||
        cookTime.isEmpty ||
        category.isEmpty ||
        ingredients.isEmpty ||
        preperation.isEmpty ||
        calories.isEmpty ||
        protein.isEmpty ||
        carbohydrates.isEmpty ||
        fats.isEmpty) {
      return showMessage(context, 'You missed fill out any item',Colors.white);
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

    showMessage(context, 'Your Food Recipe added succefully',Colors.white,Colors.black);

    _nameController.clear();
    _cookTimeController.clear();
    _categoryController.clear();
    
    for (var 
    controller in _ingredientsControllers) {
      controller.clear();
    }
    _ingredientsControllers.removeRange(2, _ingredientsControllers.length);
    
    _preparationController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbohydratesController.clear();
    _fatsController.clear();
    addFoodImagePath = null;
  }
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _cookTimeController.dispose();
    _categoryController.dispose();
    _preparationController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbohydratesController.dispose();
    _fatsController.dispose();
    for (final controller in _ingredientsControllers) {
      controller.dispose();
    }
  }
}
