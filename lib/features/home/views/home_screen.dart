// ignore_for_file: use_super_parameters, use_build_context_synchronously, avoid_print, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/common/widgets/bottom_navigationbar.dart';
import 'package:worker_application/common/widgets/drawer_widget.dart';
import 'package:worker_application/common/widgets/home_notification.dart';
import 'package:worker_application/common/widgets/home_statuscontainer_widget.dart';
import 'package:worker_application/common/widgets/record_attendence_widget.dart';
import 'package:worker_application/features/mywork/mywork_screen.dart';
import 'package:worker_application/features/notification/notification_screen.dart';
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
                      HomeStatusContainersWidget(),  //******statuscontainer widget********* */
                      SizedBox(height: 15),
                    
                     
                      SizedBox(height: 10,),
                     HomeNotificationsWidget(),   //*************notification widget************** */
                     SizedBox(height: 10,),
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
                                  },
                                  child: InkWell(
                                    onTap:(){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyWorkScreen()));
                                    } ,
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
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: RecordAttendanceWidget(),         //*********record attendence widget */
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
             bottomNavigationBar: BottomNavigationWidget(currentIndex: 0,),     //********bottom navigationbar widget********** */
            );
          },
        );
      },
    );
  }
}