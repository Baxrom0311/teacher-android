import 'package:flutter/material.dart';

class TeacherAppColors {
  TeacherAppColors._();

  static const Color slate950 = Color(0xFF020617);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate800 = Color(0xFF1E293B);

  static const Color skyBlue50 = Color(0xFFF0F9FF);
  static const Color skyBlue400 = Color(0xFF38BDF8);
  static const Color skyBlue600 = Color(0xFF0284C7);

  // Kept for compatibility with the existing teacher widgets.
  static const Color primaryPurple = skyBlue600;
  static const Color secondaryPurple = skyBlue400;

  static const Color background = skyBlue50;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);

  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  static const Color present = success;
  static const Color absent = danger;
  static const Color late = warning;
  static const Color excused = Color(0xFF0EA5E9);

  static const Color textPrimary = slate900;
  static const Color textSecondary = slate500;
  static const Color divider = slate200;
  static const Color white = Color(0xFFFFFFFF);
  static const Color glassWhite = Color(0xD9FFFFFF);
  static const Color glassBorder = Color(0x1A0F172A);

  static const Color grade5 = Color(0xFF059669);
  static const Color grade4 = Color(0xFF0EA5E9);
  static const Color grade3 = Color(0xFFD97706);
  static const Color grade2 = Color(0xFFEA580C);
  static const Color grade1 = Color(0xFFDC2626);

  static const List<Color> liquidIndigo = [
    Color(0xFF0EA5E9),
    Color(0xFF38BDF8),
  ];
  static const List<Color> liquidEmerald = [
    Color(0xFF10B981),
    Color(0xFF14B8A6),
  ];
  static const List<Color> liquidRose = [Color(0xFFF43F5E), Color(0xFFEC4899)];
  static const List<Color> liquidAmber = [Color(0xFFF59E0B), Color(0xFFD97706)];
}
