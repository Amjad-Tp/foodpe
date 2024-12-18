import 'package:flutter/material.dart';
import 'package:foodpe/main.dart';

class OurAppBarTheme extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const OurAppBarTheme({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final isDarkMode = themeNotifier.value;
    
    return Container(
      width: double.infinity,
      color: isDarkMode ? const Color(0xFF8ec43f) : const Color(0xFFE27619),
      height: 70,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ],
      ),
    );
  }
}
