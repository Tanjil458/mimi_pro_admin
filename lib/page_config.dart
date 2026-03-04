import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';

/// Descriptor used to register a "page" in the application.
///
/// Adding a new page simply requires creating the corresponding widget and
/// adding another entry to [pageItems]. No layout duplication is needed.
class PageItem {
  final String title;
  final IconData icon;
  final Widget widget;

  const PageItem({
    required this.title,
    required this.icon,
    required this.widget,
  });
}

/// Central configuration list for all pages.  The order of the list determines
/// the indexes used by navigation controls (drawer, bottom nav, etc.).
const List<PageItem> pageItems = [
  PageItem(
    title: 'Home',
    icon: Icons.home,
    widget: HomePage(),
  ),
  PageItem(
    title: 'Settings',
    icon: Icons.settings,
    widget: SettingsPage(),
  ),
];
