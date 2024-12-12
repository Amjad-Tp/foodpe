import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/screens/code_Extraction/collection_and_plan.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Collections',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                  )),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: foodListNotifier,
                builder: (context, foodList, child) {
                  final collectedFood =
                      foodList.where((food) => food.isCollected).toList();
                  if (collectedFood.isEmpty) {
                    return const Center(
                      child: Text('No collected items found.'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: screenWidth > 500
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 2,
                          ),
                          itemCount: collectedFood.length,
                          itemBuilder: (context, index) {
                            final foodRecipe = collectedFood[index];
                            return FoodItemGesture(foodRecipe: foodRecipe,screenWidth: screenWidth);
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: collectedFood.length,
                          itemBuilder: (context, index) {
                            final foodRecipe = collectedFood[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: FoodItemGesture(foodRecipe: foodRecipe,screenWidth: screenWidth));
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
}
