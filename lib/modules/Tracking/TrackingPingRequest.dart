class TrackingPingRequest {
  final double lat;
  final double lon;
  final double heading;
  final double speed;
  final int? regionId;
  final int? taskId;

  TrackingPingRequest({
    required this.lat,
    required this.lon,
    required this.heading,
    required this.speed,
    required this.regionId,
    required this.taskId,
  });

  
  Map<String, dynamic> toJson() {
    return {
      "lat": lat,
      "lon": lon,
      "heading": heading,
      "speed": speed,
      "region_id": regionId,
      "task_id": taskId,
    };
  }
}