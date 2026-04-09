
import 'package:flutter/material.dart';

/// Model
class NavItem {
  final IconData icon;
  final String label;

  const NavItem(this.icon, this.label);
}

/// Items
const List<NavItem> items = [
  NavItem(Icons.home_rounded, "HOME"),
  NavItem(Icons.receipt_long_rounded, "ORDERS"),
  NavItem(Icons.route_rounded, "ROUTE"),
  NavItem(Icons.account_balance_wallet, "Debts"),
  NavItem(Icons.local_pharmacy, "Pharmacies"),
];
