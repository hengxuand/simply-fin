import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

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

class CategorySpend {
  const CategorySpend({
    required this.category,
    required this.amount,
    required this.progress,
    required this.color,
  });

  final String category;
  final String amount;
  final double progress;
  final Color color;
}

class TimelineItem {
  const TimelineItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String time;
  final Color color;
}

class RecurringCharge {
  const RecurringCharge({
    required this.name,
    required this.amount,
    required this.due,
  });

  final String name;
  final String amount;
  final String due;
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

const categorySpendItems = [
  CategorySpend(
    category: 'Housing & bills',
    amount: '\$1,840',
    progress: 0.82,
    color: AppColors.dashboardPrimary,
  ),
  CategorySpend(
    category: 'Groceries',
    amount: '\$620',
    progress: 0.48,
    color: AppColors.teal,
  ),
  CategorySpend(
    category: 'Dining & coffee',
    amount: '\$540',
    progress: 0.42,
    color: AppColors.rose,
  ),
  CategorySpend(
    category: 'Transport',
    amount: '\$316',
    progress: 0.27,
    color: AppColors.amber,
  ),
  CategorySpend(
    category: 'Shopping',
    amount: '\$295',
    progress: 0.24,
    color: AppColors.violet,
  ),
];

const timelineItems = [
  TimelineItem(
    title: 'Upload received',
    subtitle: 'Chase Sapphire statement imported',
    time: '2 min ago',
    color: AppColors.dashboardPrimary,
  ),
  TimelineItem(
    title: 'Merchant cleanup',
    subtitle: 'Normalized 14 merchant names',
    time: '1 min ago',
    color: AppColors.teal,
  ),
  TimelineItem(
    title: 'Insight generation',
    subtitle: '4 spending flags and 2 savings ideas created',
    time: 'Just now',
    color: AppColors.amber,
  ),
];

const recurringCharges = [
  RecurringCharge(name: 'Netflix', amount: '\$15.49', due: 'Apr 18'),
  RecurringCharge(name: 'Spotify', amount: '\$10.99', due: 'Apr 21'),
  RecurringCharge(name: 'Adobe Creative Cloud', amount: '\$54.99', due: 'Apr 24'),
  RecurringCharge(name: 'Gym membership', amount: '\$64.00', due: 'Apr 27'),
];
