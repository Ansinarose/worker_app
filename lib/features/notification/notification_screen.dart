import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/workorder/work_order_details.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        title: Text(
          'Notifications',
          style: AppTextStyles.whiteBody(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('worker_orders')
            .where('workerId', isEqualTo: currentUserId)
            .orderBy('forwardedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var orderDetails = orderData['orderDetails'] as Map<String, dynamic>? ?? {};

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('New Order: ${orderDetails['productTitle'] ?? 'Unknown Product'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ₹${orderDetails['productPrice'] ?? 'N/A'}'),
                      Text('Color: ${orderDetails['selectedColor'] ?? 'N/A'}'),
                      Text('Forwarded at: ${_formatDate(orderData['forwardedAt'])}'),
                    ],
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
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    if (date is Timestamp) {
      return DateFormat('dd MMM yyyy, HH:mm').format(date.toDate());
    }
    return 'Invalid Date';
  }
}