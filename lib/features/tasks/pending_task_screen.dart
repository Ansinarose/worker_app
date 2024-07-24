// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_state.dart';
// import 'package:worker_application/common/constants/app_colors.dart';
// import 'package:worker_application/features/workorder/work_order_details.dart';

// class PendingTasksScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pending Tasks'),
//         backgroundColor: AppColors.textPrimaryColor,
//       ),
//       body: BlocBuilder<CounterBloc, CounterState>(
//         builder: (context, state) {
//           return ListView.builder(
//             itemCount: state.pendingOrders.length,
//             itemBuilder: (context, index) {
//               final order = state.pendingOrders[index];
//               return ListTile(
//                 title: Text(order['productTitle']),
//                 subtitle: Text('Price: ₹${order['productPrice']}'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OrderDetailScreen(orderDetails: order),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_event.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_colors.dart';

class PendingTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks'),
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
              return ListTile(
                title: Text(order['productTitle']),
                subtitle: Text('Price: ₹${order['productPrice']}'),
                trailing: ElevatedButton(
                  child: Text('Start Work'),
                  onPressed: () {
                    context.read<CounterBloc>().add(MoveToProgressEvent(order));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}