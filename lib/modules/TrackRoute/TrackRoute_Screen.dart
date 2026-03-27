import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Widgets/CustomTextField.dart';
import '../../app_theme/AppColors.dart';
import 'TrackRoute_Controller.dart';


class TrackRouteScreen extends StatelessWidget {
  TrackRouteScreen({super.key});

  final controller = Get.put(TrackRouteController());

  final List<String> regions = [
    // دمشق
    "الميدان",
    "الشاغور",
    "ركن الدين",
    "المزة",
    "كفرسوسة",
    "دمر",
    "برزة",
    "القابون",
    "جوبر",
    "ساروجة",
    "الصالحية",
    "المهاجرين",
    "القنوات",
    "القدم",
    "اليرموك",

    // أحياء
    "أبو رمانة",
    "المالكي",
    "الشعلان",
    "البرامكة",
    "القصاع",
    "باب توما",

    // ريف دمشق
    "جرمانا",
    "صحنايا",
    "داريا",
    "قدسيا",
    "التل",
    "دوما",
    "حرستا",
    "سقبا",
    "كفربطنا",
    "عين ترما",
    "زملكا",
    "المليحة",
  ];

  final List<String> types = [
    "خطة جديدة",
    "تحديث خطة",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
            onMapCreated: (mapCtrl) {
              controller.mapController.value = mapCtrl;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.latitude.value, controller.longitude.value),
              zoom: 14,
            ),
            markers: {controller.pharmacyMarker.value},
            onTap: (point) {
              controller.setLocation(point.latitude, point.longitude);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          )),
          Positioned(
            right: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.33,
            child: FloatingActionButton(
              onPressed: controller.moveToCurrentLocation,
              backgroundColor: AppColors.white,
              child: Icon(Icons.my_location,color: AppColors.primaryColor,),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => _buildSelector(
                    title: "Region",
                    value: controller.selectedRegion.value,
                    icon: Icons.map,
                    iconColor: AppColors.primaryColor,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return RegionSelector();
                        },
                      );
                    },
                  )),
                  SizedBox(height: 10),
                  Obx(() => _buildSelector(
                    title: "Type",
                    value: controller.selectedType.value,
                    icon: Icons.sync_alt,
                    iconColor: AppColors.primaryColor,
                    onTap: () => _showBottomList(
                      context,
                      "اختر النوع",
                      types,
                          (val) => controller.selectedType.value = val,
                    ),
                  )),

                  CustomTextField(
                    label: "Reason details",
                    icon: Icons.edit_note,
                    //controller: controller.pharmacyNameController,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: Text(
                        "Send".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SELECTOR UI =================
  Widget _buildSelector({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,//Colors.grey[200]
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon,color: iconColor,),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value.isEmpty ? title : "$title: $value",
                style: TextStyle(fontSize: 16,color: AppColors.gray),
              ),
            ),
            Icon(Icons.arrow_drop_down,color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }

  /// ================= BOTTOM LIST =================
  void _showBottomList(
      BuildContext context,
      String title,
      List<String> items,
      Function(String) onSelect,
      ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...items.map(
                  (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onSelect(e);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }
}

/*class TrackRouteScreen extends StatelessWidget {
  TrackRouteScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final RxList predictions = <dynamic>[].obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackRouteController());
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Obx(
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
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return RegionSelector();
                    },
                  );
                },
                icon: const Icon(Icons.map, color: Colors.white),
                label: Text(
                  "Region",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sync_alt, color: Colors.white),
                label: Text(
                  "Reason".tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.my_location, color: Colors.white),
                label: Text(
                  "Current location".tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
          CustomTextField(
            label: "Reason details",
            icon: Icons.comment,
            //controller: controller.pharmacyNameController,
          ),

          SizedBox(
            height: 50,
            width: 180,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.send, color: AppColors.primaryColor),
              label: Text(
                "Send",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontFamily: 'Cairo',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
class RegionSelector extends StatefulWidget {
  const RegionSelector({super.key});

  @override
  _RegionSelectorState createState() => _RegionSelectorState();
}

class _RegionSelectorState extends State<RegionSelector> {
  final TextEditingController searchController = TextEditingController();

  List<String> regions = [
    // دمشق
    "الميدان",
    "الشاغور",
    "ركن الدين",
    "المزة",
    "كفرسوسة",
    "دمر",
    "برزة",
    "القابون",
    "جوبر",
    "ساروجة",
    "الصالحية",
    "المهاجرين",
    "القنوات",
    "القدم",
    "اليرموك",

    // أحياء
    "أبو رمانة",
    "المالكي",
    "الشعلان",
    "البرامكة",
    "القصاع",
    "باب توما",

    // ريف دمشق
    "جرمانا",
    "صحنايا",
    "داريا",
    "قدسيا",
    "التل",
    "دوما",
    "حرستا",
    "سقبا",
    "كفربطنا",
    "عين ترما",
    "زملكا",
    "المليحة",
  ];

  List<String> filteredRegions = [];

  @override
  void initState() {
    super.initState();
    filteredRegions = regions;
  }

  void filter(String value) {
    setState(() {
      filteredRegions = regions
          .where((region) => region.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            /// 🔍 Search
            TextField(
              controller: searchController,
              onChanged: filter,
              decoration: InputDecoration(
                hintText: "ابحث عن منطقة...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 15),

            /// 📍 List
            Expanded(
              child: ListView.builder(
                itemCount: filteredRegions.length,
                itemBuilder: (context, index) {
                  final region = filteredRegions[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.location_city, color: AppColors.primaryColor),
                      title: Text(
                        region,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        // هون خزّن المنطقة بالكنترولر
                        print("Selected: $region");

                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* Positioned(
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
                ),*/
