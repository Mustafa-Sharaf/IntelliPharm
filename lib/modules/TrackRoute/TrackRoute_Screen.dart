
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/CustomAppBar.dart';


class TrackRouteScreen extends StatelessWidget {
  const TrackRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Track_Route".tr),
    );
  }
}
