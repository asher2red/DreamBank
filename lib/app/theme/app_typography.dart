import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const textTheme = TextTheme(
    displaySmall: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.45,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.textPrimary,
      height: 1.65,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppColors.textSecondary,
      height: 1.6,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
  );
}
