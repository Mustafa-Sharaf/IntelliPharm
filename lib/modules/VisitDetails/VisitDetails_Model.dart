
class VisitCheckModel {
  final bool visited;
  final bool useful;
  final double currentLongitude;
  final double currentLatitude;

  VisitCheckModel({
    required this.visited,
    required this.useful,
    required this.currentLongitude,
    required this.currentLatitude,
  });

  Map<String, dynamic> toJson() => {
    "visited": visited,
    "useful": useful,
    "current_longitude": currentLongitude,
    "current_latitude": currentLatitude,
  };
}
