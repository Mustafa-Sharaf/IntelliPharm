import 'package:flutter/material.dart';
import '../../Widgets/PlanRouteCard.dart';
import '../../Widgets/StatCard.dart';

//New code
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        PlanRouteCard(),
        Row(
          children: [
            StatCard(
              icon: Icons.verified_rounded,
              value: "33",
              title: "Visits",
            ),
            StatCard(
              icon: Icons.handshake_rounded,
              value: "20",
              title: "Deals",
            ),
            StatCard(
              icon: Icons.receipt_long_rounded,
              value: "15",
              title: "Order",
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Visits",
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Color(0xff016E65),
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
