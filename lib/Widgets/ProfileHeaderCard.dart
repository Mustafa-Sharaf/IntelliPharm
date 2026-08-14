import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../modules/Profile/Profile_Model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final RepUser rep;
  const ProfileHeaderCard({super.key, required this.rep});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  rep.name.isNotEmpty ? rep.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.007,
                right: size.height * 0.001,
                child: Container(
                  width: size.height * 0.02,
                  height: size.height * 0.02,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            rep.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'Senior Sales Representative'.tr,
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(Icons.email, rep.email, colors),
              SizedBox(width: size.width * 0.015),
              _buildBadge(
                Icons.badge_outlined,
                'ID: ${rep.id}-${rep.name[0].toUpperCase()}',
                colors,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: colors.textPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, color: Colors.white, size: 20),
                  SizedBox(width: size.width * 0.01),
                  Text(
                    rep.phoneNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, ThemeColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.backgroundMain,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
