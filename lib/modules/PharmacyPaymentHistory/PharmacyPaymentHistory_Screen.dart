/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/BuildPaymentsListDebts.dart';
import '../../Widgets/BuildSummaryHeaderCardDebt.dart';
import '../../app_theme/theme_extension.dart';
import '../../Widgets/BuildInvoicesListDebts.dart';
import '../Payments/PaymentBinding.dart';
import '../Payments/RecordPayment_Screen.dart';
import '../PharmacyDebts/PharmacyDebt_Model.dart';
import 'PharmacyPaymentHistory_Controller.dart';

class PharmacyPaymentHistoryScreen extends StatelessWidget {
  final PharmacyDebtModel pharmacy;

  const PharmacyPaymentHistoryScreen({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PharmacyPaymentHistoryController(),
      tag: pharmacy.id,
    );
    controller.loadPharmacyHistory(pharmacy.id);

    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          pharmacy.name,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.01,
        ),
        child: Column(
          children: [
            PharmacySummaryHeaderCard(
              title: pharmacy.location,
              subtitle: 'Remaining_Balance'.tr,
              remainingAmount: pharmacy.remainingAmount,
              totalBilled: pharmacy.totalAmount,
              totalPaid: pharmacy.paidAmount,
              status: pharmacy.status,
            ),
            SizedBox(height: size.height * 0.015),
            Container(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
              decoration: BoxDecoration(
                color: colors.component,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    SizedBox(height: size.height * 0.004),
                    Text(
                      'Last_Payment'.tr,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      pharmacy.lastPaymentDate,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Obx(
              () => Container(
                padding: EdgeInsets.all(size.height * 0.004),
                decoration: BoxDecoration(
                  color: colors.component,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: controller.selectedTabIndex.value == 0
                                ? colors.backgroundMain
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: controller.selectedTabIndex.value == 0
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Payments'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: controller.selectedTabIndex.value == 0
                                  ? colors.textPrimary
                                  : colors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: controller.selectedTabIndex.value == 1
                                ? colors.backgroundMain
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: controller.selectedTabIndex.value == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Invoices/Orders'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: controller.selectedTabIndex.value == 1
                                  ? colors.textPrimary
                                  : colors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }
              return controller.selectedTabIndex.value == 0
                  ? BuildPaymentsListDebts(controller: controller)
                  : BuildInvoicesListDebts(controller: controller);
            }),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: 10,
          ),
          child: SizedBox(
            height: size.height * 0.06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final result = await Get.to(
                  () => RecordPaymentScreen(pharmacy: pharmacy),
                  binding: PaymentBinding(),
                );
                if (result == true) {
                  controller.loadPharmacyHistory(pharmacy.id);
                }
              },
              icon: const Icon(Icons.payments_outlined, color: Colors.white),
              label: Text(
                'Record_Payment'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/BuildPaymentsListDebts.dart';
import '../../Widgets/BuildSummaryHeaderCardDebt.dart';
import '../../app_theme/theme_extension.dart';
import '../../Widgets/BuildInvoicesListDebts.dart';
import '../Payments/PaymentBinding.dart';
import '../Payments/RecordPayment_Screen.dart';
import '../PharmacyDebts/PharmacyDebt_Model.dart';
import 'PharmacyPaymentHistory_Controller.dart';

class PharmacyPaymentHistoryScreen extends StatelessWidget {
  final PharmacyDebtModel pharmacy;

  const PharmacyPaymentHistoryScreen({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PharmacyPaymentHistoryController(),
      tag: pharmacy.id,
    );
    controller.loadPharmacyHistory(pharmacy.id);

    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Get.back(result: true), // إرجاع true لتحديث الشاشة السابقة
        ),
        title: Text(
          pharmacy.name,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // إذا كان الكونترولر يحفظ كائن الصيدلية المحدث داخل Rx variable مثل pharmacyData
        // سنقرأ منه مباشرة، وإلا نقوم بحساب المبالغ من الفواتير والدفعات المحملة.
        final remaining = controller.pharmacyData.value?.remainingAmount ?? pharmacy.remainingAmount;
        final totalBilled = controller.pharmacyData.value?.totalAmount ?? pharmacy.totalAmount;
        final totalPaid = controller.pharmacyData.value?.paidAmount ?? pharmacy.paidAmount;
        final lastPayment = controller.pharmacyData.value?.lastPaymentDate ?? pharmacy.lastPaymentDate;
        final status = controller.pharmacyData.value?.status ?? pharmacy.status;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.01,
          ),
          child: Column(
            children: [
              // كارت ملخص الديون - يتم تحديثه تلقائياً
              PharmacySummaryHeaderCard(
                title: pharmacy.location,
                subtitle: 'Remaining_Balance'.tr,
                remainingAmount: remaining,
                totalBilled: totalBilled,
                totalPaid: totalPaid,
                status: status,
              ),
              SizedBox(height: size.height * 0.015),

              // تاريخ آخر دفعة - يتم تحديثه تلقائياً
              Container(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                decoration: BoxDecoration(
                  color: colors.component,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      SizedBox(height: size.height * 0.004),
                      Text(
                        'Last_Payment'.tr,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 11,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        lastPayment,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // تبويبات الانتقال (Payments / Invoices)
              Container(
                padding: EdgeInsets.all(size.height * 0.004),
                decoration: BoxDecoration(
                  color: colors.component,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: controller.selectedTabIndex.value == 0
                                ? colors.backgroundMain
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: controller.selectedTabIndex.value == 0
                                ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                              ),
                            ]
                                : [],
                          ),
                          child: Text(
                            'Payments'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: controller.selectedTabIndex.value == 0
                                  ? colors.textPrimary
                                  : colors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: controller.selectedTabIndex.value == 1
                                ? colors.backgroundMain
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: controller.selectedTabIndex.value == 1
                                ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                              ),
                            ]
                                : [],
                          ),
                          child: Text(
                            'Invoices/Orders'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: controller.selectedTabIndex.value == 1
                                  ? colors.textPrimary
                                  : colors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // عرض القائمة المحددة
              if (controller.isLoading.value)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              else
                controller.selectedTabIndex.value == 0
                    ? BuildPaymentsListDebts(controller: controller)
                    : BuildInvoicesListDebts(controller: controller),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: 10,
          ),
          child: SizedBox(
            height: size.height * 0.06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final result = await Get.to(
                      () => RecordPaymentScreen(pharmacy: pharmacy),
                  binding: PaymentBinding(),
                );
                if (result == true) {
                  // إعادة تحميل بيانات السجل فور تسجيل عملية دفع جديدة
                  controller.loadPharmacyHistory(pharmacy.id);
                }
              },
              icon: const Icon(Icons.payments_outlined, color: Colors.white),
              label: Text(
                'Record_Payment'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}