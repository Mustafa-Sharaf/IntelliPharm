
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Model
class NavItem {
  final IconData icon;
  final String label;

  const NavItem(this.icon, this.label);
}


List<NavItem> repItems = [
  NavItem(Icons.home_rounded, "HOME".tr),
  NavItem(Icons.receipt_long_rounded, "ORDERS".tr),
  NavItem(Icons.chat, "Ask Gemini".tr),
  NavItem(Icons.account_balance_wallet, "Debts".tr),
  NavItem(Icons.local_pharmacy, "Pharmacies".tr),
];


List<NavItem> distributorItems = [
  const NavItem(Icons.home_rounded, "Home"),
  const NavItem(Icons.local_shipping_rounded, "Deliveries"),
  const NavItem(Icons.map_rounded, "Route"),
  const NavItem(Icons.check_circle_outline_rounded, "Confirm Delivery"),
];