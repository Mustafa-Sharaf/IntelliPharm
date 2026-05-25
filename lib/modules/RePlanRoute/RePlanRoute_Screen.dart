import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/SelectablePharmacyCard.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import 'RePlanRoute_Controller.dart';

class RePlanRouteScreen extends StatelessWidget {
  const RePlanRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    Get.lazyPut(() => MapHelperController(), tag: "route");
    final size = MediaQuery.of(context).size;
    final RePlanRouteController controller = Get.put(RePlanRouteController());
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MapHelperScreen(
                  tag: "route",
                  right: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.backgroundMain,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: size.height * 0.05,
                        height: size.height * 0.005,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Re-plan Route",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(
                      "WHY ARE YOU RE-PLANNING ?",
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _reasonChip(
                          title: "Traffic Jam",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Road Closure",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Accident Ahead",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Pharmacy Closed",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Schedule Change",
                          controller: controller,
                        ),
                        _reasonChip(title: "Other", controller: controller),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "REMOVE UNVISITED STOPS",
                          style: TextStyle(
                            color: colors.textDefault,
                            fontFamily: 'Cairo',
                            fontSize: 13,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "2 STOPS REMAINING",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    SizedBox(
                      height: size.height * 0.22,
                      child: ListView(children: [
                        SelectablePharmacyCard(
                          id: 1,
                          title: "pharmacy.name",
                          subtitle: "pharmacy.region",
                          checked: true,
                        ),
                        SelectablePharmacyCard(
                          id: 2,
                          title: "pharmacy.name",
                          subtitle: "pharmacy.region",
                          checked: false,
                        ),
                        SelectablePharmacyCard(
                          id: 2,
                          title: "pharmacy.name",
                          subtitle: "pharmacy.region",
                          checked: false,
                        ),
                        SelectablePharmacyCard(
                          id: 2,
                          title: "pharmacy.name",
                          subtitle: "pharmacy.region",
                          checked: false,
                        ),

                      ],),
                    ),


                    SizedBox(height: size.height * 0.01),
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(Icons.alt_route, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Re-plan Now", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasonChip({
    required String title,
    required RePlanRouteController controller,
  }) {
    bool isSelected = controller.selectedReason == title;

    return GestureDetector(
      onTap: () => controller.selectReason(title),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D3B66) : Colors.white,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: isSelected ? const Color(0xFF0D3B66) : Colors.grey.shade300,
          ),
        ),

        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0D3B66),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/*
class RePlanRouteModal extends StatelessWidget {
  RePlanRouteModal({super.key});

  final RePlanRouteController controller =
  Get.put(RePlanRouteController());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: GetBuilder<RePlanRouteController>(
          builder: (_) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// drag handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),





                  const SizedBox(height: 20),

                  _stopCard(
                    index: 0,
                    title: "Central Care Pharma",
                    time: "Estimated arrival: 14:20",
                    icon: Icons.local_pharmacy_outlined,
                    controller: controller,
                  ),

                  _stopCard(
                    index: 1,
                    title: "St. Jude Medical",
                    time: "Estimated arrival: 15:05",
                    icon: Icons.medical_services_outlined,
                    controller: controller,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3B66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      label: const Text(
                        "Re-plan Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      icon: const Icon(
                        Icons.alt_route,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        letterSpacing: 1,
      ),
    );
  }

  Widget _reasonChip({
    required String title,
    required RePlanRouteController controller,
  }) {
    bool isSelected =
        controller.selectedReason == title;

    return GestureDetector(
      onTap: () => controller.selectReason(title),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0D3B66)
              : Colors.white,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: isSelected
                ? const Color(0xFF0D3B66)
                : Colors.grey.shade300,
          ),
        ),

        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : const Color(0xFF0D3B66),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _stopCard({
    required int index,
    required String title,
    required String time,
    required IconData icon,
    required RePlanRouteController controller,
  }) {
    bool isChecked =
    controller.selectedStops.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: const Color(0xFF0D3B66),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Checkbox(
            value: isChecked,

            activeColor: const Color(0xFF0D3B66),

            onChanged: (_) {
              controller.toggleStop(index);
            },
          ),
        ],
      ),
    );
  }
}*/
