


import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';

class TrackRouteController extends GetxController {
  var latitude = 33.5138.obs;
  var longitude = 36.2765.obs;

  var mapController = Rx<GoogleMapController?>(null);

  Rx<Marker> pharmacyMarker = Marker(
    markerId: const MarkerId('pharmacy_marker'),
    position: LatLng(33.5138, 36.2765),
  ).obs;

  // Google Places Webservice
  final places = GoogleMapsPlaces(apiKey: "AIzaSyCfaQ8izWQ0k76A4pDez2uG1QtQEJIM2Tg");

  Future<void> setLocation(double lat, double lng, {bool moveCamera = true}) async {
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

  Future<List<Prediction>> searchPlace(String input) async {
    final response = await places.autocomplete(input);
    if (response.isOkay) {
      return response.predictions;
    } else {
      print("Places API error: ${response.errorMessage}");
      return [];
    }
  }

  Future<void> selectPlace(String placeId) async {
    final detail = await places.getDetailsByPlaceId(placeId);
    if (detail.status == "OK") {
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;
      await setLocation(lat, lng);
    }
  }
}