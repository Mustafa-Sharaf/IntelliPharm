import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RegionController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final List<String> regions = [
    "الميدان",
    "الشاغور",
    "ركن الدين",
    "المزة",
    "كفرسوسة",
    "دمر",
    "برزة",
    "القابون",
    "جوبر",
    "ساروجة",
    "الصالحية",
    "المهاجرين",
    "القنوات",
    "القدم",
    "اليرموك",
    "أبو رمانة",
    "المالكي",
    "الشعلان",
    "البرامكة",
    "القصاع",
    "باب توما",
    "جرمانا",
    "صحنايا",
    "داريا",
    "قدسيا",
    "التل",
    "دوما",
    "حرستا",
    "سقبا",
    "كفربطنا",
    "عين ترما",
    "زملكا",
    "المليحة",
  ];

  var filteredRegions = <String>[].obs;

  @override
  void onInit() {
    filteredRegions.value = regions;
    super.onInit();
  }

  void filter(String value) {
    if (value.isEmpty) {
      filteredRegions.value = regions;
    } else {
      filteredRegions.value = regions
          .where((region) =>
          region.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }

  void selectRegion(String region) {
    print("Selected: $region");
    Get.back();
  }
}