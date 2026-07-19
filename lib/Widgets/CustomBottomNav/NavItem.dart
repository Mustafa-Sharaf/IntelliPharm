
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
  NavItem(Icons.smart_toy, "AskGemini".tr),
  NavItem(Icons.account_balance_wallet, "Debts".tr),
  NavItem(Icons.local_pharmacy, "Pharmacies".tr),
];


List<NavItem> distributorItems = [
   NavItem(Icons.home_rounded, "Home".tr),
   NavItem(Icons.local_shipping_rounded, "Deliveries".tr),
   NavItem(Icons.map_rounded, "Route".tr),
   NavItem(Icons.check_circle_outline_rounded, "ConfirmDelivery".tr),
];