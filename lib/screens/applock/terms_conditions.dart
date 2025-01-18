import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/bottomNavigation.dart';
import 'package:foodpe/screens/code_Extraction/text_button_usable.dart';
import 'package:hive_flutter/adapters.dart';

class TermsConditions extends StatefulWidget {
  final User user;
  const TermsConditions({super.key, required this.user});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {

  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {

    List<String> terms = [
      'Your data is private and accessible only to you. We do not share or access your information.',
      'Your information is not shared with any external parties or services.',
      'We respect your privacy and do not collect or track your activity or data usage within the app.',
      "We are committed to maintaining your data's security and privacy."
    ];

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: double.infinity,
                height: 310,
                child: Image.asset('assets/images/login_background-2.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
                
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 680,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(130))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 25,),
                  
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                          ),
                        ),
                      ),
                          
                      const SizedBox(height: 10,),
                          
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: terms.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('. ', style: TextStyle(fontSize: 30)),
                                  Expanded(child: Text(terms[index], style: const TextStyle(fontSize: 17)))
                                ],
                              ),
                              const SizedBox(height: 10,)
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 30,),
                      
                      Row(
                        children: [
                          Checkbox(
                            value: isAgreed,
                            onChanged: (value) {
                              setState(() {
                                isAgreed = value!;
                              });
                            },
                            activeColor: const Color(0xFFE27619),
                          ),
                          const Expanded(
                            child: Text('By logging in, you agree to our Terms of Service and Privacy Policy.')
                          )
                        ],
                      ),
                      
                      Align(
                        alignment: Alignment.center,
                        child: TextButtonUsable(
                          backgroundColor: isAgreed ? const Color(0xFFE27619) : Colors.grey[300] ?? Colors.grey,
                          onPressed: () async{
                            if (isAgreed) {
                              await addUserData();
                              await Future.delayed(const Duration(seconds: 1));
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (context) => const BottomNavigation()), (Route<dynamic> route) => false);
                            } else {
                              showMessage(context,"I like your Smart, Don't try to be Over smart");
                            }
                          }, text: 'Enter',
                        )
                      ),
                          
                    ]
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  // add user logged in
  Future<void> addUserData() async{
    final settingsBox = Hive.box('settingsBox');
    final userBox = Hive.box<User>('userBox');

    final user = widget.user;

    userBox.put('userData', user);
    
    settingsBox.put('isUserLogged',true);

    if(kIsWeb){
      settingsBox.put('isFirstTimeWeb', false);
    }

    showMessage(context,'Welcome to Food Recipe Note App');
  }
}