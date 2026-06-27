import 'package:flutter/material.dart';
import 'package:lexmastery_mobile/shared/tokens/app_semantic_tokens.dart';

@immutable
class AppColorTheme extends ThemeExtension<AppColorTheme> {
  const AppColorTheme({
    required this.backgroundPrimary,
    required this.surfacePrimary,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderDefault,
    required this.actionPrimary,
    required this.success,
    required this.warning,
    required this.error,
  });

  factory AppColorTheme.fromSemantic(AppSemanticColors colors) => AppColorTheme(
        backgroundPrimary: colors.backgroundPrimary,
        surfacePrimary: colors.surfacePrimary,
        textPrimary: colors.textPrimary,
        textSecondary: colors.textSecondary,
        borderDefault: colors.borderDefault,
        actionPrimary: colors.actionPrimary,
        success: colors.success,
        warning: colors.warning,
        error: colors.error,
      );

  final Color backgroundPrimary;
  final Color surfacePrimary;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderDefault;
  final Color actionPrimary;
  final Color success;
  final Color warning;
  final Color error;

  @override
  AppColorTheme copyWith({
    Color? backgroundPrimary,
    Color? surfacePrimary,
    Color? textPrimary,
    Color? textSecondary,
    Color? borderDefault,
    Color? actionPrimary,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return AppColorTheme(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      borderDefault: borderDefault ?? this.borderDefault,
      actionPrimary: actionPrimary ?? this.actionPrimary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  ThemeExtension<AppColorTheme> lerp(
    covariant ThemeExtension<AppColorTheme>? other,
    double t,
  ) {
    if (other is! AppColorTheme) return this;
    return AppColorTheme(
      backgroundPrimary:
          Color.lerp(backgroundPrimary, other.backgroundPrimary, t) ??
              backgroundPrimary,
      surfacePrimary:
          Color.lerp(surfacePrimary, other.surfacePrimary, t) ?? surfacePrimary,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      borderDefault:
          Color.lerp(borderDefault, other.borderDefault, t) ?? borderDefault,
      actionPrimary:
          Color.lerp(actionPrimary, other.actionPrimary, t) ?? actionPrimary,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      error: Color.lerp(error, other.error, t) ?? error,
    );
  }
}
