import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF4F6AFF);
  static const dashboardPrimary = Color(0xFF315EFB);
  static const teal = Color(0xFF1FB7A6);
  static const amber = Color(0xFFFFB547);
  static const rose = Color(0xFFFF6F91);
  static const violet = Color(0xFF8A7CFF);

  static const textPrimary = Color(0xFF10233F);
  static const authTextPrimary = Color(0xFF1A1F36);
  static const textMuted = Color(0xFF6C7A92);
  static const authTextMuted = Color(0xFF8A94A6);
  static const textHint = Color(0xFFBCC2CC);

  static const surface = Colors.white;
  static const authBackground = Color(0xFFF5F7FA);
  static const dashboardBackground = Color(0xFFF4F7FB);
  static const dashboardBackgroundTop = Color(0xFFE8EEFF);
  static const dashboardBackgroundBottom = Color(0xFFF9FBFD);

  static const heroStart = Color(0xFF0F1F4D);
  static const heroEnd = Color(0xFF6B86FF);
  static const heroTextMuted = Color(0xFFDCE5FF);

  static const cardTint = Color(0xFFF6F8FF);
  static const cardTintBorder = Color(0xFFD9E2FF);
  static const navIndicator = Color(0xFFDCE5FF);
  static const outlineSoft = Color(0xFFD4DEFF);
  static const outlineSoftAlt = Color(0xFFD5DEFF);
  static const progressTrack = Color(0xFFE8EDF7);
  static const spendRingTrack = Color(0xFFE7EDFF);
  static const timelineLine = Color(0xFFE3E8F6);
  static const timelineCard = Color(0xFFF8FAFD);
  static const recurringCard = Color(0xFFF7F9FC);
  static const recurringIconBg = Color(0xFFE2E9FF);
  static const momentumStart = Color(0xFFF6F8FF);
  static const momentumEnd = Color(0xFFE9F5FF);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
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
