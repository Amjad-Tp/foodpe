import 'package:flutter/material.dart';

class FoodQuotes extends StatelessWidget {
  const FoodQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> quotes = [
      '"Food is symbolic of love when words are inadequate."',
      '"Cooking is like love. It should be entered into with abandon or not at all."',
      '"People who love to eat are always the best people."',
      '"Good food is the foundation of genuine happiness."',
      '"One cannot think well, love well, sleep well if one has not dined well."',
      '"Life is uncertain. Eat dessert first."',
    ];

    List<String> teller = [
      '– Alan D. Wolfelt',
      '– Harriet Van Horne',
      '– Julia Child',
      '– Auguste Escoffier',
      '– Virginia Woolf',
      '– Ernestine Ulmer',
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the screen width is large enough for a side-by-side layout
          bool isLargeScreen = constraints.maxWidth > 600;

          if (isLargeScreen) {
            return Row(
              children: [
                // Left side: Image with Stack
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/images/food quotes.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Delightful Food Quotes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side: List of quotes
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: quotes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quotes[index],
                              style: const TextStyle(fontSize: 19),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(teller[index]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            // Default layout for small screens
            return ListView(
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 3,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/images/food quotes.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 10,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Delightful Food Quotes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quotes[index],
                            style: const TextStyle(fontSize: 19),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(teller[index]),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
