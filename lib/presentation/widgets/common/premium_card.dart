import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/liquid_glass.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool useGlass;
  final Color? color;
  final List<BoxShadow>? shadows;
  final Border? border;

  const PremiumCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 24,
    this.useGlass = false,
    this.color,
    this.shadows,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardColor;

    if (useGlass) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadows ?? LiquidGlass.shadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: LiquidGlass.blur,
              sigmaY: LiquidGlass.blur,
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: LiquidGlass.opacity),
                borderRadius: BorderRadius.circular(borderRadius),
                border: border ??
                    Border.all(
                      color: cardColor.withValues(
                        alpha: LiquidGlass.borderOpacity,
                      ),
                      width: 1.5,
                    ),
              ),
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
        boxShadow: shadows ?? LiquidGlass.shadows,
      ),
      child: child,
    );
  }
}
