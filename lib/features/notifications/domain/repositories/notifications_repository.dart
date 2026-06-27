import 'package:lexmastery_mobile/features/notifications/domain/entities/notification_preferences.dart';

abstract interface class NotificationsRepository {
  Future<NotificationPreferences> getPreferences();
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  );
}
