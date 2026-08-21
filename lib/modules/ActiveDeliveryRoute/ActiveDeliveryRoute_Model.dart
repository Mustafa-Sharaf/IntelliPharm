import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';

class DeliveryPlan {
  final int id;
  final int userId;
  final String userName;
  final int regionId;
  final String regionName;
  final double totalDistanceKm;
  final double totalDurationSec;
  final bool finished;
  final List<DeliveryVisit> visits;
  final List<DeliveryPath> paths;

  DeliveryPlan({
    required this.id,
    required this.userId,
    required this.userName,
    required this.regionId,
    required this.regionName,
    required this.totalDistanceKm,
    required this.totalDurationSec,
    required this.finished,
    required this.visits,
    required this.paths,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory DeliveryPlan.fromJson(Map<String, dynamic> json) {
    return DeliveryPlan(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      userName: json['user_name']?.toString() ?? '',
      regionId: _parseInt(json['region_id']),
      regionName: json['region_name']?.toString() ?? '',
      totalDistanceKm: _parseDouble(json['total_distance_km']),
      totalDurationSec: _parseDouble(json['total_duration_sec']),
      finished: json['finished'] ?? false,
      visits: (json['visits'] as List?)
          ?.map((v) => DeliveryVisit.fromJson(v))
          .toList() ??
          [],
      paths: (json['paths'] as List?)
          ?.map((p) => DeliveryPath.fromJson(p))
          .toList() ??
          [],
    );
  }

  DeliveryPlan copyWith({
    int? id,
    int? userId,
    String? userName,
    int? regionId,
    String? regionName,
    double? totalDistanceKm,
    double? totalDurationSec,
    bool? finished,
    List<DeliveryVisit>? visits,
    List<DeliveryPath>? paths,
  }) {
    return DeliveryPlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      totalDurationSec: totalDurationSec ?? this.totalDurationSec,
      finished: finished ?? this.finished,
      visits: visits ?? this.visits,
      paths: paths ?? this.paths,
    );
  }

  PlanResponse toPlanResponse() {
    return PlanResponse(
      id: id,
      userId: userId,
      totalDistanceKm: totalDistanceKm,
      totalDurationHours: totalDurationSec / 3600.0,
      createdAt: "",
      reason: "initiated",
      reasonDetails: "",
      visits: visits
          .map((v) => PlanVisit(
        id: v.id,
        pharmacyId: v.deliveryId ?? v.id,
        deliveryId: v.deliveryId ?? 0,
        name: v.pharmacyName,
        info: v.status,
        visitOrder: v.visitOrder,
        visited: v.status == "completed" || v.visited == 1,
      ))
          .toList(),
      paths: paths
          .map((p) => PlanPath(
        id: p.id,
        from: p.fromSequence,
        to: p.toSequence,
        distanceKm: p.distanceKm,
        durationHours: p.durationHours,
        geometry: p.geometry,
      ))
          .toList(),
    );
  }
}

class DeliveryVisit {
  final int id;
  final int? deliveryId;
  final String pharmacyName;
  final int? orderId;
  final int orderItemCount;
  final String status;
  final int visitOrder;
  final int planId;
  final int visited;

  DeliveryVisit({
    required this.id,
    this.deliveryId,
    required this.pharmacyName,
    this.orderId,
    this.orderItemCount = 0,
    required this.status,
    required this.visitOrder,
    required this.planId,
    this.visited = 0,
  });

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory DeliveryVisit.fromJson(Map<String, dynamic> json) {
    return DeliveryVisit(
      id: _parseInt(json['id']),
      deliveryId: json['delivery_id'] != null ? _parseInt(json['delivery_id']) : null,
      pharmacyName: json['pharmacy_name']?.toString() ?? json['name']?.toString() ?? 'Unknown Pharmacy',
      orderId: json['order_id'] != null ? _parseInt(json['order_id']) : null,
      orderItemCount: _parseInt(json['order_item_count']),
      status: json['status']?.toString() ?? 'pending',
      visitOrder: _parseInt(json['visit_order']),
      planId: _parseInt(json['plan_id']),
      visited: (json['status'] == 'completed' || json['visited'] == 1) ? 1 : 0,
    );
  }

  DeliveryVisit copyWith({
    int? id,
    int? deliveryId,
    String? pharmacyName,
    int? orderId,
    int? orderItemCount,
    String? status,
    int? visitOrder,
    int? planId,
    int? visited,
  }) {
    return DeliveryVisit(
      id: id ?? this.id,
      deliveryId: deliveryId ?? this.deliveryId,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      orderId: orderId ?? this.orderId,
      orderItemCount: orderItemCount ?? this.orderItemCount,
      status: status ?? this.status,
      visitOrder: visitOrder ?? this.visitOrder,
      planId: planId ?? this.planId,
      visited: visited ?? this.visited,
    );
  }
}

class DeliveryPath {
  final int id;
  final int fromSequence;
  final int toSequence;
  final double distanceKm;
  final double durationHours;
  final String geometry;

  DeliveryPath({
    required this.id,
    required this.fromSequence,
    required this.toSequence,
    required this.distanceKm,
    required this.durationHours,
    required this.geometry,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory DeliveryPath.fromJson(Map<String, dynamic> json) {
    return DeliveryPath(
      id: _parseInt(json['id']),
      fromSequence: _parseInt(json['from_sequence']),
      toSequence: _parseInt(json['to_sequence']),
      distanceKm: _parseDouble(json['distance_km'] ?? json['distance_m']),
      durationHours: _parseDouble(json['duration_hours'] ?? json['duration_sec']),
      geometry: json['geometry']?.toString() ?? '',
    );
  }

  DeliveryPath copyWith({
    int? id,
    int? fromSequence,
    int? toSequence,
    double? distanceKm,
    double? durationHours,
    String? geometry,
  }) {
    return DeliveryPath(
      id: id ?? this.id,
      fromSequence: fromSequence ?? this.fromSequence,
      toSequence: toSequence ?? this.toSequence,
      distanceKm: distanceKm ?? this.distanceKm,
      durationHours: durationHours ?? this.durationHours,
      geometry: geometry ?? this.geometry,
    );
  }
}