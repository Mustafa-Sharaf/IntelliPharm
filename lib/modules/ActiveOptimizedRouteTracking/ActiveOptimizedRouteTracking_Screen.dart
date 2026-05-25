
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/RouteStepItem.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import 'CurrentRouteHeader.dart';


class ActiveOptimizedRouteTrackingScreen extends StatelessWidget {
  const ActiveOptimizedRouteTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    Get.lazyPut(() => MapHelperController(), tag: "route");
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MapHelperScreen(
                  tag: "route",
                  right: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  RefreshButtonBottom: MediaQuery.of(context).size.height * 0.1,
                  RefreshButtonRight: MediaQuery.of(context).size.height * 0.01,
                  showRefreshButton: true,
                ),
                CurrentRouteHeader(),
              ],
            ),
          ),

          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.backgroundMain,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
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
                    SizedBox(height: size.height * 0.02,),

                    /// Next Destination Section
                    Text(
                      "NEXT_DESTINATION".tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        letterSpacing: 2,
                        fontSize: 12,
                        height: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Central Care Pharma",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    color: colors.textDefault
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: size.width * 0.004),
                                  Text(
                                    "10:15 AM",
                                    style: TextStyle(color: Colors.grey[600],
                                        fontFamily: 'Cairo'),
                                  ),
                                  SizedBox(width: size.width * 0.016),
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: size.width * 0.004),
                                  Text(
                                    "2.4 km",
                                    style: TextStyle(color: Colors.grey[600],
                                        fontFamily: 'Cairo'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.navigation_outlined, size: 18),
                          label: Text("Navigate".tr, style: TextStyle(
                              fontFamily: 'Cairo', fontSize: 15),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.06),
                    Text(
                      "ROUTE_SCHEDULE".tr,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        letterSpacing: 2,

                      ),
                    ),
                    SizedBox(height: size.width * 0.04),
                    RouteStepItem(
                      title: "Pharmacy One",
                      subtitle: "2.3 km away",
                      index: "1",
                      isCurrent: true,
                      showDetails: true,
                      onDetailsPressed: () {},
                    ),
                    RouteStepItem(
                      title: "Pharmacy One",
                      subtitle: "2.3 km away",
                      index: "2",
                      isCurrent: false,
                      showDetails: false,
                      isDone: true,
                      onDetailsPressed: () {},
                    ),

                    RouteStepItem(
                      title: "Last Stop",
                      subtitle: "Destination",
                      index: "5",
                      showLine: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

