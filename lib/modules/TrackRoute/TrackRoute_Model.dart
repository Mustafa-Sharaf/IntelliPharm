import 'PathModel.dart';
import 'VisitModel.dart';

class PlanModel {
  final int id;
  final double totalDistanceKm;
  final int totalDurationHours;
  final String reason;
  final String reasonDetails;
  final List<VisitModel> visits;
  final List<PathModel> paths;

  PlanModel({
    required this.id,
    required this.totalDistanceKm,
    required this.totalDurationHours,
    required this.reason,
    required this.reasonDetails,
    required this.visits,
    required this.paths,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      totalDistanceKm: (json['total_distance_km'] ?? 0).toDouble(),
      totalDurationHours: json['total_duration_hours'] ?? 0,
      reason: json['reason'] ?? '',
      reasonDetails: json['reason_details'] ?? '',
      visits: (json['visits'] as List)
          .map((e) => VisitModel.fromJson(e))
          .toList(),
      paths: (json['paths'] as List)
          .map((e) => PathModel.fromJson(e))
          .toList(),
    );
  }
}


