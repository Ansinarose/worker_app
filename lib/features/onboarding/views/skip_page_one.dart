import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/auth/views/auth_option_screen.dart';

class SkipPageOne extends StatelessWidget {
  const SkipPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: AppColors.scaffoldBackgroundcolor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
               height: 400,
               width: 400, 
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/d6977a0d639a2ff2183e9df12823f974.jpg'),fit: BoxFit.cover)
              ),
              ),
            ),
            Text('Welcome to ',style: AppTextStyles.heading,),
            Text('ALFA Aluminium works',style: AppTextStyles.heading,),
            SizedBox(height: 20,),
            Text('Your all-in-one tool for seamless job management.',style: AppTextStyles.body,),
            Text(' instant updates, and secure payments. Empowering you to focus on what you do best.',style: AppTextStyles.body,),

            SizedBox(height: 30,),
            TextButton(
              style: AppButtonStyles.largeButton,
              onPressed: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthOptionScreen()));
              }, child: Text('Get Started',style: AppTextStyles.whiteBody,),)
          ],
        ),
      ),
    );
  }
}