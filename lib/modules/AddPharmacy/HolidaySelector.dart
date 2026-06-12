
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HolidaySelector extends StatelessWidget {
  final dynamic controller;

  const HolidaySelector({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reachedLimit =
          controller.holidays.length >= controller.maxHolidays.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: controller.shake.value
            ? (Matrix4.translationValues(10, 0, 0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Counter
            Text(
              "${controller.holidays.length}/${controller.maxHolidays.value} selected",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontFamily: 'Cairo',
              ),
            ),

            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.weekdays.map<Widget>((day) {
                  final key = day["key"];
                  final isSelected =
                  controller.holidays.contains(key);

                  final isDisabled =
                      !isSelected && reachedLimit;

                  return GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () => controller.toggleHoliday(key!),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isDisabled ? 0.3 : 1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xff016E65)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          day["ar"]!,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}