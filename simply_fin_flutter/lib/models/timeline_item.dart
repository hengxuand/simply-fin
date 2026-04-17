import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
