import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lexmastery_mobile/shared/tokens/app_primitives.dart';

@immutable
class AppSpacingTheme extends ThemeExtension<AppSpacingTheme> {
  const AppSpacingTheme({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  factory AppSpacingTheme.defaults() => const AppSpacingTheme(
        xs: AppPrimitives.spaceXs,
        sm: AppPrimitives.spaceSm,
        md: AppPrimitives.spaceMd,
        lg: AppPrimitives.spaceLg,
        xl: AppPrimitives.spaceXl,
        xxl: AppPrimitives.space2xl,
      );

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  @override
  AppSpacingTheme copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacingTheme(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  ThemeExtension<AppSpacingTheme> lerp(
    covariant ThemeExtension<AppSpacingTheme>? other,
    double t,
  ) {
    if (other is! AppSpacingTheme) return this;
    return AppSpacingTheme(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
      xxl: lerpDouble(xxl, other.xxl, t) ?? xxl,
    );
  }
}
