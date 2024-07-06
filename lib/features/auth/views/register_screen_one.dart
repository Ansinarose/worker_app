
// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/app_event.dart';
import 'package:worker_application/bloc/bloc/app_state.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/constants/textform_field.dart';
import 'package:worker_application/common/widgets/curved_appbar.dart';
import 'package:worker_application/features/auth/models/user_model.dart';
import 'package:worker_application/features/auth/views/login_screen.dart';

class RegisterScreenOneWrapper extends StatelessWidget {
  const RegisterScreenOneWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(), child: RegisterScreenone());
  }
}

class RegisterScreenone extends StatefulWidget {
  const RegisterScreenone({super.key});

  @override
  State<RegisterScreenone> createState() => _RegisterScreenoneState();
}

class _RegisterScreenoneState extends State<RegisterScreenone> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled; // Initial validation mode

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(context, '/carousel', (route) => false);
          });
        }

        return Scaffold(
          appBar: CurvedAppBar(
            backgroundImage: 'assets/images/blue2.jpg',
            title: '',
          ),
          backgroundColor: AppColors.scaffoldBackgroundcolor,
          body: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode, // Set the autovalidate mode here
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Text('SignUp with Email', style: AppTextStyles.heading(context)),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      labelText: 'Name',
                      controller: nameController,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
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
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      labelText: 'Password',
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Text('Already have an account?  ', style: AppTextStyles.body(context)),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreenWrapper()));
                          },
                          child: Text('Login', style: AppTextStyles.subheading(context)),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Change the autovalidate mode to onUserInteraction
                            setState(() {
                              _autovalidateMode = AutovalidateMode.onUserInteraction;
                            });
                            // Handle signup logic here
                            UserModel user = UserModel(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            authBloc.add(RegisterEvent(user: user));
                          } else {
                            // If form is not valid, set the autovalidate mode to onUserInteraction
                            setState(() {
                              _autovalidateMode = AutovalidateMode.onUserInteraction;
                            });
                          }
                        },
                        child: Text('SignUp'),
                        style: AppButtonStyles.largeButton(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
