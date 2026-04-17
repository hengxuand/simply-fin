import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
