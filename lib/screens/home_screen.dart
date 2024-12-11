import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/drawer/drawer_screen.dart';
import 'package:foodpe/screens/item/food_details_db.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _openDrawerKey = GlobalKey<ScaffoldState>();
  final List<String> filters = ["All", "Breakfast", "Lunch", "Snacks", "Dinner"];
  final _searchController = TextEditingController();
  String selectedItem = "All";

  List<Food> filteredFoodList = [];

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    filteredFoodList = foodListNotifier.value;
    _searchController.addListener(_filterItems);

    final settingsBox = Hive.box('settingsBox');
    isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);

    settingsBox.listenable().addListener(() {
      final newDarkMode = settingsBox.get('isDarkMode');
      if (newDarkMode != isDarkMode) {
        setState(() {
          isDarkMode = newDarkMode;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final searchQuery = _searchController.text.toLowerCase();
    final foodList = foodListNotifier.value;

    setState(() {
      filteredFoodList = foodList
          .where((food) =>
              (selectedItem == "All" || food.category == selectedItem) &&
              food.title.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void category(String category) {
    setState(() {
      selectedItem = category;
    });
    _filterItems();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _openDrawerKey,
      drawer: const DrawerWidget(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              // Search Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      _openDrawerKey.currentState?.openDrawer();
                    },
                    child: const Icon(Icons.menu_rounded, size: 40),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        contentPadding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                        hintStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Categories
              const Text(
                'Categories',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((filter) {
                    bool isSelected = selectedItem == filter;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          backgroundColor: isSelected
                              ? isDarkMode ? const Color(0xFF077B92) : const Color(0xFFE27619)
                              : Colors.transparent,
                          side: BorderSide(color: isSelected ? isDarkMode ? const Color(0xFF077B92) : const Color(0xFFE27619) : isDarkMode ? Colors.white : const Color(0xFFE78D3E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          category(filter);
                        },
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),

              // Display the filtered list
              ValueListenableBuilder<List<Food>>(
                valueListenable: foodListNotifier,
                builder: (context, foodList, child) {
                  final filteredList = foodList
                      .where((food) =>
                          (selectedItem == "All" || food.category == selectedItem) &&
                          food.title.toLowerCase().contains(_searchController.text.toLowerCase()))
                      .toList();

                  return filteredList.isNotEmpty
                      ? Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 7.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'My Recipe',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      height: 1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            
                            screenWidth > 500 // Large screen size (tablet and web)
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // More columns for larger screens
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 3 / 2,
                                    ),
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final foodRecipe = filteredList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  FoodDetailsDB(foodRecipe: foodRecipe),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [

                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Opacity(
                                                  opacity: 0.6,
                                                  child: foodRecipe.foodImagePath != null
                                                      ? kIsWeb
                                                          ? Image.memory(
                                                              base64Decode(foodRecipe.foodImagePath!),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(foodRecipe.foodImagePath!),
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
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      foodRecipe.title,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: screenWidth > 700 ? 30 : 20,
                                                        height: 0.8,
                                                      ),
                                                    ),
                                                    Text(
                                                      foodRecipe.category,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: screenWidth > 700 ? 21 : 15,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final foodRecipe = filteredList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    FoodDetailsDB(foodRecipe: foodRecipe),
                                              ),
                                            );
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
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Opacity(
                                                    opacity: 0.7,
                                                    child: foodRecipe.foodImagePath != null
                                                        ? kIsWeb
                                                            ? Image.memory(
                                                                base64Decode(foodRecipe.foodImagePath!),
                                                                fit: BoxFit.cover,
                                                              )
                                                            : Image.file(
                                                                File(foodRecipe.foodImagePath!),
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
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.end,
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
                          ],
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Center(child: Text('No Food added')),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}