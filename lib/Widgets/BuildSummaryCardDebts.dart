/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/PharmacyDebts/PharmacyDebt_Controller.dart';

class BuildSummaryCardDebts extends StatelessWidget {
  const BuildSummaryCardDebts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PharmacyDebtController>();
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF023E68), Color(0xFF005B60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL OUTSTANDING BALANCE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            '${controller.totalOutstanding} S.p',
            style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.035,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Billed',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    '${controller.totalBilled} S.p',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo'
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Collected',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    '${controller.totalCollected} S.p',
                    style: TextStyle(
                        color: Color(0xFF4EE1C2),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: controller.collectedPercentage,
              minHeight: size.height * 0.01,
              backgroundColor: Colors.white24,
              color: const Color(0xFF4EE1C2),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(controller.collectedPercentage * 100).toInt()}% Collected',
                style: const TextStyle(color: Colors.white70, fontSize: 11,fontFamily: 'Cairo'),
              ),
              Text(
                '${(100 - (controller.collectedPercentage * 100)).toInt()}% Remaining',
                style: const TextStyle(color: Colors.white70, fontSize: 11,fontFamily: 'Cairo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
