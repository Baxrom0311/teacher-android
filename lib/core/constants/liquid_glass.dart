import 'package:flutter/material.dart';

/// 2025 Premium Design Tokens for Liquid Glass UI
class LiquidGlass {
  LiquidGlass._();

  // ─── Glassmorphism Constants ───
  static const double blur = 20.0;
  static const double opacity = 0.08;
  static const double borderOpacity = 0.12;
  static const double shadowOpacity = 0.05;

  // ─── Animation Timings ───
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration slow = Duration(milliseconds: 600);

  // ─── Surface Decoration ───
  static BoxDecoration glass({
    required Color color,
    double borderRadius = 24,
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder
          ? Border.all(color: color.withValues(alpha: borderOpacity), width: 1.5)
          : null,
    );
  }

  static List<BoxShadow> get shadows => [
        BoxShadow(
          color: Colors.black.withValues(alpha: shadowOpacity),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];
}
