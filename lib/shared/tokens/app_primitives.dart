import 'package:flutter/material.dart';

@immutable
class AppPrimitives {
  const AppPrimitives._();

  static const Color blue600 = Color(0xFF2246D9);
  static const Color blue700 = Color(0xFF1B37AA);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color success500 = Color(0xFF16A34A);
  static const Color warning500 = Color(0xFFD97706);
  static const Color danger500 = Color(0xFFDC2626);

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double space2xl = 32;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static const Duration motionFast = Duration(milliseconds: 150);
  static const Duration motionNormal = Duration(milliseconds: 250);
  static const Duration motionSlow = Duration(milliseconds: 350);
}
