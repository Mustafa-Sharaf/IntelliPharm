
import 'package:flutter/material.dart';
class BuildActionButtons extends StatelessWidget {
  const BuildActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1️⃣ الزر الرئيسي: Create Order
        InkWell(
          onTap: () {
            // اضغط هنا لإنشاء طلب جديد
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 56, // ارتفاع ممتاز ومريح للضغط
            decoration: BoxDecoration(
              color: const Color(0xFF00695C), // اللون الأخضر الزيتي الداكن المطابق للصورة
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00695C).withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_shopping_cart, // أيقونة السلة مع إشارة الزائد
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  "Create Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo', // للحفاظ على تناسق الخطوط عندك
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16), // المسافة الفاصلة بين السطرين بناءً على الصورة

        // 2️⃣ السطر السفلي: Map & Call مرتبين بجانب بعضهما بالتساوي
        Row(
          children: [
            // زر الخريطة (Map)
            Expanded(
              child: InkWell(
                onTap: () {
                  // الانتقال إلى الخريطة أو التتبع
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC), // خلفية بيضاء مائلة للرمادي الخفيف جداً
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD1D5DB), // لون الحدود الرمادي الفاتح والناعم
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined, // أيقونة الخريطة المفتوحة المطابقة للصورة
                        color: Color(0xFF0F2547), // اللون الكحلي الداكن للأيقونة والنص
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Map",
                        style: TextStyle(
                          color: Color(0xFF0F2547),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16), // المسافة بين الزرين السفليين

            // زر الاتصال (Call)
            Expanded(
              child: InkWell(
                onTap: () {
                  // فتح خيارات الاتصال بالصيدلاني
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD1D5DB),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_in_talk_outlined, // أيقونة الهاتف المائل المطابقة للصورة
                        color: Color(0xFF0F2547),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Call",
                        style: TextStyle(
                          color: Color(0xFF0F2547),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }}