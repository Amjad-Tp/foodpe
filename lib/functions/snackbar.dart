import 'package:flutter/material.dart';

void showMessage(BuildContext context, String message,Color backgroundColor, [Color? foregroundColor]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: foregroundColor),
      ),
      margin: const EdgeInsets.all(16),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

