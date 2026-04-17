import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/home_models.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.item});

  final InsightItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: item.accent.withAlpha(16),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: item.accent.withAlpha(36)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(190),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: item.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
