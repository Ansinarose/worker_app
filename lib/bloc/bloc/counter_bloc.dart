

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'counter_event.dart';
// import 'counter_state.dart';

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(CounterState()) {
//     on<AddToPendingEvent>((event, emit) async {
//       final updatedOrders = List<Map<String, dynamic>>.from(state.pendingOrders)..add(event.order);
//       final newState = state.copyWith(
//         pendingCount: state.pendingCount + 1,
//         pendingOrders: updatedOrders,
//       );
//       emit(newState);
//       await _saveState(newState);
//     });

//     on<MoveToProgressEvent>((event, emit) async {
//       final updatedPendingOrders = List<Map<String, dynamic>>.from(state.pendingOrders)
//         ..removeWhere((order) => order['orderId'] == event.order['orderId']);
//       final updatedProgressOrders = List<Map<String, dynamic>>.from(state.progressOrders)..add(event.order);
//       final newState = state.copyWith(
//         pendingCount: state.pendingCount - 1,
//         progressCount: state.progressCount + 1,
//         pendingOrders: updatedPendingOrders,
//         progressOrders: updatedProgressOrders,
//       );
//       emit(newState);
//       await _saveState(newState);
//     });

//     on<MoveToCompletedEvent>((event, emit) async {
//   print('MoveToCompletedEvent triggered');
//   print('Current state: ${state.toJson()}');
//   print('Order to be completed: ${event.order}');

//   final updatedProgressOrders = List<Map<String, dynamic>>.from(state.progressOrders)
//     ..removeWhere((order) => order['orderId'] == event.order['orderId']);
//   final updatedCompletedOrders = List<Map<String, dynamic>>.from(state.completedOrders)..add(event.order);

//   print('Updated progress orders: $updatedProgressOrders');
//   print('Updated completed orders: $updatedCompletedOrders');

//   final newState = state.copyWith(
//     progressCount: state.progressCount > 0 ? state.progressCount - 1 : 0,
//     completedCount: state.completedCount + 1,
//     progressOrders: updatedProgressOrders,
//     completedOrders: updatedCompletedOrders,
//   );

//   print('New state after completion: ${newState.toJson()}');

//   emit(newState);
//   await _saveState(newState);
// });

//     on<LoadStateEvent>((event, emit) async {
//       final loadedState = await _loadState();
//       if (loadedState != null) {
//         emit(loadedState);
//       }
//     });
//   }
  
  
//   Future<void> _saveState(CounterState state) async {
//   final prefs = await SharedPreferences.getInstance();
//   final stateJson = json.encode(state.toJson());
//   await prefs.setString('counter_state', stateJson);
//   print('Saved state: $stateJson');
// }

// Future<CounterState?> _loadState() async {
//   final prefs = await SharedPreferences.getInstance();
//   final stateJson = prefs.getString('counter_state');
//   if (stateJson != null) {
//     print('Loaded state JSON: $stateJson');
//     try {
//       final stateMap = json.decode(stateJson);
//       return CounterState.fromJson(stateMap);
//     } catch (e) {
//       print('Error decoding state: $e');
//       return null;
//     }
//   }
//   return null;
// }

//  Map<String, dynamic> _sanitizeMap(Map<dynamic, dynamic> map) {
//   return map.map((key, value) {
//     if (value is Timestamp) {
//       return MapEntry(key.toString(), value.toDate().toIso8601String());
//     } else if (value is DateTime) {
//       return MapEntry(key.toString(), value.toIso8601String());
//     } else if (value is Map) {
//       return MapEntry(key.toString(), _sanitizeMap(value as Map<dynamic, dynamic>));
//     } else if (value is List) {
//       return MapEntry(key.toString(), value.map((e) => e is Map ? _sanitizeMap(e as Map<dynamic, dynamic>) : e).toList());
//     }
//     return MapEntry(key.toString(), value);
//   });
// }
// }
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