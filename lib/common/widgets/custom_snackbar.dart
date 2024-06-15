// custom_snackbar.dart

import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar show(
      {required String message,

      Duration duration = const Duration(seconds: 3)}) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor:Color.fromARGB(255, 27, 12, 75),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(16.0),
    );
  }
}
