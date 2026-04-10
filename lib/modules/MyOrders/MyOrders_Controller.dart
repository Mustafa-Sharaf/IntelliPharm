

import 'package:get/get.dart';

class MyOrdersController extends GetxController{
  var selectedTab = 0.obs;

  final tabs = ["All", "Pending", "Confirmed", "Delivered"];

  void changeTab(int index) {
    selectedTab.value = index;
  }

}