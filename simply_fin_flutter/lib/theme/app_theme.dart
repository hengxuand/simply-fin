import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF113056);
  static const dashboardPrimary = Color(0xFF113056);
  static const aqua = Color(0xFF91CFD5);
  static const teal = Color(0xFF5FAEB6);
  static const amber = Color(0xFFD8B36A);
  static const rose = Color(0xFFCA8A7B);
  static const violet = Color(0xFF7E90BD);

  static const textPrimary = Color(0xFF113056);
  static const authTextPrimary = Color(0xFF113056);
  static const textMuted = Color(0xFF5D7287);
  static const authTextMuted = Color(0xFF71869A);
  static const textHint = Color(0xFFA4B4C0);

  static const surface = Colors.white;
  static const authBackground = Color(0xFFF3F9FA);
  static const dashboardBackground = Color(0xFFF2F8F9);
  static const dashboardBackgroundTop = Color(0xFFE2F1F3);
  static const dashboardBackgroundBottom = Color(0xFFFAFDFC);

  static const heroStart = Color(0xFF113056);
  static const heroMid = Color(0xFF24597A);
  static const heroEnd = Color(0xFF91CFD5);
  static const heroTextMuted = Color(0xFFD9EEF0);

  static const cardTint = Color(0xFFEAF5F6);
  static const cardTintBorder = Color(0xFFCBE2E5);
  static const navIndicator = Color(0xFFD5ECEE);
  static const outlineSoft = Color(0xFFC7E0E4);
  static const outlineSoftAlt = Color(0xFFC3DDE1);
  static const progressTrack = Color(0xFFDDEAEC);
  static const spendRingTrack = Color(0xFFD6E8EB);
  static const timelineLine = Color(0xFFD6E4E8);
  static const timelineCard = Color(0xFFF5FAFA);
  static const recurringCard = Color(0xFFF3F8F9);
  static const recurringIconBg = Color(0xFFDCECEF);
  static const momentumStart = Color(0xFFEAF5F6);
  static const momentumEnd = Color(0xFFDDEFF2);
  static const iconAccent = Color(0xFF67B1BA);
  static const shadow = Color(0x14224358);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.dashboardPrimary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.authBackground,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.authBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  static InputDecoration authInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.authTextMuted, size: 20),
    );
  }
}
