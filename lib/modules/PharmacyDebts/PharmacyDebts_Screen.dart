import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/BuildFilterChipsDebts.dart';
import '../../Widgets/BuildPharmacyCardDebts.dart';
import '../../Widgets/BuildSummaryCardDebts.dart';
import '../../app_theme/theme_extension.dart';
import '../Searching/Searching_Controller.dart';
import '../Searching/Searching_Screen.dart';
import 'PharmacyDebt_Controller.dart';
import 'PharmacyDebt_Model.dart';

class PharmacyDebtsScreen extends StatelessWidget {
  PharmacyDebtsScreen({super.key});
  final searchController = SearchControllerX();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PharmacyDebtController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: controller.loadDebts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        return ValueListenableBuilder<List<PharmacyDebtModel>>(
          valueListenable: controller.filteredDebtsNotifier,
          builder: (context, filteredDebts, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildSummaryCardDebts(),
                  SizedBox(height: size.height * 0.02),
                  CustomSearchField(
                    controller: searchController,
                    text: "Search_Pharmacists...".tr,
                    onChanged: (val) {
                      controller.updateSearch(val);
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  BuildFilterChipsDebts(),
                  SizedBox(height: size.height * 0.02),
                  ValueListenableBuilder<List<PharmacyDebtModel>>(
                    valueListenable: controller.filteredDebtsNotifier,
                    builder: (context, debts, _) {
                      final totalAmount = debts.fold(
                        0.0,
                        (sum, item) => sum + item.remainingAmount,
                      );
                      return Text(
                        '${debts.length} Pharmacies - ${totalAmount.toStringAsFixed(0)} S.p Outstanding',
                        style: TextStyle(
                          color: colors.textDefault,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Cairo',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredDebts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return BuildPharmacyCardDebts(item: filteredDebts[index]);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
