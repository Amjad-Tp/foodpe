import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/screens/code_Extraction/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';

class EditFoodScreen extends StatefulWidget {
  const EditFoodScreen({super.key, required this.foodRecipe, required this.index});

  final Food foodRecipe;
  final int index;

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedImagePath;

  late final TextEditingController _nameController;
  late final TextEditingController _cookTimeController;
  late final TextEditingController _categoryController;
  late final TextEditingController _preparationController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbohydratesController;
  late final TextEditingController _fatsController;

  final List<TextEditingController> _ingredientsControllers = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodRecipe.title);
    _cookTimeController =TextEditingController(text: widget.foodRecipe.cookTime);
    _categoryController =TextEditingController(text: widget.foodRecipe.category);
    _preparationController =TextEditingController(text: widget.foodRecipe.preparation);
    _caloriesController =TextEditingController(text: widget.foodRecipe.calories.toString());
    _proteinController =TextEditingController(text: widget.foodRecipe.protein.toString());
    _carbohydratesController =TextEditingController(text: widget.foodRecipe.carbohydrates.toString());
    _fatsController =TextEditingController(text: widget.foodRecipe.fats.toString());

    for (var ingredient in widget.foodRecipe.ingredients) {
      _ingredientsControllers.add(TextEditingController(text: ingredient));
    }
  }
  Future<void> _publishFood(int index) async {
    final updatedFood = Food(
      foodImagePath: _selectedImagePath ?? widget.foodRecipe.foodImagePath,
      title: _nameController.text,
      cookTime: _cookTimeController.text,
      category: _categoryController.text.trim(),
      ingredients: _ingredientsControllers.map((e) => e.text).toList(),
      preparation: _preparationController.text,
      calories: _caloriesController.text,
      protein: _proteinController.text,
      carbohydrates: _carbohydratesController.text,
      fats: _fatsController.text,
    );

    await editFoodRecipe(index, updatedFood);

    showMessage(context, 'Updated Successfully',Colors.white,Colors.black);
    
    await Future.delayed(const Duration(seconds: 2));
    
    Navigator.pop(context, updatedFood);
    
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cookTimeController.dispose();
    _categoryController.dispose();
    _preparationController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbohydratesController.dispose();
    _fatsController.dispose();
    for (var controller in _ingredientsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = themeNotifier.value;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Editor',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  )),
              const Text(
                "Recipe Image:",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedImagePath != null
                        ? DecorationImage(
                            image: kIsWeb
                                ? MemoryImage(base64Decode(_selectedImagePath!))
                                : FileImage(File(_selectedImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : widget.foodRecipe.foodImagePath != null
                            ? DecorationImage(
                                image: kIsWeb
                                    ? MemoryImage(base64Decode(widget.foodRecipe.foodImagePath!))
                                    : FileImage(File(widget.foodRecipe.foodImagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: _selectedImagePath == null &&
                          widget.foodRecipe.foodImagePath == null
                      ? const Icon(Icons.camera_alt_outlined,
                          color: Colors.grey, size: 60)
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
                                } else if (!['Breakfast', 'Lunch', 'Snacks', 'Dinner'].contains(value.trim())) {
                                  showMessage(context,
                                      'You only have 4 categories, Breakfast, Lunch, Snacks and Dinner. please enter this correctly.',Colors.white);
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
                            TextButton.styleFrom(foregroundColor: isDarkMode ? Colors.white : Colors.black),
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
                                  errorText: 'Give the Calories of your food')),
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
                                  errorText: 'Give the Protien of your food')),
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
                                  errorText:
                                      'Give the Carbohydrates of your food')),
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
                                  errorText: 'Give the Fats of your food')),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Cancel Button--------
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 8),
                              foregroundColor: isDarkMode ? Colors.white : Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: isDarkMode ? Colors.white : Colors.black,
                                      width: 1.5)),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),

                          const SizedBox(width: 10,),

                          //---------change Button
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _publishFood(widget.index);
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 8),
                              backgroundColor: isDarkMode ? const Color(0xFF8ec43f) : const Color(0xFFE08C43),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Change',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
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

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _selectedImagePath = base64Encode(bytes);
        });
      }
    } else {
      
      final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImagePath = pickedImage.path;
        });
      }
    }
  }
}
