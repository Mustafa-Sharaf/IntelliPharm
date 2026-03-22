
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/CustomAppBar.dart';



class ViewOrdersScreen extends StatelessWidget {
  const ViewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "View_Order".tr),

    );
  }
}
