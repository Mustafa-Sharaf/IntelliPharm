import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../app_theme/AppColors.dart';

class AddPharmacyController extends GetxController {
  var pharmacyNameController = TextEditingController();
  var pharmacistsNameController = TextEditingController();
  var commentsController = TextEditingController();
  var phoneControllers = <TextEditingController>[TextEditingController()].obs;
  var openTime = Rx<TimeOfDay?>(null);
  var closeTime = Rx<TimeOfDay?>(null);
  //var latitude = 33.5138.obs;
  //var longitude = 36.2765.obs;
  //var mapController = Rx<GoogleMapController?>(null);
  LatLng? tempPosition;



  // Marker ديناميكي
 /* Rx<Marker> pharmacyMarker = Marker(
    markerId: const MarkerId('pharmacy_marker'),
    position: LatLng(33.5138, 36.2765),
  ).obs;*/
  /*Rx<Marker> pharmacyMarker = Marker(
    markerId: const MarkerId('pharmacy_marker'),
    position: LatLng(33.5138, 36.2765),
    draggable: true,
    onDragEnd: (newPosition) {},
  ).obs;*/




  //var latitude = 33.5138.obs;
 // var longitude = 36.2765.obs;

  // GoogleMap Controller
  //var mapController = Rx<GoogleMapController?>(null);


  // Marker ديناميكي
 // Rx<Marker> pharmacyMarker = Marker(
  //  markerId: const MarkerId('pharmacy_marker'),
  //  position: LatLng(33.5138, 36.2765),
  //).obs;

  //var selectedRegion = ''.obs;
  //var selectedType = ''.obs;

  //GoogleMapController? mapController;

  //final TextEditingController detailsController = TextEditingController();


 /* Future<void> setDarkMapStyle() async {
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

    print("Selected Location: Lat=$lat, Lng=$lng");
  }
*/

 /* Future<void> moveToCurrentLocation() async {
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

  void sendData() {
    if (selectedRegion.value.isEmpty || selectedType.value.isEmpty) {
      Get.snackbar("Error", "Please select region & type");
      return;
    }

    final data = {
      "region": selectedRegion.value,
      "type": selectedType.value,
      "details": detailsController.text,
      "lat": latitude.value,
      "lng": longitude.value,
    };



    print(data);
  }
*/



  void addPhoneField() {
    if (phoneControllers.length < 2) {
      phoneControllers.add(TextEditingController());
    }
  }

  void removePhoneField(int index) {
    if (phoneControllers.length > 1) {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
    }
  }

 /* Future<void> setLocation(
      double lat,
      double lng, {
        bool moveCamera = true,
      }) async {
    latitude.value = lat;
    longitude.value = lng;

    pharmacyMarker.value = Marker(
      markerId: const MarkerId('pharmacy_marker'),
      position: LatLng(lat, lng),
      draggable: true, // 🔥 صار draggable
      onDragEnd: (newPosition) {
        latitude.value = newPosition.latitude;
        longitude.value = newPosition.longitude;
        print("📍 Dragged to: ${newPosition.latitude}, ${newPosition.longitude}");
      },
    );

    if (moveCamera && mapController.value != null) {
      await mapController.value!.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );
    }
  }*/
/*  Future<void> setLocation(
    double lat,
    double lng, {
    bool moveCamera = true,
  }) async {
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
  }*/

  // الحصول على الموقع الحالي للجهاز
 /* Future<void> moveToCurrentLocation() async {
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

  Future<void> setDarkMapStyle() async {
    if (mapController.value == null) return;

    final style = await rootBundle.loadString('assets/map_dark.json');
    mapController.value!.setMapStyle(style);
  }
*/
  /*void applyMapStyle() {
    if (mapController.value == null) return;

    if (Get.isDarkMode) {
      setDarkMapStyle();
    } else {
      mapController.value!.setMapStyle(null);
    }
  }*/

  Future<void> pickOpenTime(BuildContext context, Color c) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      builder: (context, child) {
        final isDark = Get.isDarkMode;

        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: c,
              hourMinuteColor: AppColors.primaryColor,
              hourMinuteTextColor: AppColors.gray,
              dialHandColor: AppColors.primaryColor,
              entryModeIconColor: AppColors.primaryColor,

              dayPeriodTextColor: AppColors.gray,
              dayPeriodColor: isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              helpTextStyle: TextStyle(
                color: AppColors.gray,
                fontFamily: 'Cairo',
              ),
            ),

            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      openTime.value = picked;
    }
  }

  Future<void> pickCloseTime(BuildContext context, Color c) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        final isDark = Get.isDarkMode;

        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: c,
              hourMinuteColor: AppColors.primaryColor,
              hourMinuteTextColor: AppColors.gray,
              dialHandColor: AppColors.primaryColor,
              entryModeIconColor: AppColors.primaryColor,

              dayPeriodTextColor: AppColors.gray,
              dayPeriodColor: isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              helpTextStyle: TextStyle(
                color: AppColors.gray,
                fontFamily: 'Cairo',
              ),
            ),

            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      closeTime.value = picked;
    }
  }

  @override
  void onClose() {
   /* ever(Get.isDarkMode.obs, (isDark) {
      applyMapStyle();
    });*/
    pharmacyNameController.dispose();
    pharmacistsNameController.dispose();
    commentsController.dispose();
    for (var c in phoneControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
