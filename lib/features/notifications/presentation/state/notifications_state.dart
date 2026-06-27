import 'package:lexmastery_mobile/features/notifications/domain/entities/notification_preferences.dart';

enum NotificationsStatus {
  loading,
  ready,
  updating,
  failure,
}

class NotificationsState {
  const NotificationsState({
    required this.status,
    this.preferences,
    this.message,
  });

  const NotificationsState.initial()
      : status = NotificationsStatus.loading,
        preferences = null,
        message = null;

  final NotificationsStatus status;
  final NotificationPreferences? preferences;
  final String? message;

  NotificationsState copyWith({
    NotificationsStatus? status,
    NotificationPreferences? preferences,
    String? message,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      message: message,
    );
  }
}
