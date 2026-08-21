
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'MapHelper_Controller.dart';

class MapDrawerHelper {
  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  ///  دالة رسم الدبوس مع إمكانية تحديد اللون (أزرق للمسار المتبقي / أخضر للمزار)
  static Future<BitmapDescriptor> createMarkerWithNumber(
      int number, {
        Color mainColor = const Color(0xFF1E88E5),
      }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    const double scale = 0.4;
    final double width = 80.0 * scale;
    final double height = 110.0 * scale;

    final Paint pinPaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;

    final Path pinPath = Path();
    pinPath.moveTo(width / 2, height);
    pinPath.cubicTo(width * 0.1, height * 0.7, 0, height * 0.5, 0, width / 2);
    pinPath.arcTo(Rect.fromLTWH(0, 0, width, width), 3.14, 3.14, false);
    pinPath.cubicTo(
      width,
      height * 0.5,
      width * 0.9,
      height * 0.7,
      width / 2,
      height,
    );
    pinPath.close();

    canvas.drawPath(pinPath, pinPaint);

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0 * scale;
    canvas.drawPath(pinPath, borderPaint);

    final Paint centerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(width / 2, width / 2),
      width * 0.28,
      centerCirclePaint,
    );

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: number.toString(),
      style: TextStyle(
        fontSize: 32.0 * scale,
        fontWeight: FontWeight.bold,
        color: mainColor,
      ),
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset((width - textPainter.width) / 2, (width - textPainter.height) / 2),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  static Future<void> drawFullRoute({
    required MapHelperController routeMapController,
    required dynamic plan,
  }) async {
    if (plan == null) return;

    routeMapController.clearAll();

    // 1. إضافة الماركر الخاص بموقعي الحالي
    routeMapController.markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          routeMapController.latitude.value,
          routeMapController.longitude.value,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "موقعي الحالي (نقطة الانطلاق)"),
      ),
    );

    List<LatLng> allBoundsPoints = [];

    for (int i = 0; i < plan.paths.length; i++) {
      final path = plan.paths[i];
      final decoded = decodePolyline(path.geometry);

      if (decoded.isNotEmpty) {
        allBoundsPoints.addAll(decoded);
        final lastPoint = decoded.last;

        String markerTitle = "Pharmacy";
        int orderNumber = i + 1;
        bool isVisited = false;

        // فحص حالة الزيارة من الكائن القادم من الباك إند
        //  استخدام المتغير الصحيح visited الموجود في PlanVisit
        if (i < plan.visits.length) {
          final visit = plan.visits[i];
          markerTitle = visit.name;
          orderNumber = visit.visitOrder;

          // استخدام المتغير الصحيح من المودل لديك
          isVisited = visit.visited;
        }

        // اختيار لون الخط والماركر: أخضر للتمت زيارته، أزرق للمتبقي
        final Color routeColor = isVisited ? Colors.green.shade600 : const Color(0xFF2196F3);

        // إضافة الخط باللون المناسب
        routeMapController.polyLines.add(
          Polyline(
            polylineId: PolylineId("path_$i"),
            color: routeColor,
            width: 5,
            points: decoded,
          ),
        );

        // إنشاء الدبوس باللون المناسب
        BitmapDescriptor pinIcon = await createMarkerWithNumber(
          orderNumber,
          mainColor: isVisited ? Colors.green.shade600 : Colors.blue.shade600,
        );

        routeMapController.addMarker(
          position: lastPoint,
          title: markerTitle,
          icon: pinIcon,
        );
      }
    }

    // ضبط الكاميرا لتشمل جميع النقاط
    routeMapController.moveCameraToBounds(allBoundsPoints);
  }

  static Future<void> drawSingleDirectPath({
    required MapHelperController mapController,
    required double destLat,
    required double destLng,
    required String destinationName,
    String? geometry,
    int orderNumber = 1,
    bool isVisited = false,
  }) async {
    mapController.clearAll();

    final LatLng startPoint = LatLng(
      mapController.latitude.value,
      mapController.longitude.value,
    );
    final LatLng endPoint = LatLng(destLat, destLng);

    mapController.markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: startPoint,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "My Current Location"),
      ),
    );

    final Color statusColor = isVisited ? Colors.green.shade600 : Colors.blue.shade600;

    BitmapDescriptor pinIcon = await createMarkerWithNumber(
      orderNumber,
      mainColor: statusColor,
    );

    mapController.markers.add(
      Marker(
        markerId: const MarkerId('destination_location'),
        position: endPoint,
        icon: pinIcon,
        infoWindow: InfoWindow(title: destinationName),
      ),
    );

    List<LatLng> pathPoints = (geometry != null && geometry.isNotEmpty)
        ? decodePolyline(geometry)
        : [startPoint, endPoint];

    mapController.polyLines.add(
      Polyline(
        polylineId: const PolylineId("single_path"),
        color: statusColor,
        width: 5,
        points: pathPoints,
      ),
    );

    mapController.moveCameraToBounds(pathPoints);
  }
}