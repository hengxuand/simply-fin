import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SpendRing extends StatelessWidget {
  const SpendRing({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 190,
        height: 190,
        child: Stack(
          alignment: Alignment.center,
          children: const [
            SizedBox(
              width: 190,
              height: 190,
              child: CircularProgressIndicator(
                value: 0.82,
                strokeWidth: 16,
                backgroundColor: AppColors.spendRingTrack,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.dashboardPrimary,
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: 0.48,
                strokeWidth: 16,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
              ),
            ),
            SizedBox(
              width: 110,
              height: 110,
              child: CircularProgressIndicator(
                value: 0.42,
                strokeWidth: 16,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.rose),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$4.8k',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'tracked spend',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
