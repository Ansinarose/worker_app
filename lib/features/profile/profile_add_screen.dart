// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/constants/textform_field.dart';
import 'package:worker_application/common/widgets/category_selection_widget.dart';

class ProfileAddScreen extends StatefulWidget {
  const ProfileAddScreen({Key? key}) : super(key: key);

  @override
  _ProfileAddScreenState createState() => _ProfileAddScreenState();
}

class _ProfileAddScreenState extends State<ProfileAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final categoriesController = TextEditingController();
  final skillsController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers
    nameController.addListener(() => setState(() {}));
    contactController.addListener(() => setState(() {}));
    addressController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    dobController.addListener(() => setState(() {}));
    categoriesController.addListener(() => setState(() {}));
    skillsController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    emailController.dispose();
    dobController.dispose();
    categoriesController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        title: Text('Profile Details'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('Profile Details', style: AppTextStyles.subheading(context))),
                SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Name',
                  controller: nameController,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                CustomTextFormField(
                  labelText: 'Contact Number',
                  controller: contactController,
                  prefixIcon: Icons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                CustomTextFormField(
                  labelText: 'Address',
                  controller: addressController,
                  prefixIcon: Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                CustomTextFormField(
                  labelText: 'Email Address',
                  controller: emailController,
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                CustomTextFormField(
                  labelText: 'Date of Birth',
                  controller: dobController,
                  prefixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
              
                CategorySelectionWidget(controller: categoriesController),
                SizedBox(height: 16.0),
                CustomTextFormField(
                  labelText: 'Skills',
                  controller: skillsController,
                  prefixIcon: Icons.build,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your skills';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
               
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.textsecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 50, color: AppColors.textPrimaryColor),
                                SizedBox(height: 10),
                                Text('Add Photo', style: TextStyle(color: AppColors.textPrimaryColor)),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_image!, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    style: AppButtonStyles.largeButton(context),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                      await _submitProfile();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _submitProfile() async {
  if (FirebaseAuth.instance.currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You must be logged in to submit a profile')),
    );
    return;
  }
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Upload image to Firebase Storage
    String? imageUrl;
    if (_image != null) {
      final ref = FirebaseStorage.instance.ref().child('worker_profile_images/${DateTime.now().toString()}');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }

    // Create a map of profile data
    Map<String, dynamic> profileData = {
      'name': nameController.text,
      'contact': contactController.text,
      'address': addressController.text,
      'email': emailController.text,
      'dob': dobController.text,
      'categories': categoriesController.text,
      'skills': skillsController.text,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };

    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('worker_profiles')
        .doc(uid)
        .set(profileData, SetOptions(merge: true));

    // Close loading indicator
    Navigator.of(context).pop();

    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile submitted successfully!')),
    );
    Navigator.of(context).pop(); // This will take you back to the previous screen (likely HomeScreen)

    print('Profile data saved for UID: $uid');
    print('Saved data: $profileData');

  } catch (e) {
    // Close loading indicator
    Navigator.of(context).pop();

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting profile: $e')),
    );
    print('Error saving profile data: $e');
  }
}
}