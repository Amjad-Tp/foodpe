import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

class UserEditScreen extends StatefulWidget {
  final User user;
  const UserEditScreen({super.key, required this.user});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _nameController;
  late final TextEditingController _pinController;
  late final TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _nameController = TextEditingController(text: widget.user.name);
    _phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    _confirmController = TextEditingController(text: widget.user.pin);
    if(widget.user.pin != null){
      _pinController = TextEditingController(text: widget.user.pin);
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = themeNotifier.value;
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
                  child: Image.asset(
                    'assets/images/login_background.jpg',
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
                    decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black : Colors.white,
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(130))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),

                        if(!kIsWeb)
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 45,
                            backgroundImage: _selectedImagePath != null
                                ? FileImage(File(_selectedImagePath!))
                                : widget.user.imagePath != null
                                    ? FileImage(File(widget.user.imagePath!))
                                    : null,
                            child: _selectedImagePath == null && widget.user.imagePath == null
                                ? const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 35,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          onTap: () async {
                            final XFile? pickedFile = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _selectedImagePath = pickedFile.path;
                              });
                            }
                          },
                        ),
                        
                        const SizedBox(
                          height: 20,
                        ),
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter your email';
                                        } else if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                          return 'Enter a valid Email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: const InputDecoration(hintText: 'Name'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value.trim().isEmpty) {
                                          return 'Please Enter your Name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      decoration: const InputDecoration(hintText: 'Phone Number'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter your Phone Number';
                                        } else if (value.length != 10) {
                                          return 'Enter a valid Number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: _pinController,
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      obscureText: true,
                                      decoration: const InputDecoration(hintText: 'PIN'),
                                    ),
                                    TextFormField(
                                      controller: _confirmController,
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      obscureText: true,
                                      decoration: const InputDecoration(hintText: 'Confirm PIN'),
                                      validator: (value) {
                                        if (_pinController.text != value) {
                                          return "PIN doesn't match";
                                        }
                                        return null;
                                      },
                                    ),


                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //Cancel Button--------
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 8),
                                            foregroundColor: isDarkMode ? Colors.white : Colors.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                    width: 1.5)),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 10,
                                        ),

                                        //---------change Button
                                        TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              editingUser(context);
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 8),
                                            backgroundColor: isDarkMode ? const Color(0xFF8ec43f) : const Color(0xFFE27619),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Change',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
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
  Future<void> editingUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final editedUser = User(
          name: _nameController.text,
          email: _emailController.text,
          pin: _pinController.text,
          phoneNumber: _phoneNumberController.text,
          imagePath: _selectedImagePath
      );

      final settingsBox = Hive.box('settingsBox');
      final oldPin = settingsBox.get('applock');

      if (_pinController.text.isNotEmpty) {
        if (_pinController.text != oldPin) {
          final newPin = _pinController.text;
          settingsBox.put('applock', newPin);
        }
        settingsBox.put('isSetApplock', true);
      } else {
        settingsBox.put('isSetApplock', false);
      }

      await resetPin(editedUser);

      await Future.delayed(const Duration(seconds: 1));

      Navigator.of(context).pop();
    }
  }

  //--------------------Snack Bar-----------------
  void messageSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        margin: const EdgeInsets.all(16),
        // backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _pinController.dispose();
    _phoneNumberController.dispose();
  }
}
