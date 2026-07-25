
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/PlanYourRoute/PlanYourRoute_Screen.dart';


class PlanRouteCard extends StatelessWidget {
  const PlanRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(PlanYourRouteScreen());
      },
      child: SizedBox(
        height: size.height * 0.21,
        width: size.width * 0.96,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xff016E65)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.asset(
                        'assets/images/DrawerHeaderImage.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width * 0.03),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: size.width * 0.07,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Image.asset('assets/icons/location.png'),
                        ),
                        const Spacer(),
                        Text(
                          "PlanToday'sRoute".tr,
                          style: TextStyle(
                            fontSize: size.width * 0.055,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),

                        Text(
                          "Today's_planned_visits".tr,
                          style: TextStyle(
                            fontSize: size.width * 0.033,
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
