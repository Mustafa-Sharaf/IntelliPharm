
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';

class DeliveryPlan {
  final int id;
  final double totalDistanceKm;
  final double totalDurationSec;
  final List<DeliveryVisit> visits;
  final List<DeliveryPath> paths;
  final String regionName;

  DeliveryPlan({
    required this.id,
    required this.totalDistanceKm,
    required this.totalDurationSec,
    required this.visits,
    required this.paths,
    required this.regionName,
  });

  // 🟢 دالة تحويل آمنة للأرقام (سواء كانت String أو num)
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  DeliveryPlan copyWith({
    int? id,
    double? totalDistanceKm,
    double? totalDurationSec,
    List<DeliveryVisit>? visits,
    List<DeliveryPath>? paths,
    String? regionName,
  }) {
    return DeliveryPlan(
      id: id ?? this.id,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      totalDurationSec: totalDurationSec ?? this.totalDurationSec,
      visits: visits ?? this.visits,
      paths: paths ?? this.paths,
      regionName: regionName ?? this.regionName,
    );
  }

  factory DeliveryPlan.fromJson(Map<String, dynamic> json) {
    return DeliveryPlan(
      id: json['id'] ?? 0,
      totalDistanceKm: _parseDouble(json['total_distance_km']),
      totalDurationSec: _parseDouble(json['total_duration_sec']),
      visits: (json['visits'] as List?)
          ?.map((v) => DeliveryVisit.fromJson(v))
          .toList() ?? [],
      paths: (json['paths'] as List?)
          ?.map((p) => DeliveryPath.fromJson(p))
          .toList() ?? [],
      regionName: json['region_name'] ?? '',
    );
  }

  PlanResponse toPlanResponse() {
    return PlanResponse(
      id: id,
      userId: 1,
      totalDistanceKm: totalDistanceKm,
      totalDurationHours: totalDurationSec / 3600.0,
      createdAt: "",
      reason: "initiated",
      reasonDetails: "",
      visits: visits.map((v) => PlanVisit(
        id: v.id,
        pharmacyId: v.deliveryId,
        name: v.pharmacyName,
        info: v.status,
        visitOrder: v.visitOrder,
        visited: v.status == "completed" || v.visited == 1,
      )).toList(),
      paths: paths.map((p) => PlanPath(
        id: p.id,
        from: p.fromSequence,
        to: p.toSequence,
        distanceKm: p.distanceKm,
        durationHours: p.durationHours,
        geometry: p.geometry,
      )).toList(),
    );
  }
}

class DeliveryVisit {
  final int id;
  final int deliveryId;
  final String pharmacyName;
  final int orderId;
  final int orderItemCount;
  final String status;
  final int visitOrder;
  final int planId;
  final int visited;

  DeliveryVisit({
    required this.id,
    required this.deliveryId,
    required this.pharmacyName,
    required this.orderId,
    required this.orderItemCount,
    required this.status,
    required this.visitOrder,
    required this.planId,
    this.visited = 0,
  });

  DeliveryVisit copyWith({
    int? id,
    int? deliveryId,
    String? pharmacyName,
    int? orderId,
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
      orderItemCount: orderItemCount,
      status: status ?? this.status,
      visitOrder: visitOrder ?? this.visitOrder,
      planId: planId ?? this.planId,
      visited: visited ?? this.visited,
    );
  }

  factory DeliveryVisit.fromJson(Map<String, dynamic> json) {
    return DeliveryVisit(
      id: json['id'] ?? 0,
      deliveryId: json['delivery_id'] ?? 0,
      pharmacyName: json['pharmacy_name'] ?? '',
      orderId: json['order_id'] ?? 0,
      orderItemCount: json['order_item_count']??0,
      status: json['status'] ?? 'pending',
      visitOrder: json['visit_order'] ?? 0,
      planId: json['plan_id'] ?? 0,
      visited: json['status'] == 'completed' ? 1 : 0,
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

  factory DeliveryPath.fromJson(Map<String, dynamic> json) {
    return DeliveryPath(
      id: json['id'] ?? 0,
      fromSequence: json['from_sequence'] ?? 0,
      toSequence: json['to_sequence'] ?? 0,
      distanceKm: _parseDouble(json['distance_km']),
      durationHours: _parseDouble(json['duration_hours']),
      geometry: json['geometry'] ?? '',
    );
  }
}