// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_bloc.dart';
// import 'package:worker_application/bloc/bloc/counter_state.dart';
// import 'package:worker_application/common/constants/app_colors.dart';

// class CompletedTasksScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Completed Tasks'),
//         backgroundColor: AppColors.textPrimaryColor,
//       ),
//       body: BlocBuilder<CounterBloc, CounterState>(
//         builder: (context, state) {
//           print('CompletedTasksScreen - Current state: ${state.toJson()}');
//           print('Completed orders count: ${state.completedOrders.length}');
//           if (state.completedOrders.isEmpty) {
//             return Center(child: Text('No completed tasks yet.'));
//           }
//           return ListView.builder(
//             itemCount: state.completedOrders.length,
//             itemBuilder: (context, index) {
//               final order = state.completedOrders[index];
//               print('Rendering completed order: $order');
//               return ListTile(
//                 title: Text(order['productTitle']),
//                 subtitle: Text('Price: ₹${order['productPrice']}'),
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
import 'package:worker_application/bloc/bloc/counter_state.dart';
import 'package:worker_application/common/constants/app_colors.dart';

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
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
              return ListTile(
                title: Text(order['productTitle']),
                subtitle: Text('Price: ₹${order['productPrice']}'),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              );
            },
          );
        },
      ),
    );
  }
}