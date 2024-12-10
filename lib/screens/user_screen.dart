import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodpe/functions/db_functions.dart';
import 'package:foodpe/model/user_model.dart';
import 'package:foodpe/screens/user_edit_screen.dart';


class UserScreen extends StatelessWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<User>(
          valueListenable: userNotifier,
          builder: (context, user, child) {
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20),
                  child: Text(
                    'User',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: user.imagePath != null
                        ? DecorationImage(
                            image: FileImage(
                              File(user.imagePath!),
                            ),
                          )
                        : null,
                  ),
                  child: user.imagePath == null
                      ? const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        )
                      : null,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    user.phoneNumber,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 130),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFD9D9D9),
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => UserEditScreen(user: user,)));
                    }, 
                    child: const Text(
                      "Edit User",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
}