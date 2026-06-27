import 'package:flutter/material.dart';

@immutable
class AppTypographyTheme extends ThemeExtension<AppTypographyTheme> {
  const AppTypographyTheme({
    required this.displayLarge,
    required this.headlineMedium,
    required this.titleLarge,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.labelMedium,
    required this.captionSmall,
  });

  factory AppTypographyTheme.fromScheme({
    required Color primaryText,
    required Color secondaryText,
  }) {
    return AppTypographyTheme(
      displayLarge: TextStyle(
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: primaryText,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      captionSmall: TextStyle(
        fontSize: 11,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
    );
  }

  final TextStyle displayLarge;
  final TextStyle headlineMedium;
  final TextStyle titleLarge;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle labelMedium;
  final TextStyle captionSmall;

  @override
  AppTypographyTheme copyWith({
    TextStyle? displayLarge,
    TextStyle? headlineMedium,
    TextStyle? titleLarge,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? labelMedium,
    TextStyle? captionSmall,
  }) {
    return AppTypographyTheme(
      displayLarge: displayLarge ?? this.displayLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      titleLarge: titleLarge ?? this.titleLarge,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      labelMedium: labelMedium ?? this.labelMedium,
      captionSmall: captionSmall ?? this.captionSmall,
    );
  }

  @override
  ThemeExtension<AppTypographyTheme> lerp(
    covariant ThemeExtension<AppTypographyTheme>? other,
    double t,
  ) {
    if (other is! AppTypographyTheme) return this;
    return AppTypographyTheme(
      displayLarge:
          TextStyle.lerp(displayLarge, other.displayLarge, t) ?? displayLarge,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t) ??
          headlineMedium,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t) ?? titleLarge,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t) ?? bodyLarge,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t) ?? bodyMedium,
      labelMedium:
          TextStyle.lerp(labelMedium, other.labelMedium, t) ?? labelMedium,
      captionSmall:
          TextStyle.lerp(captionSmall, other.captionSmall, t) ?? captionSmall,
    );
  }
}
