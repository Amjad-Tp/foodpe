import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/functions/nr_functions.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/screens/code_Extraction/custom_textfield.dart';
import 'package:foodpe/screens/code_Extraction/whole_custom_t_field.dart';

class EditaddForms extends StatefulWidget {
  final Food foodRecipe;
  final int index;
  final String? selectedImagePath;
  const EditaddForms(
      {super.key,
      required this.foodRecipe,
      required this.index,
      required this.selectedImagePath});

  @override
  State<EditaddForms> createState() => _EditaddFormsState();
}

class _EditaddFormsState extends State<EditaddForms> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController name;
  late final TextEditingController cookTime;
  late final TextEditingController category;
  late final TextEditingController preparation;
  late final TextEditingController calories;
  late final TextEditingController protein;
  late final TextEditingController carbohydrates;
  late final TextEditingController fats;

  final List<TextEditingController> _ingredientsControllers = [];

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.foodRecipe.title);
    cookTime = TextEditingController(text: widget.foodRecipe.cookTime);
    category = TextEditingController(text: widget.foodRecipe.category);
    preparation = TextEditingController(text: widget.foodRecipe.preparation);
    calories =
        TextEditingController(text: widget.foodRecipe.calories.toString());
    protein = TextEditingController(text: widget.foodRecipe.protein.toString());
    carbohydrates =
        TextEditingController(text: widget.foodRecipe.carbohydrates.toString());
    fats = TextEditingController(text: widget.foodRecipe.fats.toString());

    for (var ingredient in widget.foodRecipe.ingredients) {
      _ingredientsControllers.add(TextEditingController(text: ingredient));
    }
  }

  Future<void> _publishFood(int index) async {
    final updatedFood = Food(
      foodImagePath:
          widget.selectedImagePath ?? widget.foodRecipe.foodImagePath,
      title: name.text,
      cookTime: cookTime.text,
      category: category.text.trim(),
      ingredients: _ingredientsControllers.map((e) => e.text).toList(),
      preparation: preparation.text,
      calories: calories.text,
      protein: protein.text,
      carbohydrates: carbohydrates.text,
      fats: fats.text,
    );
    await editFoodRecipe(index, updatedFood);
    showMessage(context, 'Updated Successfully');
    Navigator.pop(context, updatedFood);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.value;

    return Form(
        key: _formKey,
        child: Column(
          children: [
            WholeCustomTextField(
                name: name, cookTime: cookTime, category: category),

            //Ingredients
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ingredients",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                )),

            Column(
              children: List.generate(_ingredientsControllers.length, (index) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomTextfield(
                      controller: _ingredientsControllers[index],
                      hintText: 'Ingredients ${index + 1}',
                      validator: (value) => validateField(
                        value: value,
                        fieldName: 'Ingredient ${index + 1}',
                      ),
                    ));
              }),
            ),

            TextButton.icon(
              onPressed: () {
                setState(() {
                  _ingredientsControllers.add(TextEditingController());
                });
              },
              label: const Text(
                'Ingredient',
                style: TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.add_rounded),
              style: TextButton.styleFrom(
                  foregroundColor: isDarkMode ? Colors.white : Colors.black),
            ),

            const SizedBox(
              height: 15,
            ),

            //Cooking Process
            MultilineTextfield(
                controller: preparation,
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
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
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
                        controller: calories,
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
                        controller: protein,
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
                        controller: carbohydrates,
                        suffixText: 'g.',
                        errorText: 'Give the Carbohydrates of your food')),
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
                        controller: fats,
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
                CancelButton(
                    onPressed: () => Navigator.pop(context), text: "Cancel"),

                const SizedBox(
                  width: 10,
                ),

                //---------change Button
                SavingGreenOrange(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _publishFood(widget.index);
                      }
                    },
                    text: "change")
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}
