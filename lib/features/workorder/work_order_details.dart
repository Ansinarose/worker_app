// ignore_for_file: use_super_parameters, avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_event.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const OrderDetailScreen({Key? key, required this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        bool isPending = state.pendingOrders.any((order) => order['orderId'] == orderDetails['orderId']);
        bool isInProgress = state.progressOrders.any((order) => order['orderId'] == orderDetails['orderId']);
        bool isCompleted = state.completedOrders.any((order) => order['orderId'] == orderDetails['orderId']);

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackgroundcolor,
          appBar: AppBar(
            title: Text('Order Details', style: AppTextStyles.whiteBody(context)),
            backgroundColor: AppColors.textPrimaryColor,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 50),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          orderDetails['productImage'],
                          fit: BoxFit.cover,
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Product: ${orderDetails['productTitle']}',
                      style: AppTextStyles.subheading(context),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: ₹${orderDetails['productPrice']}',
                      style: AppTextStyles.body(context),
                    ),
                    Text(
                      'Selected Color: ${orderDetails['selectedColor']}',
                      style: AppTextStyles.body(context),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Delivery Address:',
                      style: AppTextStyles.subheading(context),
                    ),
                    SizedBox(height: 8),
                    Text('Name: ${orderDetails['address']['name']}', style: AppTextStyles.body(context)),
                    Text('House Number: ${orderDetails['address']['houseNo']}, Road: ${orderDetails['address']['road']}', style: AppTextStyles.body(context)),
                    Text('City: ${orderDetails['address']['city']}, State: ${orderDetails['address']['state']} - Pincode: ${orderDetails['address']['pincode']}', style: AppTextStyles.body(context)),
                    Text('Phone Number: ${orderDetails['address']['phone']}', style: AppTextStyles.body(context)),
                    SizedBox(height: 32),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isPending)
                            ElevatedButton(
                              style: AppButtonStyles.smallButton(context),
                              onPressed: () async {
                                await _updateOrderStatus(context, 'in_progress');
                                context.read<CounterBloc>().add(MoveToProgressEvent(orderDetails));
                              },
                              child: Text('Start Work'),
                            ),
                          if (isInProgress)
                            ElevatedButton(
                              style: AppButtonStyles.smallButton(context),
                              onPressed: () async {
                                await _updateOrderStatus(context, 'completed');
                                context.read<CounterBloc>().add(MoveToCompletedEvent(orderDetails));
                              },
                              child: Text('Mark as Completed'),
                            ),
                          if (isCompleted)
                            Text(
                              'This order has been completed',
                              style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
                            ),
                          if (!isPending && !isInProgress && !isCompleted)
                            ElevatedButton(
                              style: AppButtonStyles.smallButton(context),
                              onPressed: () async {
                                await _updateOrderStatus(context, 'pending');
                                context.read<CounterBloc>().add(AddToPendingEvent(orderDetails));
                              },
                              child: Text('Add to Pending'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateOrderStatus(BuildContext context, String status) async {
    try {
      String? orderId = orderDetails['orderId'];
      String? userId = orderDetails['userId'];

      if (orderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot update: Invalid order ID')),
        );
        return;
      }

      Map<String, dynamic> updateData = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (status == 'in_progress') {
        updateData['workStartedAt'] = FieldValue.serverTimestamp();
      } else if (status == 'completed') {
        updateData['workCompletedAt'] = FieldValue.serverTimestamp();
      }

      await FirebaseFirestore.instance
          .collection('Customerbookings')
          .doc(orderId)
          .update(updateData);

      if (userId != null) {
        _sendCustomerNotification(userId, orderId, status);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated to $status')),
      );
    } catch (e) {
      print('Error updating order status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status')),
      );
    }
  }

  void _sendCustomerNotification(String customerId, String orderId, String status) {
    try {
      String message;
      if (status == 'in_progress') {
        message = 'Work has started on your order.';
      } else if (status == 'completed') {
        message = 'Work has been completed on your order.';
      } else {
        message = 'Your order status has been updated to $status.';
      }

      FirebaseFirestore.instance.collection('customer_notifications').add({
        'userId': customerId,
        'message': message,
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}