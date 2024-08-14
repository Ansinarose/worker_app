import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/tasks/pending_task_screen.dart';
import 'package:worker_application/features/tasks/inprogress_task_screen.dart';
import 'package:worker_application/features/tasks/completed_task_screen.dart';

class HomeStatusContainersWidget extends StatelessWidget {
  const HomeStatusContainersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Row(
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
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 150.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
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
              Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}