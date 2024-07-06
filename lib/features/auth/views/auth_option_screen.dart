// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/about/views/about_page.dart';
import 'package:worker_application/features/auth/views/login_screen.dart';
import 'package:worker_application/features/auth/views/register_screen_one.dart';
// ignore: unused_import
import 'package:worker_application/features/auth/views/register_screen_two.dart';

class AuthOptionScreen extends StatefulWidget {
  const AuthOptionScreen({super.key});

  @override
  State<AuthOptionScreen> createState() => _AuthOptionScreenState();
}

class _AuthOptionScreenState extends State<AuthOptionScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.1), // Adjust padding based on screen width
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/blue3.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: screenHeight * 0.4, // Adjust height based on screen height
                width: screenWidth * 0.8, // Adjust width based on screen width
              ),
            ),
          ),
          Text('Discover your', style: AppTextStyles.heading(context)),
          Text('Dream Job here', style: AppTextStyles.heading(context)),
          SizedBox(height: screenHeight * 0.02), // Adjust height based on screen height
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Join us today and take your career to the next level!', style: AppTextStyles.body(context)),
          ),
          SizedBox(height: screenHeight * 0.03), // Adjust height based on screen height
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // Adjust padding based on screen width
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreenWrapper()));
                  },
                  child: Text('Login'),
                  style: AppButtonStyles.smallButtonWhite(context),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreenOneWrapper()));
                  },
                  child: Text('Register'),
                  style: AppButtonStyles.smallButton(context),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // Adjust height based on screen height
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Already registered?', style: AppTextStyles.body(context)),
              ),
              TextButton(onPressed: (){
               Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreenWrapper()));
              }, child: Text('Login',style: AppTextStyles.subheading(context),))
            ],
          ),
          SizedBox(height: screenHeight * 0.02), // Adjust height based on screen height
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AboutPage()));
            },
            child: Text('About', style: TextStyle(color: Color.fromARGB(255, 27, 12, 75))),
          ),
        ],
      ),
    );
  }
}
