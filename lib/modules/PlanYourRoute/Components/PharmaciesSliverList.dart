import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../../Widgets/EmptyCard.dart';
import '../../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../../Widgets/SelectablePharmacyCard.dart';
import '../PlanYourRoute_Controller.dart';

class PharmaciesSliverList extends StatelessWidget {
  const PharmaciesSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    final planYourRouteController = Get.find<PlanYourRouteController>();

    return Obx(() {
      /// 1. حالة التحميل الأولي (Loading State)
      if (planYourRouteController.isLoading.value &&
          planYourRouteController.pharmacies.isEmpty) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        );
      }

      /// 2. حالة القائمة الفارغة (Empty State)
      if (planYourRouteController.pharmacies.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: EmptyPlanCard(
              title: "Nothing_pharmacies_yet.".tr,
              subtitle:
              "The_pharmacies_will_appear_here_once_you_have_selected_the_area_you_will_be_visiting."
                  .tr,
              buttonText: "SelectRegion".tr,
              onPressed: () async {
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => RegionSelector(),
                );

                if (result != null) {
                  planYourRouteController.updateRegion(result);
                }
              },
            ),
          ),
        );
      }

      /// 3. عرض قائمة الصيدليات (Pharmacies List)
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            // مؤشر تحميل إضافي عند السحب للأسفل (Pagination Loader)
            if (index == planYourRouteController.filteredPharmacies.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            }

            final pharmacy =
            planYourRouteController.filteredPharmacies[index];

            return Obx(() {
              final isSelected = planYourRouteController.selectedPharmacies
                  .contains(pharmacy.id);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () =>
                      planYourRouteController.togglePharmacy(pharmacy.id),
                  child: SelectablePharmacyCard(
                    id: pharmacy.id,
                    title: pharmacy.name,
                    subtitle: pharmacy.region,
                    checked: isSelected,
                  ),
                ),
              );
            });
          },
          childCount: planYourRouteController.filteredPharmacies.length +
              (planYourRouteController.hasMore.value ? 1 : 0),
        ),
      );
    });
  }
}