import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'TrackRoute_Controller.dart';

class TrackRouteScreen extends StatelessWidget {
  TrackRouteScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final RxList predictions = <dynamic>[].obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackRouteController());

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: [
            Obx(
              () => GoogleMap(
                onMapCreated: (mapCtrl) {
                  controller.mapController.value = mapCtrl;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.latitude.value,
                    controller.longitude.value,
                  ),
                  zoom: 14,
                ),
                markers: {controller.pharmacyMarker.value},
                onTap: (point) {
                  controller.setLocation(point.latitude, point.longitude);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),

            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "ابحث عن موقع...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) async {
                        if (value.isNotEmpty) {
                          var results = await controller.searchPlace(value);
                          predictions.value = results;
                        } else {
                          predictions.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
