import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';

import 'package:worker_application/features/auth/views/login_screen.dart';
import 'package:worker_application/features/auth/views/register_screen_one.dart';
import 'package:worker_application/features/auth/views/register_screen_two.dart';
import 'package:worker_application/features/home/views/home_screen.dart';
import 'package:worker_application/features/onboarding/views/carousel_page.dart';
import 'package:worker_application/features/splash/views/splash_screen.dart';
import 'package:worker_application/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPageWrapper(),
          '/login': (context) => LoginScreenWrapper(),
          '/home': (context) => HomeScreenWrapper(),
          '/carousel': (context) => CarouselPage(),
          '/register': (context) => RegisterScreenOneWrapper(),
          '/registertwo': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
