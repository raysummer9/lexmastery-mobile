import 'package:flutter/material.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_color_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_motion_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_radius_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_spacing_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_typography_theme.dart';
import 'package:lexmastery_mobile/shared/tokens/app_semantic_tokens.dart';

@immutable
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final semantic = AppSemanticColors.light();
    final colorTheme = AppColorTheme.fromSemantic(semantic);
    final typographyTheme = AppTypographyTheme.fromScheme(
      primaryText: semantic.textPrimary,
      secondaryText: semantic.textSecondary,
    );
    return _buildThemeData(
      brightness: Brightness.light,
      colorTheme: colorTheme,
      typographyTheme: typographyTheme,
    );
  }

  static ThemeData dark() {
    final semantic = AppSemanticColors.dark();
    final colorTheme = AppColorTheme.fromSemantic(semantic);
    final typographyTheme = AppTypographyTheme.fromScheme(
      primaryText: semantic.textPrimary,
      secondaryText: semantic.textSecondary,
    );
    return _buildThemeData(
      brightness: Brightness.dark,
      colorTheme: colorTheme,
      typographyTheme: typographyTheme,
    );
  }

  static ThemeData _buildThemeData({
    required Brightness brightness,
    required AppColorTheme colorTheme,
    required AppTypographyTheme typographyTheme,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colorTheme.actionPrimary,
      brightness: brightness,
      primary: colorTheme.actionPrimary,
      error: colorTheme.error,
      surface: colorTheme.surfacePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorTheme.backgroundPrimary,
      textTheme: TextTheme(
        displayLarge: typographyTheme.displayLarge,
        headlineMedium: typographyTheme.headlineMedium,
        titleLarge: typographyTheme.titleLarge,
        bodyLarge: typographyTheme.bodyLarge,
        bodyMedium: typographyTheme.bodyMedium,
        labelMedium: typographyTheme.labelMedium,
      ),
      extensions: <ThemeExtension<dynamic>>[
        colorTheme,
        typographyTheme,
        AppSpacingTheme.defaults(),
        AppRadiusTheme.defaults(),
        AppMotionTheme.defaults(),
      ],
    );
  }
}
