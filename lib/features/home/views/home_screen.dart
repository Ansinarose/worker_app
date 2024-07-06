
// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

// lib/features/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/app_event.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              authBloc.add(LogoutEvent());
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            icon: Icon(Icons.logout, color: Colors.white),
          )
        ],
        backgroundColor: Appbarcolors.appbarbackgroundcolor,
        title: Text('Home', style: AppTextStyles.heading(context)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: AppButtonStyles.largeButton(context),
              onPressed: () {},
              child: Text('Large Button'),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextButton(
              style: AppButtonStyles.smallButton(context),
              onPressed: () {},
              child: Text('Small Button'),
            ),
          ],
        ),
      ),
    );
  }
}

