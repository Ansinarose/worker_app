import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/app_state.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/constants/textform_field.dart';
import 'package:worker_application/common/widgets/category_selection_widget.dart';
import 'package:worker_application/common/widgets/curved_appbar.dart';
import 'package:worker_application/common/widgets/experience_selection_widget.dart';
import 'package:worker_application/common/widgets/photo_selection.dart';
import 'package:worker_application/common/widgets/termsandcondition_widget.dart';

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
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _photoUrl;

  Future<void> _pickFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photoUrl = pickedFile.path;
      });
      print('Selected image path: ${pickedFile.path}');
    }
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

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> workerData = {
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'address': addressController.text,
        'dob': dobController.text,
        'category': categoryController.text,
        'experience': experienceController.text,
      };
  print('categories: ${categoryController.text}');
      List<Map<String, dynamic>> files = [
        {'name': 'photo', 'path': _photoUrl ?? ''},
        {'name': 'idProof', 'path': idProofController.text},
        {'name': 'certification', 'path': certificationController.text},
        {'name': 'resume', 'path': resumeController.text},
      ];

      context.read<AuthBloc>().add(SubmitWorkerRegistrationEvent(
            workerData: workerData,
            files: files,
          ));
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
      Navigator.of(context).pop();
    }
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
            // Navigate to the next screen or home page
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
                  Text('Personal Details',
                      style: AppTextStyles.heading(context)),
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
                  PhotoWidget(
                    onImageSelected: _pickImage,
                    imageUrl: _photoUrl, // Pass the image URL to PhotoWidget
                  ),
                  SizedBox(height: 20),
                  Text('Professional Details',
                      style: AppTextStyles.heading(context)),
                  SizedBox(height: 20),
                  CategorySelectionWidget(controller: categoryController),
                  ExperienceSelectionWidget(controller: experienceController),
                  CustomTextFormField(
                    labelText: 'ID Proof',
                    controller: idProofController,
                    prefixIcon: Icons.upload_file,
                    readOnly: true,
                    onTap: () => _pickFile(idProofController),
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Professional Certificate',
                    controller: certificationController,
                    prefixIcon: Icons.upload_file,
                    readOnly: true,
                    onTap: () => _pickFile(certificationController),
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Resume',
                    controller: resumeController,
                    prefixIcon: Icons.upload_file,
                    readOnly: true,
                    onTap: () => _pickFile(resumeController),
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
      )  );
  }
}
