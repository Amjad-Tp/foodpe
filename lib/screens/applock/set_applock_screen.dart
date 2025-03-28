import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/nr_functions.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/applock/terms_conditions.dart';
import 'package:foodpe/screens/code_Extraction/text_button_usable.dart';
import 'package:image_picker/image_picker.dart';

class SetApplockScreen extends StatefulWidget {
  const SetApplockScreen({super.key});

  @override
  State<SetApplockScreen> createState() => _SetApplockScreenState();
}

class _SetApplockScreenState extends State<SetApplockScreen> {

  final _formKey = GlobalKey<FormState>();

  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    bool screenWidth = MediaQuery.of(context).size.width > 450;

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: screenWidth ? 400 : 310,
                  child: Image.asset('assets/images/login_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
                  
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    height: screenWidth ? 500 : 640,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(130))
                    ),
                  
                    
                    child: Column(
                      children: [
                    
                        const SizedBox(height: 25,),
                    
                        if(!kIsWeb)
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 45,
                            backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
                            child: imagePath == null ? const Icon(Icons.camera_alt_outlined, size: 35,color: Colors.grey,) : null,
                          ),
                          onTap: () async{
                            final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                            if(pickedFile != null){
                              setState(() {
                                imagePath = pickedFile.path;
                              });
                            }
                          },
                        ),
                    
                        const SizedBox(height: 20,),
                        
                        Form(
                          key: _formKey,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: screenWidth
                                    ? 400
                                    : double.infinity,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 27),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(hintText: 'Email'),
                                      validator: (value) => validateField(value: value, fieldName: 'Email', email: value)
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: const InputDecoration(hintText: 'Name'),
                                      validator: (value) => validateField(value: value, fieldName: 'User Name')
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      decoration: const InputDecoration(hintText: 'Phone Number'),
                                      validator: (value) => validateField(value: value, fieldName: "Phone Number", allowedValues: value),
                                    ),

                                    const SizedBox(height: 15),
                                    
                                    // --------Next Button---------
                                    TextButtonUsable(
                                      backgroundColor: const Color(0xFFE27619),
                                      onPressed: () {
                                        settingPin(context);
                                      }, text: 'Next',
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //-------------Login validation
  Future<void> settingPin(BuildContext context) async {
    if(_formKey.currentState!.validate()){
      final email = _emailController.text.trim();

      final newApplock = User(
        name: _nameController.text,
        email: email,
        phoneNumber: _phoneNumberController.text,
        imagePath: imagePath
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => TermsConditions(user: newApplock,)));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
  }
}