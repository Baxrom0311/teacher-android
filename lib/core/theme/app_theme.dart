import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TeacherAppTheme {
  TeacherAppTheme._();

  static const Color _darkBackground = Color(0xFF020617); // Slate 950
  static const Color _darkSurface = Color(0xFF0F172A);    // Slate 900
  static const Color _darkCard = Color(0xFF1E293B);       // Slate 800
  static const Color _darkBorder = Color(0x1A94A3B8);     // Slate 400 (10% Opacity)

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    scaffoldBackgroundColor: TeacherAppColors.background,
    surfaceColor: TeacherAppColors.surface,
    cardColor: TeacherAppColors.surface,
    borderColor: TeacherAppColors.slate200,
    secondaryTextColor: TeacherAppColors.slate500,
    appBarBackgroundColor: TeacherAppColors.surface,
    appBarForegroundColor: TeacherAppColors.slate900,
    shadowColor: Colors.black.withValues(alpha: 0.05),
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBackground,
    surfaceColor: _darkSurface,
    cardColor: _darkCard,
    borderColor: _darkBorder,
    secondaryTextColor: TeacherAppColors.slate400,
    appBarBackgroundColor: _darkSurface,
    appBarForegroundColor: Colors.white,
    shadowColor: Colors.black.withValues(alpha: 0.2),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color cardColor,
    required Color borderColor,
    required Color secondaryTextColor,
    required Color appBarBackgroundColor,
    required Color appBarForegroundColor,
    required Color shadowColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: TeacherAppColors.primaryPurple,
      brightness: brightness,
    ).copyWith(
      primary: TeacherAppColors.primaryPurple,
      secondary: TeacherAppColors.secondaryPurple,
      error: TeacherAppColors.error,
      surface: surfaceColor,
      onSurface: brightness == Brightness.dark ? Colors.white : TeacherAppColors.slate900,
      outline: borderColor,
      outlineVariant: borderColor.withValues(alpha: 1.0),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      shadowColor: shadowColor,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackgroundColor,
        foregroundColor: appBarForegroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: appBarForegroundColor,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark ? _darkCard : TeacherAppColors.slate50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: TeacherAppColors.primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: TeacherAppColors.error),
        ),
        labelStyle: TextStyle(color: secondaryTextColor, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.6)),
        prefixIconColor: secondaryTextColor,
        suffixIconColor: secondaryTextColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: TeacherAppColors.primaryPurple,
        unselectedItemColor: secondaryTextColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.dark ? _darkCard : Colors.white,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1.5),
        headlineMedium: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1.0),
        titleLarge: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        bodyLarge: TextStyle(letterSpacing: 0.1),
      ),
    );
  }
}

