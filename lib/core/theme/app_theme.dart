import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TeacherAppTheme {
  TeacherAppTheme._();

  static const Color _darkBackground = Color(0xFF0E1320);
  static const Color _darkSurface = Color(0xFF161D2D);
  static const Color _darkCard = Color(0xFF1D2638);
  static const Color _darkBorder = Color(0xFF2C3750);
  static const Color _darkTextSecondary = Color(0xFF9EABC2);

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    scaffoldBackgroundColor: TeacherAppColors.background,
    surfaceColor: TeacherAppColors.surface,
    cardColor: TeacherAppColors.surface,
    borderColor: TeacherAppColors.divider,
    secondaryTextColor: TeacherAppColors.textSecondary,
    appBarBackgroundColor: TeacherAppColors.surface,
    appBarForegroundColor: TeacherAppColors.textPrimary,
    shadowColor: Colors.black12,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBackground,
    surfaceColor: _darkSurface,
    cardColor: _darkCard,
    borderColor: _darkBorder,
    secondaryTextColor: _darkTextSecondary,
    appBarBackgroundColor: _darkSurface,
    appBarForegroundColor: Colors.white,
    shadowColor: Colors.black45,
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
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: TeacherAppColors.primaryPurple,
          brightness: brightness,
        ).copyWith(
          primary: TeacherAppColors.primaryPurple,
          secondary: TeacherAppColors.secondaryPurple,
          error: TeacherAppColors.error,
          surface: surfaceColor,
          outline: borderColor,
          outlineVariant: borderColor,
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
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: TeacherAppColors.primaryPurple,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TeacherAppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TeacherAppColors.error, width: 2),
        ),
        labelStyle: TextStyle(color: secondaryTextColor),
        hintStyle: TextStyle(color: secondaryTextColor),
        prefixIconColor: secondaryTextColor,
        suffixIconColor: secondaryTextColor,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 1,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.dark ? _darkCard : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
