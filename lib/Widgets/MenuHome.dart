import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_controller.dart';
import '../app_theme/theme_extension.dart';
import 'LanguageBottomSheet.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.23,
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/LogoSmall.png'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'My_Profile'.tr,
              style: TextStyle(
                fontSize: 16,
                color: colors.text,
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
                color: colors.text,
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
                color: colors.text,
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
                color: colors.text,
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
                color: colors.text,
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
                color: colors.text,
                fontFamily: 'Cairo',
              ),
            ),
            onTap: ()=>Get.toNamed("/signIn"),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text(
              'Privacy_Policy'.tr,
              style: TextStyle(
                fontSize: 16,
                color: colors.text,
                fontFamily: 'Cairo',
              ),
            ),
            onTap:()=>Get.toNamed("/signIn"),
          ),
        ],
      ),
    );
  }
}
