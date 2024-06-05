import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/about/views/about_page.dart';
import 'package:worker_application/features/auth/views/login_screen.dart';
import 'package:worker_application/features/auth/views/register_screen.dart';

class AuthOptionScreen extends StatefulWidget {
  const AuthOptionScreen({super.key});

  @override
  State<AuthOptionScreen> createState() => _AuthOptionScreenState();
}

class _AuthOptionScreenState extends State<AuthOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(image: AssetImage('assets/th (6).jpg'),fit: BoxFit.cover),
              
              ),
                height: 300,
                width: 300,
                
              ),
            ),
          ),
          Text('Discover your',style: AppTextStyles.heading,),
           Text('Dream Job here',style: AppTextStyles.heading,),
           SizedBox(height: 20,),
          
          Text('Join us today and take your career to the next level!',style: AppTextStyles.body,),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                TextButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                }, child: Text('Login'),style: AppButtonStyles.smallButtonwhite,),
                TextButton(onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
                }, child: Text('Register'),style: AppButtonStyles.smallButton,)
              ],
            ),
          ),
          SizedBox(height: 20,),
          Text('Already  registeredt? Login',style: AppTextStyles.body,),
           SizedBox(height: 20,),
          TextButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AboutPage()));
          }, child: Text('About',style: TextStyle(color: Color.fromARGB(255, 27, 12, 75)),))
        ],
      ),
    );
  }
}