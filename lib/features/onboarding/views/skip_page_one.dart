

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/auth/views/auth_option_screen.dart';

class SkipPageOne extends StatelessWidget {
  const SkipPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.1), // Adjust padding based on screen width
              child: Container(
                height: screenHeight * 0.5, // Adjust height based on screen height
                width: screenWidth * 0.8, // Adjust width based on screen width
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/images/d6977a0d639a2ff2183e9df12823f974.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text('Welcome to ', style: AppTextStyles.heading(context)),
            Text('ALFA Aluminium works', style: AppTextStyles.heading(context)),
           SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Your all-in-one tool for seamless job management. Instant updates, and secure payments. Empowering you to focus on what you do best.',
                style: AppTextStyles.body(context),
              ),
            ),
            SizedBox(height: 30,),
            TextButton(
              style: AppButtonStyles.largeButton(context),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthOptionScreen()));
              },
              child: Text('Get Started', style: AppTextStyles.whiteBody(context)),
            )
          ],
        ),
      ),
    );
  }
}
