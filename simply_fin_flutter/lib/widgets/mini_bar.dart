import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MiniBar extends StatelessWidget {
  const MiniBar({
    super.key,
    required this.height,
    required this.color,
    required this.label,
  });

  final double height;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
