import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/notifications/data/contracts/notifications_api_contract.dart';
import 'package:lexmastery_mobile/features/notifications/domain/entities/notification_preferences.dart';
import 'package:lexmastery_mobile/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final UpdateNotificationPreferencesApiContract _contract =
      UpdateNotificationPreferencesApiContract();

  @override
  Future<NotificationPreferences> getPreferences() async {
    final cached = LocalStorageService.readValue<String>(
      StorageKeys.notificationPreferences,
    );
    if (cached != null) {
      return NotificationPreferences.fromJson(
        jsonDecode(cached) as Map<dynamic, dynamic>,
      );
    }
    return NotificationPreferences(
      studyReminders: 'daily',
      examAlerts: 'important_only',
      aiSuggestions: 'balanced',
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  ) async {
    final request = UpdateNotificationPreferencesRequest(
      studyReminders: preferences.studyReminders,
      examAlerts: preferences.examAlerts,
      aiSuggestions: preferences.aiSuggestions,
    );

    NotificationPreferences updated = preferences;
    try {
      final response = await _apiClient.post(
        _contract.path,
        data: _contract.toRequest(request),
      );
      final parsed =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      updated = NotificationPreferences(
        studyReminders: parsed.studyReminders,
        examAlerts: parsed.examAlerts,
        aiSuggestions: parsed.aiSuggestions,
        updatedAt: DateTime.parse(parsed.updatedAtIso),
      );
    } catch (_) {
      updated = NotificationPreferences(
        studyReminders: preferences.studyReminders,
        examAlerts: preferences.examAlerts,
        aiSuggestions: preferences.aiSuggestions,
        updatedAt: DateTime.now(),
      );
    }

    await LocalStorageService.writeValue(
      StorageKeys.notificationPreferences,
      jsonEncode(updated.toJson()),
    );
    return updated;
  }
}
