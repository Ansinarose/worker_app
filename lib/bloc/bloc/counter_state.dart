
// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
// CounterState
class CounterState {
  final String workerId;
  final int progressCount;
  final int pendingCount;
  final int completedCount;
  final List<Map<String, dynamic>> progressOrders;
  final List<Map<String, dynamic>> pendingOrders;
  final List<Map<String, dynamic>> completedOrders;

  CounterState({
    required this.workerId,
    this.progressCount = 0,
    this.pendingCount = 0,
    this.completedCount = 0,
    this.progressOrders = const [],
    this.pendingOrders = const [],
    this.completedOrders = const [],
  });

  CounterState copyWith({
    String? workerId,
    int? progressCount,
    int? pendingCount,
    int? completedCount,
    List<Map<String, dynamic>>? progressOrders,
    List<Map<String, dynamic>>? pendingOrders,
    List<Map<String, dynamic>>? completedOrders,
  }) {
    return CounterState(
      workerId: workerId ?? this.workerId,
      progressCount: progressCount ?? this.progressCount,
      pendingCount: pendingCount ?? this.pendingCount,
      completedCount: completedCount ?? this.completedCount,
      progressOrders: progressOrders ?? this.progressOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      completedOrders: completedOrders ?? this.completedOrders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workerId': workerId,
      'progressCount': progressCount,
      'pendingCount': pendingCount,
      'completedCount': completedCount,
      'progressOrders': progressOrders,
      'pendingOrders': pendingOrders,
      'completedOrders': completedOrders,
    };
  }

  factory CounterState.fromJson(Map<String, dynamic> json) {
    return CounterState(
      workerId: json['workerId'] as String,
      progressCount: json['progressCount'] as int? ?? 0,
      pendingCount: json['pendingCount'] as int? ?? 0,
      completedCount: json['completedCount'] as int? ?? 0,
      progressOrders: List<Map<String, dynamic>>.from(json['progressOrders'] ?? []),
      pendingOrders: List<Map<String, dynamic>>.from(json['pendingOrders'] ?? []),
      completedOrders: List<Map<String, dynamic>>.from(json['completedOrders'] ?? []),
    );
  }
}
