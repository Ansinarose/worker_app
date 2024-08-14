// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/widgets/curved_appbar.dart';

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double verticalPadding = screenSize.height * 0.05;
    final double horizontalPadding = screenSize.width * 0.1;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: CurvedAppBar(
        title: 'Registration Confirmation',
        titleTextStyle: AppTextStyles.whiteBody(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: screenSize.width * 0.25,
                ),
                SizedBox(height: screenSize.height * 0.04),
                Text(
                  'Thank you for your registration!',
                  style: TextStyle(fontSize: screenSize.width * 0.05),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  'You will receive a response from us soon.',
                  style: TextStyle(fontSize: screenSize.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.03),
                Text(
                  'If you do not receive a confirmation message within 3 days of your registration, it means you have not been selected for the job. We appreciate your interest and encourage you to apply again in the future.',
                  style: AppTextStyles.body(context).copyWith(
                    fontSize: screenSize.width * 0.035,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}