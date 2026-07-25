
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_controller.dart';
import '../app_theme/theme_extension.dart';
import '../modules/PrivacyPolicyScreen/PrivacyPolicyScreen_Screen.dart';
import 'LanguageBottomSheet.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final String role = GetStorage().read<String>('role') ?? 'rep';

    return SizedBox(
      width: size.width * 0.68,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xff016E65),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/images/DrawerHeaderImage.png',
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.6),
                      ),
                    ),
                  ),

                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'IntelliPharma'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                           CircleAvatar(
                            radius: size.width *0.07,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(
                                'assets/images/LogoSmall.png',
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            'MySitting'.tr,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.white.withValues(alpha: 0.85),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: colors.textDefault),
              title: Text(
                'My_Profile'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {},
            ),
            if (role == 'rep')
              ListTile(
                leading: Icon(
                  Icons.gps_fixed_rounded,
                  color: colors.textDefault,
                ),
                title: Text(
                  'My_Targets'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: colors.textDefault,
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: () {},
              ),
            ListTile(
              leading: Icon(Icons.language, color: colors.textDefault),
              title: Text(
                'Application_language'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (_) => LanguageBottomSheet(),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6, color: colors.textDefault),
              title: Text(
                'Theme_Toggle'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () => themeController.toggleTheme(),
            ),
            ListTile(
              leading: Icon(Icons.support, color: colors.textDefault),
              title: Text(
                'Support'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.share, color: colors.textDefault),
              title: Text(
                'Share_Application'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: colors.textDefault),
              title: Text(
                'Logout'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () => Get.toNamed("/login"),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: colors.textDefault),
              title: Text(
                'Privacy_Policy'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textDefault,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                Get.back();
                Get.to(()=>PrivacyPolicyScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
