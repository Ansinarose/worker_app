import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/counter_event.dart';
import 'package:worker_application/bloc/bloc/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String workerId;

  CounterBloc(this.workerId) : super(CounterState(workerId: workerId)) {
    on<AddToPendingEvent>(_onAddToPending);
    on<MoveToProgressEvent>(_onMoveToProgress);
    on<MoveToCompletedEvent>(_onMoveToCompleted);
    on<LoadStateEvent>(_onLoadState);
    on<FetchOrdersEvent>(_onFetchOrders);
  }

  Future<void> _onAddToPending(AddToPendingEvent event, Emitter<CounterState> emit) async {
    final updatedOrders = List<Map<String, dynamic>>.from(state.pendingOrders)..add(event.order);
    final newState = state.copyWith(
      pendingCount: state.pendingCount + 1,
      pendingOrders: updatedOrders,
    );
    emit(newState);
    await _saveStateToFirestore(newState);
  }

  Future<void> _onMoveToProgress(MoveToProgressEvent event, Emitter<CounterState> emit) async {
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
  }

  Future<void> _onMoveToCompleted(MoveToCompletedEvent event, Emitter<CounterState> emit) async {
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
  }

  void _onLoadState(LoadStateEvent event, Emitter<CounterState> emit) {
    emit(event.state);
  }

  Future<void> _onFetchOrders(FetchOrdersEvent event, Emitter<CounterState> emit) async {
    try {
      final pendingSnapshot = await _firestore
          .collection('workers')
          .doc(workerId)
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .get();

      final inProgressSnapshot = await _firestore
          .collection('workers')
          .doc(workerId)
          .collection('orders')
          .where('status', isEqualTo: 'in_progress')
          .get();

      final completedSnapshot = await _firestore
          .collection('workers')
          .doc(workerId)
          .collection('orders')
          .where('status', isEqualTo: 'completed')
          .get();

      emit(state.copyWith(
        pendingOrders: pendingSnapshot.docs.map((doc) => doc.data()).toList(),
        progressOrders: inProgressSnapshot.docs.map((doc) => doc.data()).toList(),
        completedOrders: completedSnapshot.docs.map((doc) => doc.data()).toList(),
        pendingCount: pendingSnapshot.docs.length,
        progressCount: inProgressSnapshot.docs.length,
        completedCount: completedSnapshot.docs.length,
      ));
    } catch (e) {
    //  print('Error fetching orders: $e');
    }
  }

  Future<void> _saveStateToFirestore(CounterState state) async {
    await _firestore.collection('workers').doc(workerId).set(state.toJson());
  }

  Future<void> loadStateFromFirestore() async {
    final docSnapshot = await _firestore.collection('workers').doc(workerId).get();
    if (docSnapshot.exists) {
      final loadedState = CounterState.fromJson(docSnapshot.data()!);
      add(LoadStateEvent(loadedState));
    } else {
      add(FetchOrdersEvent());
    }
  }
}