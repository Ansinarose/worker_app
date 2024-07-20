// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/widgets/curved_appbar.dart';

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: CurvedAppBar(
        
        title: 'Registration Confirmation',titleTextStyle: AppTextStyles.whiteBody(context),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for your registration!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'You will receive a response from us soon.',

              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text('If you do not receive a confirmation message within 3 days of your registration, it means you have not been selected for the job. We appreciate your interest and encourage you to apply again in the future.',
            style: AppTextStyles.body(context),)
          ],
        ),
      ),
    );
  }
}
