
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/auth/views/auth_option_screen.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appbarcolors.appbarbackgroundcolor,
        title: Text('About Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Details:',
                style: AppTextStyles.heading(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                'Company Name: ALFA Aluminum Works',
                style: AppTextStyles.subheading(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.005),
              Text(
                '.Description: We are a leading company in aluminum fabrication, providing high-quality products and services to our customers.',
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                '.Mission Statement: Our mission is to deliver exceptional craftsmanship and reliable solutions for all your aluminum fabrication needs.',
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                '.Job Security: We prioritize job security by offering stable employment, continuous learning opportunities, and a safe working environment.',
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                ' Our company is committed to the well-being and professional growth of our employees, ensuring a supportive and secure workplace.',
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                'Contact Details:',
                style: AppTextStyles.subheading(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                'Email:',
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                'Phone:',
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                'Address:',
                style: AppTextStyles.body(context),
              ),
              SizedBox(height: mediaQuery.size.height * 0.03),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthOptionScreen()),
                    );
                  },
                  child: Text('Back<', style: AppTextStyles.subheading(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
