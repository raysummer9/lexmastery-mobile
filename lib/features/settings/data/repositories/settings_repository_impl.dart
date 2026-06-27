import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/settings/data/contracts/settings_api_contract.dart';
import 'package:lexmastery_mobile/features/settings/domain/entities/settings.dart';
import 'package:lexmastery_mobile/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final UpdateSettingsApiContract _contract = UpdateSettingsApiContract();

  @override
  Future<Settings> getSettings() async {
    final cached = LocalStorageService.readValue<String>(StorageKeys.settings);
    if (cached != null) {
      return Settings.fromJson(jsonDecode(cached) as Map<dynamic, dynamic>);
    }
    return Settings(
      themeMode: AppThemeMode.system,
      aiVerbosity: 'balanced',
      analyticsEnabled: true,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Settings> updateSettings(Settings settings) async {
    final request = UpdateSettingsRequest(
      themeMode: settings.themeMode.name,
      aiVerbosity: settings.aiVerbosity,
      analyticsEnabled: settings.analyticsEnabled,
    );

    Settings updated = settings;
    try {
      final response = await _apiClient.post(
        _contract.path,
        data: _contract.toRequest(request),
      );
      final payload =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      updated = Settings(
        themeMode: AppThemeMode.values.byName(payload.themeMode),
        aiVerbosity: payload.aiVerbosity,
        analyticsEnabled: payload.analyticsEnabled,
        updatedAt: DateTime.parse(payload.updatedAtIso),
      );
    } catch (_) {
      updated = Settings(
        themeMode: settings.themeMode,
        aiVerbosity: settings.aiVerbosity,
        analyticsEnabled: settings.analyticsEnabled,
        updatedAt: DateTime.now(),
      );
    }

    await LocalStorageService.writeValue(
      StorageKeys.settings,
      jsonEncode(updated.toJson()),
    );
    return updated;
  }
}
