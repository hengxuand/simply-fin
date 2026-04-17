import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DashboardPanel extends StatelessWidget {
  const DashboardPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(230),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 1.3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}
