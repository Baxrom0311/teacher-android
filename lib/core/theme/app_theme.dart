import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TeacherAppTheme {
  TeacherAppTheme._();

  static const Color _darkBackground = TeacherAppColors.slate950;
  static const Color _darkSurface = TeacherAppColors.slate900;
  static const Color _darkCard = TeacherAppColors.slate800;
  static const Color _darkBorder = Color(0x1A94A3B8);

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    scaffoldBackgroundColor: TeacherAppColors.background,
    surfaceColor: TeacherAppColors.surface,
    cardColor: TeacherAppColors.surface,
    borderColor: TeacherAppColors.slate200,
    secondaryTextColor: TeacherAppColors.slate500,
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
    required Color appBarForegroundColor,
    required Color shadowColor,
  }) {
    final isDark = brightness == Brightness.dark;
    final seedAndPrimary = brightness == Brightness.light ? TeacherAppColors.secondaryPurple : TeacherAppColors.primaryPurple;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: seedAndPrimary,
          brightness: brightness,
        ).copyWith(
          primary: seedAndPrimary,
          onPrimary: Colors.white,
          secondary: brightness == Brightness.light ? TeacherAppColors.primaryPurple : TeacherAppColors.secondaryPurple,
          surface: surfaceColor,
          onSurface: isDark ? Colors.white : TeacherAppColors.slate900,
          surfaceContainerHighest: isDark
              ? TeacherAppColors.slate800
              : TeacherAppColors.slate100,
          outline: borderColor,
          error: TeacherAppColors.error,
        );

    final baseTextTheme = isDark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    final textTheme = baseTextTheme.copyWith(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface,
        letterSpacing: -1.0,
        fontFamily: 'Inter',
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        letterSpacing: -0.8,
        fontFamily: 'Inter',
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 18,
        color: colorScheme.onSurface,
        letterSpacing: -0.5,
        fontFamily: 'Inter',
      ),
      bodyLarge: TextStyle(
        color: isDark ? TeacherAppColors.slate200 : TeacherAppColors.slate700,
        fontSize: 16,
        height: 1.5,
        fontFamily: 'Inter',
      ),
      bodyMedium: TextStyle(
        color: isDark ? TeacherAppColors.slate400 : TeacherAppColors.slate600,
        fontSize: 14,
        height: 1.5,
        fontFamily: 'Inter',
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      shadowColor: shadowColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: appBarForegroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: borderColor.withValues(alpha: 0.5), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? _darkCard : TeacherAppColors.slate100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: TeacherAppColors.error),
        ),
        labelStyle: TextStyle(
          color: secondaryTextColor,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.6)),
        prefixIconColor: secondaryTextColor,
        suffixIconColor: secondaryTextColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: secondaryTextColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? _darkCard : Colors.white,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
