import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions for Alfa Aluminium Works Worker App',
              style: TextStyle(
                color: AppColors.textPrimaryColor,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('1. Acceptance of Terms'),
            _buildSectionContent(
              'By downloading, accessing, or using the Alfa Aluminium Works Worker App, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.',
            ),
            _buildSectionTitle('2. Registration and Account'),
            _buildSectionContent(
              '2.1. Registration: To use the app, you must register by providing your email, password, and phone number.\n\n'
              '2.2. Detailed Profile: After initial registration, you must complete a detailed profile including name, email, phone number, address, date of birth, photo, professional details (categories, experience level), ID proof, professional certificates, and resume.\n\n'
              '2.3. Approval Process: Your registration is subject to approval by Alfa Aluminium Works. Access to the app\'s full features will only be granted upon approval.\n\n'
              '2.4. Account Security: You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),
            _buildSectionTitle('3. User Obligations'),
            _buildSectionContent(
              '3.1. Accurate Information: You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.\n\n'
              '3.2. Professional Conduct: As a worker associated with Alfa Aluminium Works, you agree to conduct yourself professionally and in accordance with the company\'s standards and policies.',
            ),
            _buildSectionTitle('4. App Features and Usage'),
            _buildSectionContent(
              '4.1. Attendance Recording: You must record your attendance daily through the app. Attendance is valid for 24 hours and is a prerequisite for receiving work assignments and payments.\n\n'
              '4.2. Work Assignments: New work assignments will be notified through the app. You can categorize these as pending, in-progress, or completed based on your current situation.\n\n'
              '4.3. Work Details: You are required to update and maintain accurate work details through the app.\n\n'
              '4.4. Communication: The app includes a chat feature for communication with the company. You agree to use this feature responsibly and professionally.',
            ),
            _buildSectionTitle('5. Payments'),
            _buildSectionContent(
              '5.1. Salary Payments: Payments will be processed through the integrated Razorpay payment gateway (currently in test mode).\n\n'
              '5.2. Payment Conditions: Eligibility for payment is contingent upon proper attendance recording and completion of assigned tasks.',
            ),
            _buildSectionTitle('6. Privacy and Data Usage'),
            _buildSectionContent(
              '6.1. Data Collection: By using the app, you consent to the collection, storage, and use of your personal and professional information as provided in your profile and through your app usage.\n\n'
              '6.2. Data Usage: Your information will be used for work assignment, performance evaluation, and other purposes related to your employment with Alfa Aluminium Works.',
            ),
            _buildSectionTitle('7. Intellectual Property'),
            _buildSectionContent(
              'All content and functionality in the app, including but not limited to text, graphics, logos, and software, is the property of Alfa Aluminium Works and is protected by copyright and other intellectual property laws.',
            ),
            _buildSectionTitle('8. Termination'),
            _buildSectionContent(
              'Alfa Aluminium Works reserves the right to terminate or suspend your account and access to the app at any time, with or without cause, and with or without notice.',
            ),
            _buildSectionTitle('9. Changes to Terms'),
            _buildSectionContent(
              'Alfa Aluminium Works reserves the right to modify these Terms and Conditions at any time. Continued use of the app after any such changes constitutes your acceptance of the new Terms and Conditions.',
            ),
            _buildSectionTitle('10. Limitation of Liability'),
            _buildSectionContent(
              'Alfa Aluminium Works shall not be liable for any indirect, incidental, special, consequential or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses resulting from your use of the app.',
            ),
            _buildSectionTitle('11. Governing Law'),
            _buildSectionContent(
              'These Terms and Conditions shall be governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law provisions.',
            ),
            _buildSectionTitle('12. Contact Information'),
            _buildSectionContent(
              'For any questions or concerns regarding these Terms and Conditions, please contact us at iansinarose@gmail.com',
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimaryColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        color: AppColors.textPrimaryColor,
        fontSize: 16.0,
        height: 1.5,
      ),
    );
  }
}