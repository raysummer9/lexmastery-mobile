import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lexmastery_mobile/shared/tokens/app_primitives.dart';

@immutable
class AppMotionTheme extends ThemeExtension<AppMotionTheme> {
  const AppMotionTheme({
    required this.fast,
    required this.normal,
    required this.slow,
    required this.standardCurve,
  });

  factory AppMotionTheme.defaults() => const AppMotionTheme(
        fast: AppPrimitives.motionFast,
        normal: AppPrimitives.motionNormal,
        slow: AppPrimitives.motionSlow,
        standardCurve: Curves.easeInOutCubic,
      );

  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Curve standardCurve;

  @override
  AppMotionTheme copyWith({
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Curve? standardCurve,
  }) {
    return AppMotionTheme(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
      standardCurve: standardCurve ?? this.standardCurve,
    );
  }

  @override
  ThemeExtension<AppMotionTheme> lerp(
    covariant ThemeExtension<AppMotionTheme>? other,
    double t,
  ) {
    if (other is! AppMotionTheme) return this;
    return AppMotionTheme(
      fast: Duration(
        milliseconds: lerpDouble(
              fast.inMilliseconds.toDouble(),
              other.fast.inMilliseconds.toDouble(),
              t,
            )?.round() ??
            fast.inMilliseconds,
      ),
      normal: Duration(
        milliseconds: lerpDouble(
              normal.inMilliseconds.toDouble(),
              other.normal.inMilliseconds.toDouble(),
              t,
            )?.round() ??
            normal.inMilliseconds,
      ),
      slow: Duration(
        milliseconds: lerpDouble(
              slow.inMilliseconds.toDouble(),
              other.slow.inMilliseconds.toDouble(),
              t,
            )?.round() ??
            slow.inMilliseconds,
      ),
      standardCurve: t < 0.5 ? standardCurve : other.standardCurve,
    );
  }
}
