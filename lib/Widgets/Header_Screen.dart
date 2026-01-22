import 'package:flutter/material.dart';
import '../app_theme/AppColors.dart';


class HeaderScreen extends StatelessWidget {
  const HeaderScreen({super.key,required this.title,required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
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
                    AppColors.primaryColor2,
                  ],
                ),
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== PROFILE IMAGE =====
          Positioned(
            bottom: -25,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                image: const DecorationImage(
                  image: AssetImage('assets/images/login_img.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
    );
  }
}


// ===== CLIPPER =====
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