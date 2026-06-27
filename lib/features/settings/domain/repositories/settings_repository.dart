import 'package:lexmastery_mobile/features/settings/domain/entities/settings.dart';

abstract interface class SettingsRepository {
  Future<Settings> getSettings();
  Future<Settings> updateSettings(Settings settings);
}
