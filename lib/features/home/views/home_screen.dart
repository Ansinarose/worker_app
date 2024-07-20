
// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/common/widgets/drawer_widget.dart';

import '../../profile/profile_add_screen.dart';
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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('worker_profiles')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          // No profile exists, redirect to ProfileAddScreen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileAddScreen(),
            ));
          });
          return Container(); // Placeholder while redirecting
        }

        // Profile exists, show your normal HomeScreen
        return Scaffold(
          appBar: AppBar(
            // Your AppBar configuration
          ),
          drawer: AppDrawer(),
         // body: // Your HomeScreen body
        );
      },
    );
  }
}