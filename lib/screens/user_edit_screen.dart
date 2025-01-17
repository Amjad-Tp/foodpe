import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/functions/nr_functions.dart';
import 'package:foodpe/functions/snackbar.dart';
import 'package:foodpe/main.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/code_Extraction/custom_textfield.dart';
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
                        //----------Image Picker
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
                            final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _selectedImagePath = pickedFile.path;
                              });
                            }
                          },
                        ),
                        
                        const SizedBox(height: 20,),
                        //--------Forms----------
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
                                      decoration: const InputDecoration(hintText: 'User Name'),
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
                                    
                                    const Align(alignment: Alignment.centerLeft, child: Text('Set a Pin (Optional)',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),)),
                                    const SizedBox(height: 5),
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
                                      validator: (value) => _pinController.text != value ? "PIN doesn't match" : null
                                    ),
                                    //------------Buttons--------
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //Cancel Button--------
                                        CancelButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          text: "Cancel"
                                        ),

                                        const SizedBox(
                                          width: 10,
                                        ),

                                        //---------change Button
                                        SavingGreenOrange(
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              editingUser(context);
                                            }
                                          },
                                          text: "Change"
                                        )
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
          imagePath: _selectedImagePath ?? widget.user.imagePath
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
      showMessage(context, 'User Updated');
      Navigator.of(context).pop();
    }
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
