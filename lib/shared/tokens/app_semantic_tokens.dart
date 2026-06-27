import 'package:flutter/material.dart';
import 'package:lexmastery_mobile/shared/tokens/app_primitives.dart';

@immutable
class AppSemanticColors {
  const AppSemanticColors({
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

  factory AppSemanticColors.light() => const AppSemanticColors(
        backgroundPrimary: AppPrimitives.white,
        surfacePrimary: AppPrimitives.slate100,
        textPrimary: AppPrimitives.slate900,
        textSecondary: AppPrimitives.slate700,
        borderDefault: AppPrimitives.slate200,
        actionPrimary: AppPrimitives.blue600,
        success: AppPrimitives.success500,
        warning: AppPrimitives.warning500,
        error: AppPrimitives.danger500,
      );

  factory AppSemanticColors.dark() => const AppSemanticColors(
        backgroundPrimary: AppPrimitives.slate900,
        surfacePrimary: AppPrimitives.slate700,
        textPrimary: AppPrimitives.white,
        textSecondary: AppPrimitives.slate200,
        borderDefault: AppPrimitives.slate500,
        actionPrimary: AppPrimitives.blue700,
        success: AppPrimitives.success500,
        warning: AppPrimitives.warning500,
        error: AppPrimitives.danger500,
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
}
