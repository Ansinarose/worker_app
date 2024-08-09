// ignore_for_file: use_build_context_synchronously, avoid_print, use_super_parameters

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';

class RecordAttendanceWidget extends StatelessWidget {
  const RecordAttendanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showAttendanceDialog(context),
      child: Container(
        height: 80,
        width: 160,
        margin: EdgeInsets.only(top: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Record Attendance',
            style: AppTextStyles.body(context),
          ),
        ),
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final attendanceRef = FirebaseFirestore.instance.collection('attendance').doc(user.uid);
    final lastAttendance = await attendanceRef.get();

    if (lastAttendance.exists) {
      final lastTimestamp = lastAttendance.data()!['timestamp'] as Timestamp;
      final now = Timestamp.now();
      if (now.toDate().difference(lastTimestamp.toDate()).inHours < 24) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: AppColors.textsecondaryColor,
            content: Text('You have already submitted your attendance today.',style: TextStyle(
            color: AppColors.textPrimaryColor
          ),)),
        );
        return;
      }
    }

    // Fetch worker profile data
    final workerProfileRef = FirebaseFirestore.instance.collection('worker_profiles').doc(user.uid);
    final workerProfileDoc = await workerProfileRef.get();

    if (!workerProfileDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Worker profile not found. Please create your profile first.')),
      );
      return;
    }

    final workerProfileData = workerProfileDoc.data() as Map<String, dynamic>;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Record Attendance',style: AppTextStyles.subheading(context),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you available for work today?',style: AppTextStyles.body(context),),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Yes',style: AppTextStyles.body(context),),
                    onPressed: () => _recordAttendance(context, true, workerProfileData),
                  ),
                  ElevatedButton(
                    child: Text('No',style: AppTextStyles.body(context),),
                    onPressed: () => _recordAttendance(context, false, workerProfileData),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _recordAttendance(BuildContext context, bool isAvailable, Map<String, dynamic> workerProfileData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('attendance').doc(user.uid).set({
        'userId': user.uid,
        'isAvailable': isAvailable,
        'timestamp': FieldValue.serverTimestamp(),
        'name': workerProfileData['name'],
        'categories': workerProfileData['categories'],
        'imageUrl': workerProfileData['imageUrl'],
        'contact': workerProfileData['contact'],
        'address': workerProfileData['address'],
      });

      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance recorded successfully')),
      );
    } catch (e) {
      print('Error recording attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to record attendance. Please try again.')),
      );
    }
  }
}