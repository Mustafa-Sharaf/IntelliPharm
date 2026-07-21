
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
    required this.regionName
  });

  factory DeliveryPlan.fromJson(Map<String, dynamic> json) {
    return DeliveryPlan(
      id: json['id'] ?? 0,
      totalDistanceKm: (json['total_distance_km'] as num?)?.toDouble() ?? 0.0,
      totalDurationSec: (json['total_duration_sec'] as num?)?.toDouble() ?? 0.0,
      visits: (json['visits'] as List?)
          ?.map((v) => DeliveryVisit.fromJson(v))
          .toList() ?? [],
      paths: (json['paths'] as List?)
          ?.map((p) => DeliveryPath.fromJson(p))
          .toList() ?? [],
      regionName: json['region_name'] ?? ''
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
  final String status;
  final int visitOrder;
  final int planId;
  final int visited;

  DeliveryVisit({
    required this.id,
    required this.deliveryId,
    required this.pharmacyName,
    required this.orderId,
    required this.status,
    required this.visitOrder,
    required this.planId,
    this.visited = 0,
  });

  factory DeliveryVisit.fromJson(Map<String, dynamic> json) {
    return DeliveryVisit(
      id: json['id'] ?? 0,
      deliveryId: json['delivery_id'] ?? 0,
      pharmacyName: json['pharmacy_name'] ?? '',
      orderId: json['order_id'] ?? 0,
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

  factory DeliveryPath.fromJson(Map<String, dynamic> json) {
    return DeliveryPath(
      id: json['id'] ?? 0,
      fromSequence: json['from_sequence'] ?? 0,
      toSequence: json['to_sequence'] ?? 0,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      durationHours: (json['duration_hours'] as num?)?.toDouble() ?? 0.0,
      geometry: json['geometry'] ?? '',
    );
  }
}