import 'package:worker_application/bloc/bloc/counter_state.dart';

abstract class CounterEvent {}

class AddToPendingEvent extends CounterEvent {
  final Map<String, dynamic> order;
  AddToPendingEvent(this.order);
}

class MoveToProgressEvent extends CounterEvent {
  final Map<String, dynamic> order;
  MoveToProgressEvent(this.order);
}

class MoveToCompletedEvent extends CounterEvent {
  final Map<String, dynamic> order;
  MoveToCompletedEvent(this.order);
}

class LoadStateEvent extends CounterEvent {
  final CounterState state;
  LoadStateEvent(this.state);
}

class FetchOrdersEvent extends CounterEvent {}
