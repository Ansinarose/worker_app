// lib/common/constants/app_button_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppButtonStyles {
  // Large button style
  static final ButtonStyle largeButton = TextButton.styleFrom(
    foregroundColor: AppColors.textsecondaryColor, backgroundColor: Color.fromARGB(255, 27, 12, 75), // Button color
    minimumSize: Size(200, 50), // Button size
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  // Small button style
  static final ButtonStyle smallButton = TextButton.styleFrom(
    foregroundColor: AppColors.textsecondaryColor, backgroundColor:Color.fromARGB(255, 27, 12, 75), // Button color
    minimumSize: Size(150, 50), // Button size
    padding: EdgeInsets.symmetric(horizontal: 12.0),
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );

  static final ButtonStyle smallButtonwhite = TextButton.styleFrom(
    foregroundColor: AppColors.textPrimaryColor,backgroundColor: AppColors.textsecondaryColor,
    minimumSize: Size(150, 50),
    padding: EdgeInsets.symmetric(horizontal: 12.0),
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold
    )
  );
}
