import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/code_Extraction/color.dart';
import 'package:foodpe/screens/code_Extraction/hardcode_retreive.dart';
import 'package:foodpe/screens/code_Extraction/home_db_retrieve.dart';
import 'package:foodpe/screens/drawer/drawer_screen.dart';
import 'package:foodpe/screens/hardcoded/hardcoded_item.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CrslController extends GetxController {
  var crslTexts = [
    "Welcome to FoodPe",
    "Discover Preloaded Recipes for Quick Inspiration!",
    "Customize and Create Your Own Recipe Collection!",
    "Never Forget a Recipe Again - Keep Notes in One Place!",
    "Explore Delicious Dishes & Add Your Own Twist!",
    "Get Inspired by Our Handpicked Recipes!",
    "Plan Your Meals with Saved & Preloaded Recipes!",
    "Enjoy Cooking with Step-by-Step Recipe Notes!",
  ].obs;
}

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
  final CrslController crslController = Get.put(CrslController());

  String selectedItem = "All";
  List<Food> filteredFoodList = [];
  List<Map<String, String>> hardcodedFilteredItems = [];
  late bool isDarkMode;
  bool isSearching = false;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 230,
                padding: const EdgeInsets.only(top: 23),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  gradient: LinearGradient(
                    colors: isDarkMode == false
                        ? [const Color(0xFFF0AA6C), const Color(0xFFE27619)]
                        : [const Color(0xFFA5E664), const Color(0xFF4B9017)],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 16.0, left: 16, top: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => CarouselSlider(
                              options: CarouselOptions(
                                height: 70,
                                aspectRatio: 6,
                                autoPlay: true,
                                reverse: false,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                viewportFraction: 1.0,
                                scrollDirection: Axis.horizontal,
                                initialPage: 0,
                              ),
                              items: crslController.crslTexts.map((text) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(left: 7),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    text,
                                    style: const TextStyle(
                                      height: 1,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isSearching
                                ? const SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      _openDrawerKey.currentState?.openDrawer();
                                    },
                                    child: const Icon(
                                      Icons.menu_rounded,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                  ).animate().fade(
                                    duration:
                                        const Duration(milliseconds: 500)),
                            Flexible(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: isSearching
                                    ? MediaQuery.of(context).size.width * 0.92
                                    : 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    if (isSearching)
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: _searchController,
                                          cursorColor: const Color(0xFFE27619),
                                          decoration: const InputDecoration(
                                            hintText: 'Search...',
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16),
                                          ),
                                        ),
                                      ),
                                    IconButton(
                                      icon: Icon(
                                        isSearching
                                            ? MdiIcons.closeCircleOutline
                                            : Icons.search_rounded,
                                        color: Colors.grey[700],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isSearching) {
                                            _searchController.clear();
                                          }
                                          isSearching = !isSearching;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filters.map(
                          (filter) {
                            bool isSelected = selectedItem == filter;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13),
                                  backgroundColor: isSelected
                                      ? isDarkMode
                                          ? darkModeColor
                                          : const Color(0xFFE27619)
                                      : Colors.transparent,
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : isDarkMode
                                            ? Colors.white
                                            : const Color(0xFFE78D3E),
                                  ),
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
                          },
                        ).toList(),
                      ),
                    ),
                    if (filteredFoodList.isEmpty &&
                        hardcodedFilteredItems.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            'No items found...',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      // Display the filtered list
                      HomeDbRetrieve(
                          selectedItem: selectedItem,
                          searchController: _searchController),

                      // Hardcoded items
                      HardcodeRetreive(
                          hardcodedFilteredItems: hardcodedFilteredItems),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
