import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lexmastery_mobile/shared/tokens/app_primitives.dart';

@immutable
class AppRadiusTheme extends ThemeExtension<AppRadiusTheme> {
  const AppRadiusTheme({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  factory AppRadiusTheme.defaults() => const AppRadiusTheme(
        sm: AppPrimitives.radiusSm,
        md: AppPrimitives.radiusMd,
        lg: AppPrimitives.radiusLg,
        xl: AppPrimitives.radiusXl,
      );

  final double sm;
  final double md;
  final double lg;
  final double xl;

  BorderRadius get card => BorderRadius.circular(md);

  @override
  AppRadiusTheme copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return AppRadiusTheme(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  ThemeExtension<AppRadiusTheme> lerp(
    covariant ThemeExtension<AppRadiusTheme>? other,
    double t,
  ) {
    if (other is! AppRadiusTheme) return this;
    return AppRadiusTheme(
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
    );
  }
}
