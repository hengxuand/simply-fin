import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/home_models.dart';

class CategorySpendTile extends StatelessWidget {
  const CategorySpendTile({super.key, required this.item});

  final CategorySpend item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                item.amount,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 10,
              backgroundColor: AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(item.color),
            ),
          ),
        ],
      ),
    );
  }
}
