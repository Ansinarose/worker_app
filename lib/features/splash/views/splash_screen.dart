// // ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:worker_application/bloc/bloc/app_bloc.dart';
// import 'package:worker_application/bloc/bloc/app_event.dart';
// import 'package:worker_application/bloc/bloc/app_state.dart';
// import 'package:worker_application/common/constants/app_colors.dart';
// import 'package:worker_application/features/auth/views/confirmation_page.dart';
// import 'package:worker_application/features/auth/views/register_screen_two.dart';
// import 'package:worker_application/features/home/views/home_screen.dart';
// import 'package:worker_application/features/onboarding/views/skip_page_one.dart';



// class SplashPageWrapper extends StatelessWidget {
//   const SplashPageWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
//       child: const SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is Authenticated) {
//          // print("User is authenticated");
//           User? user = FirebaseAuth.instance.currentUser;
//           if (user != null) {
//            // print("Current user UID: ${user.uid}");
//             try {
//               DocumentSnapshot workerDoc = await FirebaseFirestore.instance
//                   .collection("workers_request")
//                   .doc(user.uid)
//                   .get();

//               if (workerDoc.exists) {
//                 print("Worker document exists");
//                 print("Worker data: ${workerDoc.data()}");
//                 bool registrationAccepted = workerDoc['registrationAccepted'] ?? false;
//                 print("Registration accepted: $registrationAccepted");
//                 if (registrationAccepted) {
//                   print("Navigating to HomeScreenWrapper");
//                   Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => HomeScreenWrapper()));
//                 } else {
//                   print("Navigating to ConfirmationPage");
//                   Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => ConfirmationPage()));
//                 }
//               } 
             
//             } catch (e) {
//               print("Error fetching worker document: $e");
//               Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => RegisterScreen()));
//             }
//           } else {
//            // print("Current user is null");
//             Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => SkipPageOne()));
//           }
//         } else if (state is UnAuthenticated) {
//          // print("User is unauthenticated");
//           Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => SkipPageOne()));
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundcolor,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 70,
//                 height: 70,
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(
//                             'assets/images/387-3872576_purple-home-5-icon-free-icons-house-with.png'),
//                         fit: BoxFit.fill)),
//               ),
//               const SizedBox(height: 20),
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'ALFA\n',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimaryColor,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Aluminium works',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: AppColors.textPrimaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print, duplicate_ignore

// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_bloc.dart';
import 'package:worker_application/bloc/bloc/app_event.dart';
import 'package:worker_application/bloc/bloc/app_state.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/features/auth/views/confirmation_page.dart';
import 'package:worker_application/features/auth/views/register_screen_two.dart';
import 'package:worker_application/features/home/views/home_screen.dart';
import 'package:worker_application/features/onboarding/views/skip_page_one.dart';

class SplashPageWrapper extends StatelessWidget {
  const SplashPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is Authenticated) {
          print("User is authenticated");
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            print("Current user UID: ${user.uid}");
            try {
              DocumentSnapshot workerDoc = await FirebaseFirestore.instance
                  .collection("workers_request")
                  .doc(user.uid)
                  .get();

              if (workerDoc.exists) {
                print("Worker document exists");
                print("Worker data: ${workerDoc.data()}");
                bool registrationAccepted = workerDoc['registrationAccepted'] ?? false;
                print("Registration accepted: $registrationAccepted");
                if (registrationAccepted) {
                  print("Navigating to HomeScreenWrapper");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreenWrapper()));
                } else {
                  print("Navigating to ConfirmationPage");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ConfirmationPage()));
                }
              } else {
                print("Worker document does not exist");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              }
            } catch (e) {
              print("Error fetching worker document: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error occurred: $e")));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SkipPageOne()));
            }
          } else {
            print("Current user is null");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SkipPageOne()));
          }
        } else if (state is UnAuthenticated) {
          print("User is unauthenticated");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SkipPageOne()));
        } else if (state is AuthLoading) {
          print("Authentication is loading");
          // You might want to show a loading indicator here
        } else {
          print("Unhandled state: $state");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("An unexpected error occurred")));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SkipPageOne()));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundcolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/387-3872576_purple-home-5-icon-free-icons-house-with.png'),
                        fit: BoxFit.fill)),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'ALFA\n',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'Aluminium works',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(), // Add loading indicator
            ],
          ),
        ),
      ),
    );
  }
}