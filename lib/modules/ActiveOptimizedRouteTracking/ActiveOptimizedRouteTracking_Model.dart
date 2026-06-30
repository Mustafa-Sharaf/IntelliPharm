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


  String get formattedTotalDistance {
    if (totalDistanceKm < 1.0) {
      int meters = (totalDistanceKm * 1000).round();
      return "$meters m";
    }
    return "${totalDistanceKm.toStringAsFixed(1)} km";
  }


  String get formattedTotalDuration {
    double totalMinutes = totalDurationHours * 60;
    int hours = (totalMinutes / 60).floor();
    int minutes = (totalMinutes % 60).round();

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    }
    return "${minutes}m";
  }


  String getETAForVisit(int index) {
    if (index < 0 || index >= visits.length) return "--:--";

    DateTime startTime;
    try {
      startTime = DateTime.parse(createdAt).toLocal();
    } catch (_) {
      startTime = DateTime.now();
    }

    double accumulatedHours = 0.0;
    for (int i = 0; i <= index; i++) {
      if (i < paths.length) {
        accumulatedHours += paths[i].durationHours;
      }
    }

    DateTime etaTime = startTime.add(Duration(
      seconds: (accumulatedHours * 3600).round(),
    ));

    int hour = etaTime.hour;
    int minute = etaTime.minute;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String minuteStr = minute < 10 ? "0$minute" : "$minute";

    return "$hour:$minuteStr $period";
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