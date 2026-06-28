
/*
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapHelperController extends GetxController {
  var latitude = 33.5138.obs;
  var longitude = 36.2765.obs;
  final mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;

  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
    applyMapStyle();
  }

  Future<void> setDarkMapStyle() async {
    if (mapController.value == null) return;

    final style = await rootBundle.loadString('assets/map_dark.json');
    try {
      await mapController.value!.setMapStyle(style);
    } catch (e) {
      print("⚠️ تعذر تطبيق ثيم الماب الداكن: $e");
    }
  }

  void applyMapStyle() {
    if (mapController.value == null) return;

    if (Get.isDarkMode) {
      setDarkMapStyle();
    } else {
      try {
        mapController.value!.setMapStyle(null);
      } catch (e) {
        print("⚠️ تعذر إلغاء ثيم الماب: $e");
      }
    }
  }

  @override
  void onInit() {
    ever(Get.isDarkMode.obs, (isDark) {
      applyMapStyle();
    });
    moveToCurrentLocation().catchError((error) {
      print("⚠️ تعذر جلب الموقع الحالي عند البداية، تم استخدام الموقع الافتراضي: $error");
    });
    super.onInit();
  }

  // =========================
  // 📍 Location & Camera Control
  // =========================

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final position = await getCurrentLocation();
      await setLocation(position.latitude, position.longitude);
    } catch (e) {
      print("🛑 خطأ أثناء جلب الموقع الحالي وتحريك الكاميرا: $e");
    }
  }

  Future<void> setLocation(
      double lat,
      double lng, {
        bool moveCamera = true,
      }) async {
    latitude.value = lat;
    longitude.value = lng;

    markers.removeWhere((m) => m.markerId.value == 'current_location');
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(lat, lng),
      ),
    );

    if (moveCamera && mapController.value != null) {
      try {
        await mapController.value!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
        );
      } catch (e) {
        print("🛑 تعذر تحريك الكاميرا (الماب قد تكون مغلقة أو غير جاهزة): $e");
      }
    }
  }

  void moveCameraToBounds(List<LatLng> points) {
    if (points.isEmpty || mapController.value == null) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } catch (e) {
      print("🛑 تعذر تحريك الكاميرا للحدود: $e");
    }
  }

  // =========================
  // 🗺️ Markers & Polylines
  // =========================

  void addPolyline(List<LatLng> points) {
    final polyline = Polyline(
      polylineId: PolylineId(DateTime.now().toString()),
      color: const Color(0xFF2196F3),
      width: 5,
      points: points,
    );

    polylines.add(polyline);
  }

  void drawRoutes(List<List<LatLng>> allPaths) {
    clearAll();
    for (var path in allPaths) {
      addPolyline(path);
    }
    moveCameraToBounds(allPaths.expand((e) => e).toList());
  }

  void addPharmacyMarker({
    required LatLng position,
    required int order,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId('pharmacy_$order'),
        position: position,
        infoWindow: InfoWindow(title: "صيدلية $order"),
      ),
    );
  }

  void addMarker({
    required LatLng position,
    required String title,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(title),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
        infoWindow: InfoWindow(
          title: title,
        ),
      ),
    );
  }

  void clearAll() {
    markers.clear();
    polylines.clear();
  }
}*/
import 'package:flutter/services.dart';
import 'package:flutter/material.dart'; // تم إضافة مكتبة الألوان لمنع أي خطأ بـ Color
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapHelperController extends GetxController {
  var latitude = 33.5138.obs;
  var longitude = 36.2765.obs;
  final mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;

  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
    applyMapStyle();
  }

  Future<void> setDarkMapStyle() async {
    if (mapController.value == null) return;

    final style = await rootBundle.loadString('assets/map_dark.json');
    try {
      await mapController.value!.setMapStyle(style);
    } catch (e) {
      print("⚠️ تعذر تطبيق ثيم الماب الداكن: $e");
    }
  }

  void applyMapStyle() {
    if (mapController.value == null) return;

    if (Get.isDarkMode) {
      setDarkMapStyle();
    } else {
      try {
        mapController.value!.setMapStyle(null);
      } catch (e) {
        print("⚠️ تعذر إلغاء ثيم الماب: $e");
      }
    }
  }

  @override
  void onInit() {
    ever(Get.isDarkMode.obs, (isDark) {
      applyMapStyle();
    });
    moveToCurrentLocation().catchError((error) {
      print("⚠️ تعذر جلب الموقع الحالي عند البداية، تم استخدام الموقع الافتراضي: $error");
    });
    super.onInit();
  }

  // =========================
  // 📍 Location & Camera Control
  // =========================

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final position = await getCurrentLocation();
      await setLocation(position.latitude, position.longitude);
    } catch (e) {
      print("🛑 خطأ أثناء جلب الموقع الحالي وتحريك الكاميرا: $e");
    }
  }

  Future<void> setLocation(
      double lat,
      double lng, {
        bool moveCamera = true,
      }) async {
    latitude.value = lat;
    longitude.value = lng;

    markers.removeWhere((m) => m.markerId.value == 'current_location');
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(lat, lng),
      ),
    );

    if (moveCamera && mapController.value != null) {
      try {
        await mapController.value!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
        );
      } catch (e) {
        print("🛑 تعذر تحريك الكاميرا (الماب قد تكون مغلقة أو غير جاهزة): $e");
      }
    }
  }

  /// 🟢 تم الإبقاء على الدالة السليمة هنا وحذف النسخة المكررة الأخرى
  void moveCameraToBounds(List<LatLng> points) {
    if (points.isEmpty || mapController.value == null) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } catch (e) {
      print("🛑 تعذر تحريك الكاميرا للحدود: $e");
    }
  }

  // =========================
  // 🗺️ Markers & Polylines
  // =========================

  void addPolyline(List<LatLng> points) {
    final polyline = Polyline(
      polylineId: PolylineId(DateTime.now().toString() + "_" + points.length.toString()),
      color: const Color(0xFF2196F3),
      width: 5,
      points: points,
    );

    polylines.add(polyline);
  }

  void drawRoutes(List<List<LatLng>> allPaths) {
    clearAll();
    for (var path in allPaths) {
      addPolyline(path);
    }
    moveCameraToBounds(allPaths.expand((e) => e).toList());
  }

  void addPharmacyMarker({
    required LatLng position,
    required int order,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId('pharmacy_$order'),
        position: position,
        infoWindow: InfoWindow(title: "صيدلية $order"),
      ),
    );
  }

  void addMarker({
    required LatLng position,
    required String title,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(title),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
        infoWindow: InfoWindow(
          title: title,
        ),
      ),
    );
  }

  void clearAll() {
    markers.clear();
    polylines.clear();
  }
}