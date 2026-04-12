import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PageBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;

  const PageBackground({super.key, required this.child, this.gradientColors});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.3, 0.7, 1.0],
          colors: isDark
              ? [
                  TeacherAppColors.slate900,
                  TeacherAppColors.slate950,
                  TeacherAppColors.slate900.withValues(alpha: 0.8),
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                ]
              : [
                  TeacherAppColors.skyBlue50,
                  TeacherAppColors.white,
                  TeacherAppColors.slate50,
                  TeacherAppColors.slate100.withValues(alpha: 0.3),
                ],
        ),
      ),
      child: Stack(
        children: [
          if (isDark) ...[
            Positioned(
              top: -150,
              right: -100,
              child: _AmbientGlow(
                color: (gradientColors ?? TeacherAppColors.liquidIndigo).first,
                opacity: 0.08,
                size: 400,
              ),
            ),
            Positioned(
              bottom: -200,
              left: -150,
              child: _AmbientGlow(
                color: (gradientColors ?? TeacherAppColors.liquidEmerald).last,
                opacity: 0.03,
                size: 500,
              ),
            ),
          ],
          child,
        ],
      ),
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
        filter: ImageFilter.blur(sigmaX: 72, sigmaY: 72),
        child: const SizedBox.expand(),
      ),
    );
  }
}
