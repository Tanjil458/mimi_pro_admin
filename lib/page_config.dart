import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/delivery_page.dart';
import 'pages/order_page.dart';
import 'pages/credits_page.dart';
import 'pages/product_list_page.dart';
import 'pages/area_list_page.dart';
import 'pages/customer_list_page.dart';
import 'pages/employee_list_page.dart';

/// Descriptor used to register a "page" in the application.
///
/// Adding a new page simply requires creating the corresponding widget and
/// adding another entry to [pageItems]. No layout duplication is needed.
class PageItem {
  final String title;
  final IconData icon;
  final Widget widget;

  /// Whether this page should appear in the bottom navigation bar.
  ///
  /// Drawer always shows every registered page, but the bottom bar is a
  /// subset. Set to `false` when a screen should only be reachable via the
  /// drawer (e.g. a settings page).
  final bool showInBottomNav;

  const PageItem({
    required this.title,
    required this.icon,
    required this.widget,
    this.showInBottomNav = true,
  });
}

/// Central configuration list for all pages.  The order of the list determines
/// the indexes used by navigation controls (drawer, bottom nav, etc.).
const List<PageItem> pageItems = [
  // ── bottom navigation ──────────────────────────────────────────
  PageItem(title: 'Home', icon: Icons.home, widget: HomePage()),
  PageItem(
    title: 'Delivery',
    icon: Icons.local_shipping,
    widget: DeliveryPage(),
  ),
  PageItem(title: 'Order', icon: Icons.receipt_long, widget: OrderPage()),
  PageItem(title: 'Credits', icon: Icons.star, widget: CreditsPage()),

  // ── drawer only ────────────────────────────────────────────────
  PageItem(
    title: 'Product List',
    icon: Icons.inventory_2,
    widget: ProductListPage(),
    showInBottomNav: false,
  ),
  PageItem(
    title: 'Area List',
    icon: Icons.map,
    widget: AreaListPage(),
    showInBottomNav: false,
  ),
  PageItem(
    title: 'Customer List',
    icon: Icons.people,
    widget: CustomerListPage(),
    showInBottomNav: false,
  ),
  PageItem(
    title: 'Employee List',
    icon: Icons.badge,
    widget: EmployeeListPage(),
    showInBottomNav: false,
  ),
  PageItem(
    title: 'Settings',
    icon: Icons.settings,
    widget: SettingsPage(),
    showInBottomNav: false,
  ),
];
