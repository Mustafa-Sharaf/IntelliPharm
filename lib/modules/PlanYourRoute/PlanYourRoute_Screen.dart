import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/DateCard.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/DateHelper.dart';
import '../TrackRoute/TrackRoute_Screen.dart';
import 'ActiveRegionComponent.dart';
import 'PlanYourRoute_Controller.dart';

class PlanYourRouteScreen extends StatelessWidget {
  const PlanYourRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.put(PlanYourRouteController());

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "Plan Your Route",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey, height: 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              DateCard(),
              SizedBox(height: size.height * 0.022),
              ActiveRegionComponent(),
              SizedBox(height: size.height * 0.024),

              /// Pharmacies title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Pharmacies to Visit",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff52E0D3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: /*const Text(
                      "4 selected",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        color: Color(0xff0D2C5A),
                        fontWeight: FontWeight.w600,
                      ),
                    )*/Obx(
                          () => Text(
                        "${controller.selectedPharmacies.length} selected",
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          color: Color(0xff0D2C5A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.014),

              /// Search
              TextField(
                decoration: InputDecoration(
                  hintText: "Search pharmacy name or ZIP...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: colors.component,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              /// Pharmacy List
              Expanded(
                child: Obx(() {

                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.pharmacies.isEmpty) {
                    return const Center(
                      child: Text("No pharmacies found"),
                    );
                  }

                  return ListView.builder(

                    itemCount: controller.pharmacies.length,

                    itemBuilder: (context, index) {

                      final pharmacy = controller.pharmacies[index];

                      final isSelected = controller.selectedPharmacies
                          .contains(pharmacy.id);

                      return GestureDetector(

                        onTap: () {
                          controller.togglePharmacy(pharmacy.id);
                        },

                        child: PharmacyCard(

                          title: pharmacy.name,

                          subtitle: pharmacy.region,

                          colorDot: Colors.teal,

                          checked: isSelected,
                        ),
                      );
                    },
                  );
                }),
              ),
            /*  Expanded(
                child: ListView(
                  children: const [
                    PharmacyCard(
                      title: "Central Care Pharma",
                      subtitle: "122 Medical Plaza, Ste 402, North District",
                      colorDot: Colors.red,
                      checked: true,
                    ),
                    PharmacyCard(
                      title: "MedPlus Express",
                      subtitle: "88 Health Blvd, North District",
                      colorDot: Colors.orange,
                      checked: true,
                    ),
                    PharmacyCard(
                      title: "Wellness Hub 24/7",
                      subtitle: "15 Park Lane, North District",
                      colorDot: Colors.teal,
                      checked: false,
                    ),
                    PharmacyCard(
                      title: "St. Jude Medical",
                      subtitle: "75 Care Avenue, North District",
                      colorDot: Colors.red,
                      checked: true,
                    ),
                  ],
                ),
              ),*/

              /// Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 18),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(TrackRouteScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00796B),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Generate Optimal Route",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PharmacyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color colorDot;
  final bool checked;

  const PharmacyCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.colorDot,
    required this.checked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: checked ? Colors.white : const Color(0xffF0F1F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: checked ? const Color(0xff0D2C5A) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: checked ? const Color(0xff0D2C5A) : Colors.grey.shade400,
              ),
            ),
            child: checked
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: checked ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: checked ? Colors.grey : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(radius: 4, backgroundColor: colorDot),
        ],
      ),
    );
  }
}
