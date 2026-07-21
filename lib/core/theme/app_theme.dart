import 'package:flutter/material.dart';

class AppColors {
  static const Color deepNavy = Color(0xFF0B1F3A);
  static const Color navy = Color(0xFF143A66);
  static const Color blue = Color(0xFF1F6FEB);
  static const Color teal = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFF14B8A6);
  static const Color surface = Color(0xFFF5F7FB);
  static const Color surfaceAlt = Color(0xFFEEF2F7);
  static const Color card = Color(0xFFFFFFFF);
  static const Color warning = Color(0xFFEAB308);
  static const Color danger = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color border = Color(0xFFD8E0EC);

  static const Color lessonAccent = Color(0xFF1F6FEB);
  static const Color formulaAccent = Color(0xFF0D9488);
  static const Color questionAccent = Color(0xFF7C3AED);
  static const Color practicalAccent = Color(0xFFB45309);
}

class AppTheme {
  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.light,
      primary: AppColors.navy,
      secondary: AppColors.teal,
      surface: AppColors.surface,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Noto Sans KR',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.deepNavy,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Color(0xFF94A3B8)),
        selectedLabelTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(color: Color(0xFF94A3B8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.deepNavy,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.deepNavy,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.35,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.65,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.tealLight,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0B1220),
    );
  }
}
