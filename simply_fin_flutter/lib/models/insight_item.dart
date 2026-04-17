import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class InsightItem {
  const InsightItem({
    required this.title,
    required this.body,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String body;
  final Color accent;
  final IconData icon;
}

const insightItems = [
  InsightItem(
    title: 'Dining spend jumped on weekends',
    body:
        'Saturday and Sunday restaurant purchases are 34% higher than your weekday average. Setting a weekend cap could save about \$180 next month.',
    accent: AppColors.rose,
    icon: Icons.restaurant_rounded,
  ),
  InsightItem(
    title: 'Travel category cooled off',
    body:
        'Your travel spend dropped sharply after March, which improved your estimated monthly savings runway from 22 to 29 days.',
    accent: AppColors.teal,
    icon: Icons.flight_takeoff_rounded,
  ),
  InsightItem(
    title: 'One charge looks unusual',
    body:
        'The \$312 electronics purchase is 4.8x larger than your typical discretionary transaction. Future anomaly detection can flag this automatically.',
    accent: AppColors.amber,
    icon: Icons.error_outline_rounded,
  ),
];
