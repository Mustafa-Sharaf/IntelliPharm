
import 'package:flutter/material.dart';

/// Model
class NavItem {
  final IconData icon;
  final String label;

  const NavItem(this.icon, this.label);
}


List<NavItem> repItems = [
  NavItem(Icons.home_rounded, "HOME"),
  NavItem(Icons.receipt_long_rounded, "ORDERS"),
  NavItem(Icons.smart_toy, "AskAi"),
  NavItem(Icons.account_balance_wallet, "Debts"),
  NavItem(Icons.local_pharmacy, "Pharmacies"),
];


List<NavItem> distributorItems = [
   NavItem(Icons.home_rounded, "HOME"),
   NavItem(Icons.local_shipping_rounded, "DELIVERIES"),
];