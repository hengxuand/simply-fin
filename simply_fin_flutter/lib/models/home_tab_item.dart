import 'package:flutter/material.dart';

class HomeTabItem {
  const HomeTabItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;
}

const homeTabs = [
  HomeTabItem(
    label: 'Overview',
    subtitle: 'Your financial snapshot',
    icon: Icons.home_rounded,
    selectedIcon: Icons.home_filled,
  ),
  HomeTabItem(
    label: 'Insights',
    subtitle: 'Trends and signals',
    icon: Icons.auto_graph_outlined,
    selectedIcon: Icons.auto_graph_rounded,
  ),
  HomeTabItem(
    label: 'Activity',
    subtitle: 'Uploads and processing',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long_rounded,
  ),
  HomeTabItem(
    label: 'Recurring',
    subtitle: 'Subscriptions and bills',
    icon: Icons.repeat_outlined,
    selectedIcon: Icons.repeat_rounded,
  ),
];
