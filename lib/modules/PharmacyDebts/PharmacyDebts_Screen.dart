/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intl/intl.dart';
import '../../Widgets/BuildFilterChipsDebts.dart';
import '../../Widgets/BuildPharmacyCardDebts.dart';
import '../../Widgets/BuildSummaryHeaderCardDebt.dart';
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

                  PharmacySummaryHeaderCard(
                    title: 'TOTAL_OUTSTANDING_BALANCE'.tr,
                    remainingAmount: controller.totalOutstanding,
                    totalBilled: controller.totalBilled,
                    totalPaid: controller.totalCollected,
                  ),
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
                        'pharmacies_outstanding_summary'.trParams({
                          'count': debts.length.toString(),
                          'amount': NumberFormat('#,##0.##', 'en_US').format(totalAmount),
                        }),
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
                  if (filteredDebts.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.08),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: size.width * 0.18,
                            color: colors.textSecondary.withValues(alpha: 0.4),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            'No_debts_or_records_found'.tr,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    )
                  else
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
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intl/intl.dart';
import '../../Widgets/BuildFilterChipsDebts.dart';
import '../../Widgets/BuildPharmacyCardDebts.dart';
import '../../Widgets/BuildSummaryHeaderCardDebt.dart';
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

    return Obx(() {
      // إظهار مؤشر التحميل فقط عند شحن البيانات لأول مرة
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      return ValueListenableBuilder<List<PharmacyDebtModel>>(
        valueListenable: controller.filteredDebtsNotifier,
        builder: (context, filteredDebts, _) {
          final currentBilled = filteredDebts.fold(
            0.0,
                (sum, item) => sum + item.totalAmount,
          );
          final currentPaid = filteredDebts.fold(
            0.0,
                (sum, item) => sum + item.paidAmount,
          );
          final currentRemaining = filteredDebts.fold(
            0.0,
                (sum, item) => sum + item.remainingAmount,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PharmacySummaryHeaderCard(
                  title: 'TOTAL_OUTSTANDING_BALANCE'.tr,
                  remainingAmount: currentRemaining,
                  totalBilled: currentBilled,
                  totalPaid: currentPaid,
                ),
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
                Text(
                  'pharmacies_outstanding_summary'.trParams({
                    'count': filteredDebts.length.toString(),
                    'amount': NumberFormat('#,##0.##', 'en_US').format(currentRemaining),
                  }),
                  style: TextStyle(
                    color: colors.textDefault,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                if (filteredDebts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: size.width * 0.18,
                          color: colors.textSecondary.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'No_debts_or_records_found'.tr,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  )
                else
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
    });
  }
}