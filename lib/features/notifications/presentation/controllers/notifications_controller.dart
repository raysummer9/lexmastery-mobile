import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:lexmastery_mobile/features/notifications/domain/entities/notification_preferences.dart';
import 'package:lexmastery_mobile/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:lexmastery_mobile/features/notifications/presentation/state/notifications_state.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final notificationsControllerProvider =
    NotifierProvider<NotificationsController, NotificationsState>(
  NotificationsController.new,
);

class NotificationsController extends Notifier<NotificationsState> {
  late final NotificationsRepository _repository;

  @override
  NotificationsState build() {
    _repository = ref.read(notificationsRepositoryProvider);
    return const NotificationsState.initial();
  }

  Future<void> loadPreferences() async {
    state = state.copyWith(status: NotificationsStatus.loading);
    try {
      final preferences = await _repository.getPreferences();
      state = state.copyWith(
        status: NotificationsStatus.ready,
        preferences: preferences,
      );
    } catch (_) {
      state = state.copyWith(
        status: NotificationsStatus.failure,
        message: 'Unable to load notification preferences.',
      );
    }
  }

  Future<void> savePreferences(NotificationPreferences preferences) async {
    state = state.copyWith(status: NotificationsStatus.updating);
    try {
      final updated = await _repository.updatePreferences(preferences);
      state = state.copyWith(
        status: NotificationsStatus.ready,
        preferences: updated,
      );
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'notifications_preferences_update',
              occurredAt: DateTime.now(),
              payload: <String, dynamic>{
                'studyReminders': updated.studyReminders,
                'examAlerts': updated.examAlerts,
              },
            ),
          );
    } catch (_) {
      state = state.copyWith(
        status: NotificationsStatus.failure,
        message: 'Unable to save notification preferences.',
      );
    }
  }
}
