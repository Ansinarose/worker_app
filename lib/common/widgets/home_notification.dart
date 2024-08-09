// ignore_for_file: unnecessary_to_list_in_spreads, use_super_parameters

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/notification/notification_screen.dart';
import 'package:worker_application/features/workorder/work_order_details.dart';

class HomeNotificationsWidget extends StatelessWidget {
  const HomeNotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications:',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('worker_orders')
              .where('workerId', isEqualTo: currentUserId)
              .orderBy('forwardedAt', descending: true)
              .limit(2)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No new notifications');
            }

            return Column(
              children: [
                ...snapshot.data!.docs.map((doc) {
                  var orderData = doc.data() as Map<String, dynamic>;
                  var orderDetails = orderData['orderDetails'] as Map<String, dynamic>? ?? {};

                  return ListTile(
                    title: Text(
                      'New Order: ${orderDetails['productTitle'] ?? 'Unknown Product'}',
                      style: AppTextStyles.body(context),
                    ),
                    subtitle: Text(
                      'Price: ₹${orderDetails['productPrice'] ?? 'N/A'}',
                      style: AppTextStyles.body(context),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: orderDetails['productImage'] != null
                          ? Image.network(
                              orderDetails['productImage'],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            )
                          : Icon(Icons.image_not_supported),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(orderDetails: orderDetails),
                        ),
                      );
                    },
                  );
                }).toList(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationScreen()),
                    );
                  },
                  child: Text('View All'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}