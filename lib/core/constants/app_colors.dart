import 'package:flutter/material.dart';

class TeacherAppColors {
  TeacherAppColors._();

  // ─── Primary (Midnight Navy & Slate) ───
  static const Color slate950 = Color(0xFF020617);    // Deepest Navy
  static const Color slate900 = Color(0xFF0F172A);    // Midnight Navy
  static const Color slate800 = Color(0xFF1E293B);    // Slate Navy
  static const Color primaryPurple = Color(0xFF6366F1); // Indigo 500

  // ─── Background & Surface (Slate) ───
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);

  // ─── Status Colors (Refined) ───
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color danger = Color(0xFFDC2626);  // Red 600
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);    // Blue 600

  // ─── Attendance Status ───
  static const Color present = Color(0xFF059669);
  static const Color absent = Color(0xFFDC2626);
  static const Color late = Color(0xFFD97706);
  static const Color excused = Color(0xFF0EA5E9);

  // ─── Text & Borders ───
  static const Color textPrimary = slate900;
  static const Color textSecondary = slate500;
  static const Color divider = slate200;

  // ─── Grade Colors (Professional) ───
  static const Color grade5 = Color(0xFF059669); // Excellent
  static const Color grade4 = Color(0xFF0EA5E9); // Good
  static const Color grade3 = Color(0xFFD97706); // Satisfactory
  static const Color grade2 = Color(0xFFEA580C); // Poor
  static const Color grade1 = Color(0xFFDC2626); // Failed

  // ─── Liquid Gradients (2025 Premium Tokens) ───
  static const List<Color> liquidIndigo = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
  static const List<Color> liquidEmerald = [Color(0xFF10B981), Color(0xFF14B8A6)];
  static const List<Color> liquidRose = [Color(0xFFF43F5E), Color(0xFFEC4899)];
  static const List<Color> liquidAmber = [Color(0xFFF59E0B), Color(0xFFD97706)];
  
  // Legacy mappings for minimal breaking changes
  static const Color secondaryPurple = Color(0xFF818CF8);
}

