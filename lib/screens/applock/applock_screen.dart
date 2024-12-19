import 'package:flutter/material.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/screens/bottomNavigation.dart';
import 'package:hive_flutter/adapters.dart';

class ApplockScreen extends StatefulWidget {
  const ApplockScreen({super.key});

  @override
  State<ApplockScreen> createState() => _ApplockScreenState();
}

class _ApplockScreenState extends State<ApplockScreen> {

  final List<String> _pin = ['','','',''];

  void _onBackspaceClicked() {
    for(int i=_pin.length-1;i >= 0;i--){
      if(_pin[i].isNotEmpty){
        setState(() {
          _pin[i] = '';
        });
        break;
      }
    }
  }

  void onNumberClicked(String number) {
    for(int i = 0;i < _pin.length; i++){
      if(_pin[i].isEmpty){
        setState(() {
          _pin[i] = number;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('Welcome',style: TextStyle(color: Colors.black,fontSize: 50,fontWeight: FontWeight.w500),),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: _pin[index].isNotEmpty
                      ? Colors.black
                      : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                ),
              );
            }),
          ),
    
          const SizedBox(height: 80,),
    
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 80
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
          
              if(index == 11){
                return InkWell(
                  onTap: () {
                    pinValidation(context);
                  },
                  child: Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Text('OK',style: TextStyle(fontSize: 23,color: Colors.black),)
                  ),
                );
              }
              
              if(index == 10){
                return InkWell(
                  onTap: _onBackspaceClicked,
                  child: Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.backspace_rounded,color: Colors.black)
                  ),
                );
              }
          
              String number = (index < 9) ? (index + 1).toString() : '0';
              return InkWell(
                  onTap: () => onNumberClicked(number),
                  splashColor: Colors.black54,
                  highlightColor: Colors.black12,
                  child: Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: Text(number,style: const TextStyle(fontSize: 25,color: Colors.black),)
                  ),
                );
            },
          )
        ],
      ),
    );
  }

  Future<void> pinValidation(BuildContext context) async{
    final settingsBox = Hive.box('settingsBox');
    final createdPin = settingsBox.get('applock');

    final enteredPin = _pin.join();

    if(createdPin != null && enteredPin == createdPin){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => BottomNavigation()), (Route<dynamic> route) => false);
    }else{
      showMessage(context, 'Incorrect PIN',Colors.black,Colors.white);
    }
  }
}