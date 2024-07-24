

// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class CounterState {
//   final int progressCount;
//   final int pendingCount;
//   final int completedCount;
//   final List<Map<String, dynamic>> progressOrders;
//   final List<Map<String, dynamic>> pendingOrders;
//   final List<Map<String, dynamic>> completedOrders;

//   CounterState({
//     this.progressCount = 0,
//     this.pendingCount = 0,
//     this.completedCount = 0,
//     this.progressOrders = const [],
//     this.pendingOrders = const [],
//     this.completedOrders = const [],
//   });

//   CounterState copyWith({
//     int? progressCount,
//     int? pendingCount,
//     int? completedCount,
//     List<Map<String, dynamic>>? progressOrders,
//     List<Map<String, dynamic>>? pendingOrders,
//     List<Map<String, dynamic>>? completedOrders,
//   }) {
//     return CounterState(
//       progressCount: progressCount ?? this.progressCount,
//       pendingCount: pendingCount ?? this.pendingCount,
//       completedCount: completedCount ?? this.completedCount,
//       progressOrders: progressOrders ?? this.progressOrders,
//       pendingOrders: pendingOrders ?? this.pendingOrders,
//       completedOrders: completedOrders ?? this.completedOrders,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'progressCount': progressCount,
//       'pendingCount': pendingCount,
//       'completedCount': completedCount,
//       'progressOrders': progressOrders,
//       'pendingOrders': pendingOrders,
//       'completedOrders': completedOrders,
//     };
//   }

//   factory CounterState.fromJson(Map<String, dynamic> json) {
//     return CounterState(
//       progressCount: json['progressCount'] as int,
//       pendingCount: json['pendingCount'] as int,
//       completedCount: json['completedCount'] as int,
//       progressOrders: List<Map<String, dynamic>>.from(json['progressOrders']),
//       pendingOrders: List<Map<String, dynamic>>.from(json['pendingOrders']),
//       completedOrders: List<Map<String, dynamic>>.from(json['completedOrders']),
//     );
//   }


//   Map<String, dynamic> _sanitizeMap(Map<String, dynamic> map) {
//   return map.map((key, value) {
//     if (value is Timestamp) {
//       return MapEntry(key, value.toDate().toIso8601String());
//     } else if (value is DateTime) {
//       return MapEntry(key, value.toIso8601String());
//     } else if (value is Map) {
//       return MapEntry(key, _sanitizeMap(value as Map<String, dynamic>));
//     } else if (value is List) {
//       return MapEntry(key, value.map((e) => e is Map ? _sanitizeMap(e as Map<String, dynamic>) : e).toList());
//     }
//     return MapEntry(key, value);
//   });
// }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class CounterState {
  final int progressCount;
  final int pendingCount;
  final int completedCount;
  final List<Map<String, dynamic>> progressOrders;
  final List<Map<String, dynamic>> pendingOrders;
  final List<Map<String, dynamic>> completedOrders;

  CounterState({
    this.progressCount = 0,
    this.pendingCount = 0,
    this.completedCount = 0,
    this.progressOrders = const [],
    this.pendingOrders = const [],
    this.completedOrders = const [],
  });

  CounterState copyWith({
    int? progressCount,
    int? pendingCount,
    int? completedCount,
    List<Map<String, dynamic>>? progressOrders,
    List<Map<String, dynamic>>? pendingOrders,
    List<Map<String, dynamic>>? completedOrders,
  }) {
    return CounterState(
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
      progressCount: json['progressCount'] as int? ?? 0,
      pendingCount: json['pendingCount'] as int? ?? 0,
      completedCount: json['completedCount'] as int? ?? 0,
      progressOrders: List<Map<String, dynamic>>.from(json['progressOrders'] ?? []),
      pendingOrders: List<Map<String, dynamic>>.from(json['pendingOrders'] ?? []),
      completedOrders: List<Map<String, dynamic>>.from(json['completedOrders'] ?? []),
    );
  }
}