// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/app_event.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/about/views/about_page.dart';
import 'package:worker_application/features/home/views/home_screen.dart';
import 'package:worker_application/features/notification/notification_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimaryColor),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()))
        ),
        title: Text('Settings'),
        backgroundColor: AppColors.textPrimaryColor,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 15, bottom: 15),
            child: Center(
              child: Text(
                'ALFA Aluminium Works',
                style: AppTextStyles.subheading(context),
              ),
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.payment,
            title: 'Payment Details',
            onTap: () {
              // Navigate to Payment Details screen
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationScreen()));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              // Navigate to Privacy Policy screen
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info,
            title: 'About',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AboutPage()));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.work,
            title: 'Total Works',
            onTap: () {
              // Navigate to Total Works screen
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => _showLogoutConfirmationDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.textPrimaryColor),
          title: Text(title, style: AppTextStyles.body(context)),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textPrimaryColor,
            size: 15,
          ),
          onTap: onTap,
        ),
        Divider()
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout',style: AppTextStyles.subheading(context),),
          content: Text('Are you sure you want to log out?',style: AppTextStyles.body(context),),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: AppTextStyles.body(context),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout',style: AppTextStyles.body(context),),
              onPressed: () {
                final authBloc = BlocProvider.of<AuthBloc>(context);
                authBloc.add(LogoutEvent());
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
