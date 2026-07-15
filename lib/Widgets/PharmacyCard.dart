import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/theme_extension.dart';

class PharmacyCard extends StatelessWidget {
  final String name;
  final String address;
  final String time;
  final VisitStatus status;

  const PharmacyCard({
    super.key,
    required this.name,
    required this.address,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isVisited = status == VisitStatus.visited;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.width * 0.01,
        horizontal: size.height * 0.015,
      ),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            width: size.width * 0.12,
            height: size.width * 0.12,
            decoration: BoxDecoration(
              color: isVisited
                  ? const Color(0xffD7F3EE)
                  : const Color(0xffE9ECEF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isVisited ? Icons.task_alt_rounded : Icons.local_pharmacy,
              color: isVisited
                  ? const Color(0xff0C8A7B)
                  : const Color(0xff002653),
              size: size.width * 0.07,
            ),
          ),
          SizedBox(width: size.width * 0.03),

          ///TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + TIME
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),

                /// ADDRESS
                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: size.height * 0.008),

                /// STATUS
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.width * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: isVisited
                        ? const Color(0xff6FE3D6)
                        : const Color(0xffF3D2B8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isVisited ? "VISITED".tr : "PENDING".tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isVisited
                          ? const Color(0xff0C8A7B)
                          : const Color(0xffA05A2C),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum VisitStatus { pending, visited }
