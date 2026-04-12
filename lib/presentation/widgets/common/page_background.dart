import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/liquid_glass.dart';

class PageBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;

  const PageBackground({
    super.key,
    required this.child,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // ─── Base Background ───
        Container(color: theme.scaffoldBackgroundColor),

        // ─── Ambient Glows ───
        Positioned(
          top: -100,
          right: -100,
          child: _AmbientGlow(
            color: (gradientColors ?? TeacherAppColors.liquidIndigo).first,
            opacity: isDark ? 0.12 : 0.08,
            size: 400,
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: _AmbientGlow(
            color: (gradientColors ?? TeacherAppColors.liquidIndigo).last,
            opacity: isDark ? 0.1 : 0.05,
            size: 500,
          ),
        ),

        // ─── Content ───
        child,
      ],
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final Color color;
  final double opacity;
  final double size;

  const _AmbientGlow({
    required this.color,
    required this.opacity,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: const SizedBox.expand(),
      ),
    );
  }
}
