// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_event.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';

class PendingTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks',style: AppTextStyles.whiteBody(context),),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state.pendingOrders.isEmpty) {
            return Center(child: Text('No pending tasks.'));
          }
          return ListView.builder(
            itemCount: state.pendingOrders.length,
            itemBuilder: (context, index) {
              final order = state.pendingOrders[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
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
                        subtitle: Text('Name of the Customer: ${order['address']['name']},\nPrice: ₹${order['productPrice']}'),
                        
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: 
                        
                                   ElevatedButton(
                                    style: AppButtonStyles.smallButton(context),
  child: Text('Start Work'),
  onPressed: () async {
    try {
      // Debug: Print the entire order object
      print('Order object: $order');
      
      String? orderId = order['orderId'];
      String? userId = order['userId'];
      
      if (orderId == null) {
        print('Error: orderId is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot start work: Invalid order ID')),
        );
        return;
      }

      print('Attempting to update order: $orderId');
      
      // Update Firestore
      Map<String, dynamic> updateData = {
        'workStartedAt': FieldValue.serverTimestamp(),
        'status': 'in_progress',
      };
      
      // Debug: Print update data
      print('Update data: $updateData');

      await FirebaseFirestore.instance
          .collection('Customerbookings')
          .doc(orderId)
          .update(updateData);
      
      // Move to progress in worker app
      context.read<CounterBloc>().add(MoveToProgressEvent(order));
      
      // Send notification to customer if userId is available
      if (userId != null) {
        _sendCustomerNotification(userId, orderId);
      } else {
        print('Warning: userId is null, skipping notification');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Work started successfully')),
      );
    } catch (e, stackTrace) {
      print('Error updating order: $e');
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start work: $e')),
      );
    }
  },
),



                      
                    
                  ),
               ] )),
              );
            },
            
          );
        },
      ),
    );
  }
 void _sendCustomerNotification(String customerId, String orderId) {
  try {
    FirebaseFirestore.instance.collection('customer_notifications').add({
      'userId': customerId,
      'message': 'Work has started on your order.',
      'orderId': orderId,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
  } catch (e, stackTrace) {
    print('Error sending notification: $e');
    print('Stack trace: $stackTrace');
  }
}
}