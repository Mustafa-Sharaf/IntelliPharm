import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddPharmacyController extends GetxController {
  var pharmacyNameController = TextEditingController();
  var pharmacistsNameController = TextEditingController();
  var commentsController = TextEditingController();

  var phoneControllers = <TextEditingController>[TextEditingController()].obs;

  var latitude = 33.5138.obs; // موقع افتراضي (دمشق)
  var longitude = 36.2765.obs;

  // GoogleMap Controller
  var mapController = Rx<GoogleMapController?>(null);

  // Marker ديناميكي
  Rx<Marker> pharmacyMarker = Marker(
    markerId: const MarkerId('pharmacy_marker'),
    position: LatLng(33.5138, 36.2765),
  ).obs;

  void addPhoneField() => phoneControllers.add(TextEditingController());

  void removePhoneField(int index) {
    if (phoneControllers.length > 1) {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
    }
  }

  Future<void> setLocation(double lat, double lng, {bool moveCamera = true}) async {
    latitude.value = lat;
    longitude.value = lng;

    // تحديث الـ Marker
    pharmacyMarker.value = Marker(
      markerId: const MarkerId('pharmacy_marker'),
      position: LatLng(lat, lng),
    );

    // تحريك الكاميرا إذا حُدد
    if (moveCamera && mapController.value != null) {
      await mapController.value!.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );
    }

    print("Selected Location: Lat=$lat, Lng=$lng");
  }

  // الحصول على الموقع الحالي للجهاز
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
    pharmacyNameController.dispose();
    pharmacistsNameController.dispose();
    commentsController.dispose();
    phoneControllers.forEach((c) => c.dispose());
    super.onClose();
  }
}