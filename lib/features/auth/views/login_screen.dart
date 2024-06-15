
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/app_event.dart';
import 'package:worker_application/bloc/bloc/app_state.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/textform_field.dart';
import 'package:worker_application/common/widgets/curved_appbar.dart';
import 'package:worker_application/common/widgets/custom_snackbar.dart';

class LoginScreenWrapper extends StatelessWidget {
  const LoginScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AuthBloc(), child: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isTyping = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CurvedAppBar(
        title: 'Congratulations!!!\n Be the part of ALFA ',
        titleTextStyle: AppTextStyles.whiteBody(context),
      ),
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            
            if (state is Authenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.show(message: 'Login successful! Welcome back.')
              );
              Navigator.pushNamedAndRemoveUntil(context, '/carousel', (route) => false);

            } else if (state is AuthenticatedError) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.show(message: 'Authentication failed. Please check your credentials and try again.')
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 60, 9, 70),
                ),
              );
            }

            return Form(
              key: _formKey,
              autovalidateMode: _isTyping ? AutovalidateMode.disabled : AutovalidateMode.always,
              onChanged: () {
                if (_isTyping) {
                  setState(() {
                    _isTyping = true;
                  });
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Text('Login to your account', style: AppTextStyles.heading(context)),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      labelText: 'Email',
                      controller: emailController,
                      prefixIcon: Icons.email,
                      textColor: AppColors.textPrimaryColor,
                      hintColor: AppColors.textPrimaryColor,
                      borderColor: AppColors.textPrimaryColor,
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
                      obscureText: !_isPasswordVisible,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      textColor: AppColors.textPrimaryColor,
                      hintColor: AppColors.textPrimaryColor,
                      borderColor: AppColors.textPrimaryColor,
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
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                          child: Text(
                            'OR',
                            style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextButton(
                      style: AppButtonStyles.googleButton(context),
                      onPressed: () {
                        authBloc.add(GoogleSignInEvent());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/th.jpg',
                            height: screenHeight * 0.03,
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Text('Sign in with Google'),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authBloc.add(LoginEvent(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ));
                          }
                        },
                        child: Text('Login'),
                        style: AppButtonStyles.smallButton(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
