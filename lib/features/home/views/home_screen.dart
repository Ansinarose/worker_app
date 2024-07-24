

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_state.dart';
// import 'package:worker_application/common/constants/app_colors.dart';
// import 'package:worker_application/common/constants/app_text_styles.dart';
// import 'package:worker_application/common/widgets/drawer_widget.dart';
// import 'package:worker_application/features/notification/notification_screen.dart';
// import 'package:worker_application/features/tasks/completed_task_screen.dart';
// import 'package:worker_application/features/tasks/inprogress_task_screen.dart';
// import 'package:worker_application/features/tasks/pending_task_screen.dart';

// import '../../profile/profile_add_screen.dart';

// class HomeScreenWrapper extends StatelessWidget {
//   const HomeScreenWrapper({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) => CounterBloc(),
// //       child: HomeScreen(),
// //     );
// //   }
// // }

//   @override
//   Widget build(BuildContext context) {
//     // Access the CounterBloc from the context
//     final counterBloc = BlocProvider.of<CounterBloc>(context);
    
//     return BlocProvider.value(
//       value: counterBloc,
//       child: HomeScreen(),
//     );
//   }
// }


// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('worker_profiles')
//           .doc(FirebaseAuth.instance.currentUser?.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => ProfileAddScreen(),
//             ));
//           });
//           return Container();
//         }

//         return BlocBuilder<CounterBloc, CounterState>(
//           builder: (context, state) {
//             return Scaffold(
//               backgroundColor: AppColors.scaffoldBackgroundcolor,
//               appBar: PreferredSize(
//                 preferredSize: Size.fromHeight(100.0),
//                 child: AppBar(
//                   backgroundColor: AppColors.textPrimaryColor,
//                   iconTheme: IconThemeData(color: AppColors.textsecondaryColor),
//                   centerTitle: true,
//                   actions: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => NotificationScreen()));
//                       },
//                       child: Icon(
//                         Icons.notification_important,
//                         color: Colors.white,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               drawer: AppDrawer(),
//               body: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Text(
//                           'Welcome to ALFA Aluminium works',
//                           style: AppTextStyles.subheading(context),
//                         ),
//                       ),
//                       SizedBox(height: 16.0),
//                       Text(
//                         'Task Status Summary:',
//                         style: AppTextStyles.body(context),
//                       ),
//                       SizedBox(height: 16.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildStatusContainer(
//                             context,
//                             icon: Icons.pending,
//                             label: 'Pending',
//                             count: state.pendingCount,
//                             color: AppColors.textsecondaryColor,
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => PendingTasksScreen(),
//                               ));

//                             },
//                           ),
//                           _buildStatusContainer(
//                             context,
//                             icon: Icons.work,
//                             label: 'In Progress',
//                             count: state.progressCount,
//                             color: AppColors.textsecondaryColor,
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => InProgressTasksScreen(),
//                               ));
//                             },
//                           ),
//                           _buildStatusContainer(
//                             context,
//                             icon: Icons.check_circle,
//                             label: 'Completed',
//                             count: 0, // You might want to add this to your state
//                             color: AppColors.textsecondaryColor,
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => CompletedTasksScreen(),
//                               ));
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         'Notifications:',
//                         style: AppTextStyles.subheading(context),
//                       ),
//                       SizedBox(height: 100),
//                       Center(
//                         child: Container(
//                           height: 200,
//                           width: 400,
//                           decoration: BoxDecoration(
//                             color: AppColors.textPrimaryColor,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Stack(
//                             children: [
//                               Align(
//                                 alignment: Alignment.bottomLeft,
//                                 child: InkWell(
//                                   onTap: () {
//                                     // Handle on tap for the first container
//                                   },
//                                   child: Container(
//                                     height: 80,
//                                     width: 160,
//                                     margin: EdgeInsets.only(left: 20, bottom: 20),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'My works',
//                                         style: AppTextStyles.body(context),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Align(
//                                 alignment: Alignment.topRight,
//                                 child: InkWell(
//                                   onTap: () {
//                                     _showAttendanceDialog(context);
//                                   },
//                                   child: Container(
//                                     height: 80,
//                                     width: 160,
//                                     margin: EdgeInsets.only(top: 20, right: 20),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'Record Attendance',
//                                         style: AppTextStyles.body(context),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildStatusContainer(BuildContext context,
//       {required IconData icon,
//       required String label,
//       required int count,
//       required Color color,
//       required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: SizedBox(
//         width: 120.0,
//         height: 150.0,
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: AppColors.textPrimaryColor,
//             borderRadius: BorderRadius.circular(10.0),
//             border: Border.all(color: color),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: color),
//               SizedBox(height: 8.0),
//               Text(label, style: TextStyle(color: color)),
//               SizedBox(height: 8.0),
//               Text(count.toString(),
//                   style: TextStyle(
//                       color: color, fontSize: 18, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAttendanceDialog(BuildContext context) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) return;

//   final attendanceRef = FirebaseFirestore.instance.collection('attendance').doc(user.uid);
//   final lastAttendance = await attendanceRef.get();

//   if (lastAttendance.exists) {
//     final lastTimestamp = lastAttendance.data()!['timestamp'] as Timestamp;
//     final now = Timestamp.now();
//     if (now.toDate().difference(lastTimestamp.toDate()).inHours < 24) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('You have already submitted your attendance today.')),
//       );
//       return;
//     }
//   }

//   // Fetch worker profile data
//   final workerProfileRef = FirebaseFirestore.instance.collection('worker_profiles').doc(user.uid);
//   final workerProfileDoc = await workerProfileRef.get();

//   if (!workerProfileDoc.exists) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Worker profile not found. Please create your profile first.')),
//     );
//     return;
//   }

//   final workerProfileData = workerProfileDoc.data() as Map<String, dynamic>;

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Record Attendance'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Are you available for work today?'),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   child: Text('Yes'),
//                   onPressed: () => _recordAttendance(context, true, workerProfileData),
//                 ),
//                 ElevatedButton(
//                   child: Text('No'),
//                   onPressed: () => _recordAttendance(context, false, workerProfileData),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// void _recordAttendance(BuildContext context, bool isAvailable, Map<String, dynamic> workerProfileData) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) return;

//   try {
//     await FirebaseFirestore.instance.collection('attendance').doc(user.uid).set({
//       'userId': user.uid,
//       'isAvailable': isAvailable,
//       'timestamp': FieldValue.serverTimestamp(),
//       'name': workerProfileData['name'],
//       'categories': workerProfileData['categories'],
//       'imageUrl': workerProfileData['imageUrl'],
//       'contact': workerProfileData['contact'],
//       'address':workerProfileData['address'],
//     });

// ignore_for_file: use_build_context_synchronously, avoid_print, use_key_in_widget_constructors, use_super_parameters

//     Navigator.of(context).pop(); // Close the dialog
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Attendance recorded successfully')),
//     );
//   } catch (e) {
//     print('Error recording attendance: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to record attendance. Please try again.')),
//     );
//   }
// }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/widgets/drawer_widget.dart';
import 'package:worker_application/features/notification/notification_screen.dart';
import 'package:worker_application/features/tasks/completed_task_screen.dart';
import 'package:worker_application/features/tasks/inprogress_task_screen.dart';
import 'package:worker_application/features/tasks/pending_task_screen.dart';
import 'package:worker_application/features/profile/profile_add_screen.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return HomeScreen();
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('worker_profiles')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileAddScreen(),
            ));
          });
          return Container();
        }

        return BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackgroundcolor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: AppBar(
                  backgroundColor: AppColors.textPrimaryColor,
                  iconTheme: IconThemeData(color: AppColors.textsecondaryColor),
                  centerTitle: true,
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                      },
                      child: Icon(
                        Icons.notification_important,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              drawer: AppDrawer(),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Welcome to ALFA Aluminium works',
                          style: AppTextStyles.subheading(context),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Task Status Summary:',
                        style: AppTextStyles.body(context),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatusContainer(
                            context,
                            icon: Icons.pending,
                            label: 'Pending',
                            count: state.pendingCount,
                            color: AppColors.textsecondaryColor,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PendingTasksScreen(),
                              ));
                            },
                          ),
                          _buildStatusContainer(
                            context,
                            icon: Icons.work,
                            label: 'In Progress',
                            count: state.progressCount,
                            color: AppColors.textsecondaryColor,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InProgressTasksScreen(),
                              ));
                            },
                          ),
                          _buildStatusContainer(
                            context,
                            icon: Icons.check_circle,
                            label: 'Completed',
                            count: state.completedCount,
                            color: AppColors.textsecondaryColor,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CompletedTasksScreen(),
                              ));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Notifications:',
                        style: AppTextStyles.subheading(context),
                      ),
                      SizedBox(height: 100),
                      Center(
                        child: Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            color: AppColors.textPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: InkWell(
                                  onTap: () {
                                    // Handle on tap for the first container
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 160,
                                    margin: EdgeInsets.only(left: 20, bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'My works',
                                        style: AppTextStyles.body(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    _showAttendanceDialog(context);
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 160,
                                    margin: EdgeInsets.only(top: 20, right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Record Attendance',
                                        style: AppTextStyles.body(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusContainer(BuildContext context,
      {required IconData icon,
      required String label,
      required int count,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 120.0,
        height: 150.0,
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.textPrimaryColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: color),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              SizedBox(height: 8.0),
              Text(label, style: TextStyle(color: color)),
              SizedBox(height: 8.0),
              Text(count.toString(),
                  style: TextStyle(
                      color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final attendanceRef = FirebaseFirestore.instance.collection('attendance').doc(user.uid);
    final lastAttendance = await attendanceRef.get();

    if (lastAttendance.exists) {
      final lastTimestamp = lastAttendance.data()!['timestamp'] as Timestamp;
      final now = Timestamp.now();
      if (now.toDate().difference(lastTimestamp.toDate()).inHours < 24) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already submitted your attendance today.')),
        );
        return;
      }
    }

    // Fetch worker profile data
    final workerProfileRef = FirebaseFirestore.instance.collection('worker_profiles').doc(user.uid);
    final workerProfileDoc = await workerProfileRef.get();

    if (!workerProfileDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Worker profile not found. Please create your profile first.')),
      );
      return;
    }

    final workerProfileData = workerProfileDoc.data() as Map<String, dynamic>;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Record Attendance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you available for work today?'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () => _recordAttendance(context, true, workerProfileData),
                  ),
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () => _recordAttendance(context, false, workerProfileData),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _recordAttendance(BuildContext context, bool isAvailable, Map<String, dynamic> workerProfileData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('attendance').doc(user.uid).set({
        'userId': user.uid,
        'isAvailable': isAvailable,
        'timestamp': FieldValue.serverTimestamp(),
        'name': workerProfileData['name'],
        'categories': workerProfileData['categories'],
        'imageUrl': workerProfileData['imageUrl'],
        'contact': workerProfileData['contact'],
        'address': workerProfileData['address'],
      });

      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance recorded successfully')),
      );
    } catch (e) {
      print('Error recording attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to record attendance. Please try again.')),
      );
    }
  }
}