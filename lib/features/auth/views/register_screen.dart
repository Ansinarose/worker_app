import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/constants/textform_field.dart';
import 'package:worker_application/common/widgets/category_selection_widget.dart';
import 'package:worker_application/common/widgets/curved_appbar.dart';
import 'package:worker_application/common/widgets/experience_selection_widget.dart';
import 'package:worker_application/common/widgets/photo_selection.dart';
import 'package:worker_application/common/widgets/termsandcondition_widget.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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

  Future<void> _pickFile(TextEditingController controller) async
{
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if(result != null){
    setState(() {
        controller.text = result.files.single.name;
    });
  
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(
        title: 'Register Here',
        titleTextStyle: AppTextStyles.whitetext,
      ),
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text('Personal Details', style: AppTextStyles.heading),
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
                  prefixIcon: Icons.numbers_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                PhotoWidget(),
                SizedBox(height: 20,),    Text('Professional Details', style: AppTextStyles.heading),
                SizedBox(height: 20),
                CategorySelectionWidget(controller: categoryController),
                SizedBox(height: 20,),
                ExperienceSelectionWidget(controller: experienceController),
                 SizedBox(height: 20,),    
                 Text('Document Upload', style: AppTextStyles.heading),
                  SizedBox(height: 20),
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
                SizedBox(height: 20,),
                TermsAndConditionsWidget(),
                SizedBox(height: 20,),
                Center(
                  child: TextButton(style: AppButtonStyles.largeButton,
                    onPressed: (){}, child: Text('SUBMIT')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
