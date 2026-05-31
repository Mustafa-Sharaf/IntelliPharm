class PlanResponse {
  final int id;
  final int userId;
  final double totalDistanceKm;
  final double totalDurationHours;
  final String createdAt;
  final String reason;
  final String reasonDetails;
  final List<PlanVisit> visits;
  final List<PlanPath> paths;

  PlanResponse({
    required this.id,
    required this.userId,
    required this.totalDistanceKm,
    required this.totalDurationHours,
    required this.createdAt,
    required this.reason,
    required this.reasonDetails,
    required this.visits,
    required this.paths,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    return PlanResponse(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      totalDistanceKm: (json["total_distance_km"] ?? 0).toDouble(),
      totalDurationHours: (json["total_duration_hours"] ?? 0).toDouble(),
      createdAt: json["created_at"] ?? "",
      reason: json["reason"] ?? "",
      reasonDetails: json["reason_details"] ?? "",
      visits: (json["visits"] as List? ?? [])
          .map((e) => PlanVisit.fromJson(e))
          .toList(),
      paths: (json["paths"] as List? ?? [])
          .map((e) => PlanPath.fromJson(e))
          .toList(),
    );
  }
}

class PlanVisit {
  final int id;
  final int pharmacyId;
  final String name;
  final String info;
  final int visitOrder;
  final bool visited;

  PlanVisit({
    required this.id,
    required this.pharmacyId,
    required this.name,
    required this.info,
    required this.visitOrder,
    required this.visited,
  });

  factory PlanVisit.fromJson(Map<String, dynamic> json) {
    final pharmacy = json["pharmacy"] ?? {};

    return PlanVisit(
      id: json["id"] ?? 0,
      pharmacyId: pharmacy["id"] ?? 0,
      name: pharmacy["name"] ?? "",
      info: pharmacy["info"] ?? "",
      visitOrder: json["visit_order"] ?? 0,
      visited: (json["visited"] ?? 0) == 1,
    );
  }
}

class PlanPath {
  final int id;
  final int from;
  final int to;
  final double distanceKm;
  final double durationHours;
  final String geometry;

  PlanPath({
    required this.id,
    required this.from,
    required this.to,
    required this.distanceKm,
    required this.durationHours,
    required this.geometry,
  });

  factory PlanPath.fromJson(Map<String, dynamic> json) {
    return PlanPath(
      id: json["id"] ?? 0,
      from: json["from_sequence"] ?? 0,
      to: json["to_sequence"] ?? 0,
      distanceKm: (json["distance_km"] ?? 0).toDouble(),
      durationHours: (json["duration_hours"] ?? 0).toDouble(),
      geometry: json["geometry"] ?? "",
    );
  }
}