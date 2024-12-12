import 'package:flutter/material.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/screens/code_Extraction/app_bar_theme.dart';
import 'package:hive_flutter/adapters.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkMode;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final settingsBox = Hive.box('settingsBox');
    isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
  }

  void toggleDarkMode(bool value) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isDarkMode = value;
      themeNotifier.value = value;
    });

    final settingsBox = Hive.box('settingsBox');
    await settingsBox.put('isDarkMode', isDarkMode);

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              OurAppBarTheme(
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text(
                        "Dark Theme",style: TextStyle(fontSize: 20),
                      ),
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: toggleDarkMode,
                        activeColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          if(isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(color: isDarkMode ? Colors.white : const Color(0xFFE27619),strokeWidth: 3,),
                    ),
                    const SizedBox(height: 10,),
                    Text('Loading',style: TextStyle(fontSize: 15,color: isDarkMode ? Colors.white : const Color(0xFFE27619)),)
                  ],
                ),
              ),
            )
        ],
      ),
    ));
  }
}
