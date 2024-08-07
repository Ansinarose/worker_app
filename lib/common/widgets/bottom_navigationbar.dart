// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/features/chat/views/chat_screen.dart';
import 'package:worker_application/features/home/views/home_screen.dart';
import 'package:worker_application/features/salary/views/salary_history_screen.dart';

import 'package:worker_application/features/settings/views/settings_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  final int currentIndex;
  const BottomNavigationWidget({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentHistoryScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.textPrimaryColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
      selectedItemColor: AppColors.textsecondaryColor,
      unselectedItemColor: Colors.grey[600],
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: AppColors.textsecondaryColor),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat, color: AppColors.textsecondaryColor),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment, color: AppColors.textsecondaryColor),
          label: 'Payment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: AppColors.textsecondaryColor),
          label: 'Settings',
        ),
      ],
    );
  }
}