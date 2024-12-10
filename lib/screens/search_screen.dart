import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 60,),

            TextField(
              decoration: InputDecoration(
                hintText: 'What would you like to eat today?',
                suffixIcon: Icon(Icons.search,color: Colors.grey[600],),
              ),
            ),
            const SizedBox(height: 20,),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Amjad $index', style: const TextStyle(fontSize: 17,),),
                  );
                },
                itemCount: 50,
              )
            )
          ],
        ),
      ),
    );
  }
}