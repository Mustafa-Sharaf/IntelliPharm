import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/PharmacyOrderCard.dart';
import '../../Widgets/StatCard.dart';
import '../../app_theme/theme_extension.dart';
import '../PlanYourRoute/PlanYourRoute_Screen.dart';

class HomeContentDistributorScreen extends StatelessWidget {
  const HomeContentDistributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1.(Warning Alert)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.018
              ),
              decoration: BoxDecoration(
                color: const Color(0xffFFF9E6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xffFFEAA7).withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xffD97706),
                    size: 26,
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Text(
                      "${"Order".tr} #1055 ${"due in 45 minutes".tr}",
                      style: const TextStyle(
                        color: Color(0xff78350F),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            /// 2.  (Start Delivery Route)
            InkWell(
              onTap: () {
                print("Get.to(()=> PlanYourRouteScreen())");
               Get.to(()=> PlanYourRouteScreen());
              },
              splashColor: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.02
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      child: Text(
                        "Start Delivery Route".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.inventory_2_outlined,
                    value: "24",
                    title: "ASSIGNED".tr,
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: StatCard(
                    icon: Icons.check_circle_outline_rounded,
                    value: "12",
                    title: "COMPLETED".tr,
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: StatCard(
                    icon: Icons.local_shipping_outlined,
                    value: "8",
                    title: "IN TRANSIT".tr,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            /// 4. شريط العناوين "Today's Deliveries"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Deliveries".tr,
                  style: TextStyle(
                    fontSize: size.width * 0.048,
                    fontWeight: FontWeight.bold,
                    color: colors.textDefault,
                    fontFamily: 'Cairo',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // الانتقال لعرض الخريطة كاملة
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "View Map".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff016E65),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Column(
              children: [
                PharmacyOrderCard(
                  orderNumber: "1052",
                  pharmacyName: "Al-Shifa Pharmacy",
                  itemsCount: 15,
                  priority: OrderPriority.urgent,
                  status: OrderStatus.pending,
                  onTap: () {
                    print("فتح تفاصيل طلب الشفاء");
                  },
                ),


                PharmacyOrderCard(
                  orderNumber: "1048",
                  pharmacyName: "HealthFirst Clinic",
                  itemsCount: 8,
                  priority: OrderPriority.normal,
                  status: OrderStatus.inTransit,
                  onTap: () {
                    print("تتبع طلب هيلث فيرست");
                  },
                ),


                PharmacyOrderCard(
                  orderNumber: "1045",
                  pharmacyName: "City Pharma Labs",
                  itemsCount: 22,
                  priority: OrderPriority.low,
                  status: OrderStatus.delivered,
                  onTap: () {
                    print("عرض فاتورة سيتي فارما المستلمة");
                  },
                ),
              ],
            )


          ],
        ),
      ),
    );
  }
}