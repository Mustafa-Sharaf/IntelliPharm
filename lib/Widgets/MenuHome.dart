import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_controller.dart';
import '../app_theme/theme_extension.dart';
import 'LanguageBottomSheet.dart';

//New code
class DrawerHome extends StatelessWidget {
  const DrawerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.21,
              child: SizedBox(
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(color: Color(0xff016E65)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            'assets/images/DrawerHeaderImage.png',
                            fit: BoxFit.cover,
                            alignment: Alignment(0, -0.6),
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            'assets/images/DrawerHeaderImage.png',
                            fit: BoxFit.cover,
                            alignment: Alignment(0, -0.6),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10,right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IntelliPharma'.tr,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.008,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'assets/images/LogoSmall.png',
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.005,
                            ),
                            Text(
                              'MySitting'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.white70,
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

            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'My_Profile'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                //Get.toNamed('/profileScreen');
              },
            ),
            ListTile(
              leading: Icon(Icons.gps_fixed_rounded),
              title: Text(
                'My Targets'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                //Get.toNamed('/profileScreen');
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(
                'Application_language'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (_) => LanguageBottomSheet(),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text(
                'Theme_Toggle'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () => themeController.toggleTheme(),
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text(
                'Support'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text(
                'Share_Application'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () => Get.toNamed("/signIn"),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text(
                'Privacy_Policy'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () => Get.toNamed("/signIn"),
            ),
          ],
        ),
      ),
    );
  }
}
