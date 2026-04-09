import 'package:flutter/material.dart';

/// 🔥 Model بسيط للعناصر
class NavItem {
  final IconData icon;
  final String label;

  const NavItem(this.icon, this.label);
}

/// 🔥 العناصر
const List<NavItem> items = [
  NavItem(Icons.home_rounded, "HOME"),
  NavItem(Icons.shopping_cart_rounded, "ORDERS"),
  NavItem(Icons.route_rounded, "ROUTE"),
  NavItem(Icons.sticky_note_2_rounded, "NOTES"),
  NavItem(Icons.person_rounded, "PROFILE"),
];
