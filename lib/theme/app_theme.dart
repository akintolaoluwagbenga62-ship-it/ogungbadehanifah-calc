import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized colors and theme data for the dark, liquid-glass UI.
class AppColors {
  static const Color background = Color(0xFF050505);
  static const Color backgroundSecondary = Color(0xFF0D0D0F);
  static const Color glassBase = Colors.white;

  static const Color accentBlue = Color(0xFF3FB6FF);
  static const Color accentPurple = Color(0xFFB388FF);
  static const Color accentOrange = Color(0xFFFF9F45);
  static const Color accentRed = Color(0xFFFF5C5C);
  static const Color accentGreen = Color(0xFF4ADE80);

  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF8A8A8E);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.accentBlue,
        secondary: AppColors.accentPurple,
        surface: AppColors.backgroundSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
