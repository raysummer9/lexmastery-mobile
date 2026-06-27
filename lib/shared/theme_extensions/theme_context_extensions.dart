import 'package:flutter/material.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_color_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_motion_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_radius_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_spacing_theme.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/app_typography_theme.dart';

extension ThemeContextExtensions on BuildContext {
  AppColorTheme get colors => Theme.of(this).extension<AppColorTheme>()!;
  AppTypographyTheme get typography =>
      Theme.of(this).extension<AppTypographyTheme>()!;
  AppSpacingTheme get spacing => Theme.of(this).extension<AppSpacingTheme>()!;
  AppRadiusTheme get radius => Theme.of(this).extension<AppRadiusTheme>()!;
  AppMotionTheme get motion => Theme.of(this).extension<AppMotionTheme>()!;
}
