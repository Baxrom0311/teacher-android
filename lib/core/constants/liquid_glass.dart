import 'package:flutter/material.dart';

class LiquidGlass {
  LiquidGlass._();

  static const double blur = 24.0;
  static const double borderOpacity = 0.14;

  static const Duration normal = Duration(milliseconds: 300);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration slow = Duration(milliseconds: 600);

  static double opacity(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.45;

  static List<BoxShadow> get shadows => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
  ];
}
