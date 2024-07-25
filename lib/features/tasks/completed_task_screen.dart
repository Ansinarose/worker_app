// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/workorder/work_order_details.dart';

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks', style: AppTextStyles.whiteBody(context)),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state.completedOrders.isEmpty) {
            return Center(child: Text('No completed tasks yet.'));
          }
          return ListView.builder(
            itemCount: state.completedOrders.length,
            itemBuilder: (context, index) {
              final order = state.completedOrders[index];
              return Column(
                children: [
                  ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderDetailScreen(
                        orderDetails: order)));
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        order['productImage'],
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    title: Text(order['productTitle']),
                    subtitle: Text('Price: ₹${order['productPrice']}'),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
