import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/code_Extraction/hardcode_retreive.dart';
import 'package:foodpe/screens/code_Extraction/home_db_retrieve.dart';
import 'package:foodpe/screens/drawer/drawer_screen.dart';
import 'package:foodpe/screens/hardcoded/hardcoded_item.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _openDrawerKey = GlobalKey<ScaffoldState>();
  final List<String> filters = [
    "All",
    "Breakfast",
    "Lunch",
    "Snacks",
    "Dinner"
  ];
  final _searchController = TextEditingController();
  String selectedItem = "All";

  List<Food> filteredFoodList = [];

  List<Map<String, String>> hardcodedFilteredItems = [];

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    filteredFoodList = foodListNotifier.value;
    hardcodedFilteredItems = foodItems;
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
    final hardcodedList = foodItems;

    setState(() {
      filteredFoodList = foodList
          .where((food) =>
              (selectedItem == "All" || food.category == selectedItem) &&
              food.title.toLowerCase().contains(searchQuery))
          .toList();

      hardcodedFilteredItems = hardcodedList
          .where((food) =>
              (selectedItem == "All" || food["category"] == selectedItem) &&
              (food["name"] ?? "").toLowerCase().contains(searchQuery))
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
                        contentPadding:
                            const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                        hintStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black),
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
                              ? isDarkMode
                                  ? const Color(0xFF077B92)
                                  : const Color(0xFFE27619)
                              : Colors.transparent,
                          side: BorderSide(
                              color: isSelected
                                  ? isDarkMode
                                      ? const Color(0xFF077B92)
                                      : const Color(0xFFE27619)
                                  : isDarkMode
                                      ? Colors.white
                                      : const Color(0xFFE78D3E)),
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

              const SizedBox(
                height: 10,
              ),

                // Display the filtered list
                HomeDbRetrieve(selectedItem: selectedItem, searchController: _searchController),

                //Hard coded item
                HardcodeRetreive(hardcodedFilteredItems: hardcodedFilteredItems)
              ],
            )
          ),
        )
      );
    }
  }

