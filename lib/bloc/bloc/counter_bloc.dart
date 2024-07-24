import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CounterBloc() : super(CounterState()) {
    on<AddToPendingEvent>((event, emit) async {
      final updatedOrders = List<Map<String, dynamic>>.from(state.pendingOrders)..add(event.order);
      final newState = state.copyWith(
        pendingCount: state.pendingCount + 1,
        pendingOrders: updatedOrders,
      );
      emit(newState);
      await _saveStateToFirestore(newState);
    });

    on<MoveToProgressEvent>((event, emit) async {
      final updatedPendingOrders = List<Map<String, dynamic>>.from(state.pendingOrders)
        ..removeWhere((order) => order['orderId'] == event.order['orderId']);
      final updatedProgressOrders = List<Map<String, dynamic>>.from(state.progressOrders)..add(event.order);
      final newState = state.copyWith(
        pendingCount: state.pendingCount - 1,
        progressCount: state.progressCount + 1,
        pendingOrders: updatedPendingOrders,
        progressOrders: updatedProgressOrders,
      );
      emit(newState);
      await _saveStateToFirestore(newState);
    });

    on<MoveToCompletedEvent>((event, emit) async {
      final updatedProgressOrders = List<Map<String, dynamic>>.from(state.progressOrders)
        ..removeWhere((order) => order['orderId'] == event.order['orderId']);
      final updatedCompletedOrders = List<Map<String, dynamic>>.from(state.completedOrders)..add(event.order);
      final newState = state.copyWith(
        progressCount: state.progressCount > 0 ? state.progressCount - 1 : 0,
        completedCount: state.completedCount + 1,
        progressOrders: updatedProgressOrders,
        completedOrders: updatedCompletedOrders,
      );
      emit(newState);
      await _saveStateToFirestore(newState);
    });

    on<LoadStateEvent>((event, emit) {
      emit(event.state);
    });
  }

  Future<void> _saveStateToFirestore(CounterState state) async {
    await _firestore.collection('counterState').doc('current').set(state.toJson());
  }

  Future<void> loadStateFromFirestore() async {
    final docSnapshot = await _firestore.collection('counterState').doc('current').get();
    if (docSnapshot.exists) {
      final loadedState = CounterState.fromJson(docSnapshot.data()!);
      add(LoadStateEvent(loadedState));
    }
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'counter_event.dart';
// import 'counter_state.dart';

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   CounterBloc() : super(CounterState()) {
//     on<AddToPendingEvent>((event, emit) async {
//       final updatedOrders = List<Map<String, dynamic>>.from(state.pendingOrders)
//         ..add({
//           ...event.order,
//           'bookingId': event.order['bookingId'], // Ensure bookingId is included
//         });
//       final newState = state.copyWith(
//         pendingCount: state.pendingCount + 1,
//         pendingOrders: updatedOrders,
//       );
//       emit(newState);
//       await _saveStateToFirestore(newState);
//     });

//     on<MoveToProgressEvent>((event, emit) async {
//       final updatedPendingOrders = List<Map<String, dynamic>>.from(state.pendingOrders)
//         ..removeWhere((order) => order['bookingId'] == event.order['bookingId']); // Use bookingId instead of orderId
//       final updatedProgressOrders = List<Map<String, dynamic>>.from(state.progressOrders)..add(event.order);
//       final newState = state.copyWith(
//         pendingCount: state.pendingCount - 1,
//         progressCount: state.progressCount + 1,
//         pendingOrders: updatedPendingOrders,
//         progressOrders: updatedProgressOrders,
//       );
//       emit(newState);
//       await _saveStateToFirestore(newState);
//     });

//     on<MoveToCompletedEvent>((event, emit) async {
//       final updatedProgressOrders = List<Map<String, dynamic>>.from(state.progressOrders)
//         ..removeWhere((order) => order['bookingId'] == event.order['bookingId']); // Use bookingId instead of orderId
//       final updatedCompletedOrders = List<Map<String, dynamic>>.from(state.completedOrders)..add(event.order);
//       final newState = state.copyWith(
//         progressCount: state.progressCount > 0 ? state.progressCount - 1 : 0,
//         completedCount: state.completedCount + 1,
//         progressOrders: updatedProgressOrders,
//         completedOrders: updatedCompletedOrders,
//       );
//       emit(newState);
//       await _saveStateToFirestore(newState);
//     });

//     on<LoadStateEvent>((event, emit) {
//       emit(event.state);
//     });
//   }

//   Future<void> _saveStateToFirestore(CounterState state) async {
//     await _firestore.collection('counterState').doc('current').set(state.toJson());
//   }

//   Future<void> loadStateFromFirestore() async {
//     final docSnapshot = await _firestore.collection('counterState').doc('current').get();
//     if (docSnapshot.exists) {
//       final loadedState = CounterState.fromJson(docSnapshot.data()!);
//       add(LoadStateEvent(loadedState));
//     }
//   }
// }