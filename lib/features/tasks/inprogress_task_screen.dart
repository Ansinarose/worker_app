// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_state.dart';
// import 'package:worker_application/common/constants/app_colors.dart';
// import 'package:worker_application/features/workorder/work_order_details.dart';

// class InProgressTasksScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
        
//         title: Text('In Progress Tasks'),
//         backgroundColor: AppColors.textPrimaryColor,
//       ),
//       body: BlocBuilder<CounterBloc, CounterState>(
//         builder: (context, state) {
//           return ListView.builder(
//             itemCount: state.progressOrders.length,
//             itemBuilder: (context, index) {
//               final order = state.progressOrders[index];
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

class InProgressTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In Progress Tasks'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state.progressOrders.isEmpty) {
            return Center(child: Text('No tasks in progress.'));
          }
          return ListView.builder(
            itemCount: state.progressOrders.length,
            itemBuilder: (context, index) {
              final order = state.progressOrders[index];
              return ListTile(
                title: Text(order['productTitle']),
                subtitle: Text('Price: ₹${order['productPrice']}'),
                trailing: ElevatedButton(
                  child: Text('Complete'),
                  onPressed: () {
                    context.read<CounterBloc>().add(MoveToCompletedEvent(order));
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