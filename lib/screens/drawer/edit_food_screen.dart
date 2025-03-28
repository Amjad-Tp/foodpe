import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodpe/model/food_model.dart';
import 'package:foodpe/screens/code_Extraction/edit_add_forms.dart';
import 'package:image_picker/image_picker.dart';

class EditFoodScreen extends StatefulWidget {
  const EditFoodScreen(
      {super.key, required this.foodRecipe, required this.index});

  final Food foodRecipe;
  final int index;

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Editor',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  )),
              const Text(
                "Recipe Image:",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedImagePath != null
                        ? DecorationImage(
                            image: kIsWeb
                                ? MemoryImage(base64Decode(_selectedImagePath!))
                                : FileImage(File(_selectedImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : widget.foodRecipe.foodImagePath != null
                            ? DecorationImage(
                                image: kIsWeb
                                    ? MemoryImage(base64Decode(
                                        widget.foodRecipe.foodImagePath!))
                                    : FileImage(
                                        File(widget.foodRecipe.foodImagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: _selectedImagePath == null &&
                          widget.foodRecipe.foodImagePath == null
                      ? const Icon(Icons.camera_alt_outlined,
                          color: Colors.grey, size: 60)
                      : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              EditaddForms(
                  foodRecipe: widget.foodRecipe,
                  index: widget.index,
                  selectedImagePath: _selectedImagePath)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _selectedImagePath = base64Encode(bytes);
        });
      }
    } else {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImagePath = pickedImage.path;
        });
      }
    }
  }
}
