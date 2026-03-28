import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapHelperController extends GetxController {
  var latitude = 33.5138.obs;
  var longitude = 36.2765.obs;
  var mapController = Rx<GoogleMapController?>(null);
  var selectedRegion = ''.obs;
  var selectedType = ''.obs;
  final TextEditingController detailsController = TextEditingController();

  Rx<Marker> pharmacyMarker = Marker(
    markerId: const MarkerId('pharmacy_marker'),
    position: LatLng(33.5138, 36.2765),
  ).obs;



  Future<void> setDarkMapStyle() async {
    if (mapController.value == null) return;

    final style = await rootBundle.loadString('assets/map_dark.json');
    mapController.value!.setMapStyle(style);
  }

  void applyMapStyle() {
    if (mapController.value == null) return;

    if (Get.isDarkMode) {
      setDarkMapStyle();
    } else {
      mapController.value!.setMapStyle(null);
    }
  }

  Future<void> setLocation(
    double lat,
    double lng, {
    bool moveCamera = true,
  }) async {
    latitude.value = lat;
    longitude.value = lng;

    pharmacyMarker.value = Marker(
      markerId: const MarkerId('pharmacy_marker'),
      position: LatLng(lat, lng),
    );

    if (moveCamera && mapController.value != null) {
      await mapController.value!.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );
    }

    print("Selected Location: Lat=$lat, Lng=$lng");
  }

  Future<void> moveToCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permission denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await setLocation(position.latitude, position.longitude);
  }

  @override
  void onClose() {
    ever(Get.isDarkMode.obs, (isDark) {
      applyMapStyle();
    });
    super.onClose();
  }
}
