import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_controller.dart';


//New code
class HeaderScreen extends StatelessWidget {
  const HeaderScreen({super.key,required this.title,required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: 260,
              width: double.infinity,
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor,
                  ],
                ),
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
          /// ===== PROFILE IMAGE =====
          Positioned(
            bottom: -25,
            child: Obx(() => Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
                image: DecorationImage(
                  image: themeController.isDarkMode.value
                      ? const AssetImage('assets/images/login_img_dark.png')
                      : const AssetImage('assets/images/login_img.png'),
                  fit: BoxFit.cover,
                ),
              ),
            )),
          ),
        ],
    );
  }
}


/// ===== CLIPPER =====
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 70,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}