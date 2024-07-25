
// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/features/profile/profile_add_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('worker_profiles')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(child: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          print('Error fetching profile: ${snapshot.error}');
          return Drawer(
            child: Center(child: Text('Error fetching profile data')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          print('No profile data found for UID: ${FirebaseAuth.instance.currentUser?.uid}');
          return _buildDrawerWithoutProfile(context);
        }

        // Profile exists, build drawer with user data
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        return _buildDrawerWithProfile(context, userData);
      },
    );
  }

  Widget _buildDrawerWithoutProfile(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Appbarcolors.appbarbackgroundcolor,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAddScreen()));
              },
              icon: Icon(Icons.person),
              iconSize: 80,
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Create Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAddScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
            //  _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerWithProfile(BuildContext context, Map<String, dynamic> userData) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Appbarcolors.appbarbackgroundcolor,
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: userData['imageUrl'] != null
                ? NetworkImage(userData['imageUrl'])
                : null,
            child: userData['imageUrl'] == null
                ? Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          accountName: Text(userData['name'] ?? 'Name not set',style: TextStyle(color: AppColors.textPrimaryColor),),
          accountEmail: Text(userData['email'] ?? 'Email not set'),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Name: ${userData['name'] ?? 'Not set'}'),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Contact Number: ${userData['contact'] ?? 'Not set'}'),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Address: ${userData['address'] ?? 'Not set'}'),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text('Email: ${userData['email'] ?? 'Not set'}'),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: Text('Date of Birth: ${userData['dob'] ?? 'Not set'}'),
        ),
        ListTile(
          leading: Icon(Icons.category),
          title: Text('Categories: ${_formatField(userData['categories'])}'),
        ),
        ListTile(
          leading: Icon(Icons.build),
          title: Text('Skills: ${_formatField(userData['skills'])}'),
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit Profile'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAddScreen()));
          },
        ),
       
      ],
    ),
  );
}

String _formatField(dynamic field) {
  if (field == null) return 'Not set';
  if (field is List) return field.join(', ');
  if (field is String) return field;
  return field.toString();
}
}