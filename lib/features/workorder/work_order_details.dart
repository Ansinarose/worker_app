
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_event.dart';
// import 'package:worker_application/bloc/bloc/counter_state.dart';
// import 'package:worker_application/common/constants/app_button_styles.dart';
// import 'package:worker_application/common/constants/app_colors.dart';

// class OrderDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> orderDetails;

//   const OrderDetailScreen({Key? key, required this.orderDetails}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<CounterBloc, CounterState>(
//       listener: (context, state) {
//         print('State changed: Progress count: ${state.progressCount}, Pending count: ${state.pendingCount}, Completed count: ${state.completedCount}');
//         Navigator.pop(context);
//       },
//       builder: (context, state) {
//         bool isPending = state.pendingOrders.any((order) => order['orderId'] == orderDetails['orderId']);
//         bool isInProgress = state.progressOrders.any((order) => order['orderId'] == orderDetails['orderId']);
        
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Order Details'),
//             backgroundColor: AppColors.textPrimaryColor,
//           ),
//           body: SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.network(orderDetails['productImage']),
//                 SizedBox(height: 16),
//                 Text('Product: ${orderDetails['productTitle']}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text('Price: ₹${orderDetails['productPrice']}'),
//                 Text('Color: ${orderDetails['selectedColor']}'),
//                 SizedBox(height: 16),
//                 Text('Delivery Address:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Text('${orderDetails['address']['name']}'),
//                 Text('${orderDetails['address']['houseNo']}, ${orderDetails['address']['road']}'),
//                 Text('${orderDetails['address']['city']}, ${orderDetails['address']['state']} - ${orderDetails['address']['pincode']}'),
//                 Text('Phone: ${orderDetails['address']['phone']}'),
//                 SizedBox(height: 50),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (!isPending && !isInProgress)
//                       ElevatedButton(
//                         style: AppButtonStyles.smallButton(context),
//                         onPressed: () {
//                           context.read<CounterBloc>().add(AddToPendingEvent(orderDetails));
//                         },
//                         child: Text('Add to Pending'),
//                       ),
//                     if (isPending)
//                       ElevatedButton(
//                         style: AppButtonStyles.smallButton(context),
//                         onPressed: () {
//                           context.read<CounterBloc>().add(MoveToProgressEvent(orderDetails));
//                         },
//                         child: Text('Move to Progress'),
//                       ),
//                    // if (isInProgress)
//                      ElevatedButton(
//   style: AppButtonStyles.smallButton(context),
//   onPressed: () {
//     print('Attempting to mark as completed: ${orderDetails['orderId']}');
//     context.read<CounterBloc>().add(MoveToCompletedEvent(orderDetails));
//   },
//   child: Text('Mark as Completed'),
// ),
//                   ],
//                 ),
//               ],
//             )
//           )
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_event.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';

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
          appBar: AppBar(
            title: Text('Order Details'),
            backgroundColor: AppColors.textsecondaryColor,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(orderDetails['productImage']),
                SizedBox(height: 16),
                Text('Product: ${orderDetails['productTitle']}', 
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Price: ₹${orderDetails['productPrice']}'),
                Text('Color: ${orderDetails['selectedColor']}'),
                SizedBox(height: 16),
                Text('Delivery Address:', 
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${orderDetails['address']['name']}'),
                Text('${orderDetails['address']['houseNo']}, ${orderDetails['address']['road']}'),
                Text('${orderDetails['address']['city']}, ${orderDetails['address']['state']} - ${orderDetails['address']['pincode']}'),
                Text('Phone: ${orderDetails['address']['phone']}'),
                SizedBox(height: 50),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPending)
                        ElevatedButton(
                          style: AppButtonStyles.smallButton(context),
                          onPressed: () {
                            context.read<CounterBloc>().add(MoveToProgressEvent(orderDetails));
                          },
                          child: Text('Start Work'),
                        ),
                      if (isInProgress)
                        ElevatedButton(
                          style: AppButtonStyles.smallButton(context),
                          onPressed: () {
                            context.read<CounterBloc>().add(MoveToCompletedEvent(orderDetails));
                          },
                          child: Text('Mark as Completed'),
                        ),
                      if (isCompleted)
                        Text('This order has been completed', 
                             style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      if (!isPending && !isInProgress && !isCompleted)
                        ElevatedButton(
                          style: AppButtonStyles.smallButton(context),
                          onPressed: () {
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
        );
      },
    );
  }
}