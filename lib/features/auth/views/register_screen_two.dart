// ignore_for_file: unused_import, use_super_parameters, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/app_state.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/constants/textform_field.dart';
import 'package:worker_application/common/widgets/category_selection_widget.dart';
import 'package:worker_application/common/widgets/curved_appbar.dart';
import 'package:worker_application/common/widgets/experience_selection_widget.dart';
import 'package:worker_application/common/widgets/termsandcondition_widget.dart';
import 'package:worker_application/features/auth/views/confirmation_page.dart';
import 'package:worker_application/features/home/views/home_screen.dart';
import '../../../bloc/bloc/app_event.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController idProofController = TextEditingController();
  final TextEditingController certificationController = TextEditingController();
  final TextEditingController resumeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool registrationAccepted = false;
  String? workerId;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _photoUrl;

  Future<String?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      return "${file.name}|${file.path ?? ''}";
    }
    return null;
  }

  Future<String?> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return "${pickedFile.name}|${pickedFile.path}";
    }
    return null;
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<String?> _uploadFile(String fileInfo, String folder) async {
    if (fileInfo.isEmpty || !fileInfo.contains('|')) {
      return null;
    }

    List<String> parts = fileInfo.split('|');
    String fileName = parts[0];
    String filePath = parts[1];

    if (filePath.isEmpty) {
      return null;
    }

    File file = File(filePath);
    if (!await file.exists()) {
      return null;
    }

    String destination = '$folder/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
     // print('Error uploading file to $folder: $e');
      return null;
    }
  }

  void _submitRegistration() async {
  if (_formKey.currentState!.validate()) {
   // print("Form validated. Attempting to submit registration.");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      String? photoUrl = await _uploadFile(_photoUrl ?? '', 'photos');
      String? idProofUrl = await _uploadFile(idProofController.text, 'id_proofs');
      String? certificationUrl = await _uploadFile(certificationController.text, 'certifications');
      String? resumeUrl = await _uploadFile(resumeController.text, 'resumes');

      Map<String, dynamic> workerData = {
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'address': addressController.text,
        'dob': dobController.text,
        'category': categoryController.text,
        'experience': experienceController.text,
        'photoUrl': photoUrl,
        'idProofUrl': idProofUrl,
        'certificationUrl': certificationUrl,
        'resumeUrl': resumeUrl,
        'registrationAccepted': false,
      };

      // Get the current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;
      
      // Use the UID as the document ID when creating the worker document
      await FirebaseFirestore.instance.collection('workers_request').doc(uid).set(workerData);
      
     // print("Worker document created with ID: $uid");

      Navigator.of(context).pop(); // Close loading indicator

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration submitted successfully')),
      );

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ConfirmationPage()));

      // Set up listener for registration status
      _listenForRegistrationStatus(uid);

    } catch (e) {
      Navigator.of(context).pop(); // Close loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  } else {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
  }
}

  void _listenForRegistrationStatus(String uid) {
  FirebaseFirestore.instance
      .collection('workers_request')
      .doc(uid)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.exists && snapshot.data()?['registrationAccepted'] == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen())
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AuthBloc>(context),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is WorkerRegistrationSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration submitted successfully')),
            );
          } else if (state is WorkerRegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Scaffold(
          appBar: CurvedAppBar(
            title: 'Register Here',
            titleTextStyle: AppTextStyles.whitetext(context),
          ),
          backgroundColor: AppColors.scaffoldBackgroundcolor,
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Text('Personal Details', style: AppTextStyles.heading(context)),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Email',
                      controller: emailController,
                      prefixIcon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Phone Number',
                      controller: phoneNumberController,
                      prefixIcon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Address',
                      controller: addressController,
                      prefixIcon: Icons.location_city_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Date of Birth',
                      controller: dobController,
                      prefixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: _pickDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(style: AppButtonStyles.smallButton(context),
                      onPressed: () async {
                        String? result = await _pickImage();
                        if (result != null) {
                          setState(() {
                            _photoUrl = result;
                          });
                        }
                      },
                      child: Text('Pick Photo'),
                    ),
                    if (_photoUrl != null) Text('Photo selected: ${_photoUrl!.split('|')[0]}'),
                    SizedBox(height: 20),
                    Text('Professional Details', style: AppTextStyles.heading(context)),
                    SizedBox(height: 20),
                    CategorySelectionWidget(controller: categoryController),
                    SizedBox(height: 10),
                    ExperienceSelectionWidget(controller: experienceController),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'ID Proof',
                      controller: idProofController,
                      prefixIcon: Icons.upload_file,
                      readOnly: true,
                      onTap: () async {
                        String? result = await _pickFile();
                        if (result != null) {
                          setState(() {
                            idProofController.text = result;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Professional Certificate',
                      controller: certificationController,
                      prefixIcon: Icons.upload_file,
                      readOnly: true,
                      onTap: () async {
                        String? result = await _pickFile();
                        if (result != null) {
                          setState(() {
                            certificationController.text = result;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Resume',
                      controller: resumeController,
                      prefixIcon: Icons.upload_file,
                      readOnly: true,
                      onTap: () async {
                        String? result = await _pickFile();
                        if (result != null) {
                          setState(() {
                            resumeController.text = result;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    TermsAndConditionsWidget(),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        style: AppButtonStyles.largeButton(context),
                        onPressed: _submitRegistration,
                        child: Text('SUBMIT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
