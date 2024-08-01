
// ignore_for_file: use_super_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
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
  runApp(MyApp(counterBloc: null,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required counterBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<CounterBloc>(
          create: (context) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final counterBloc = CounterBloc(user.uid);
              counterBloc.loadStateFromFirestore();
              return counterBloc;
            } else {
              // If no user is logged in, create a temporary CounterBloc
              // You might want to handle this case differently based on your app's logic
              return CounterBloc('temp_worker_id');
            }
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Worker Application',
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