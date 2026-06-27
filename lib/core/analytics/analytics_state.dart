import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';

enum AnalyticsStatus {
  idle,
  collecting,
  syncing,
  failure,
}

class AnalyticsState {
  const AnalyticsState({
    required this.status,
    required this.pendingEvents,
  });

  const AnalyticsState.initial()
      : status = AnalyticsStatus.idle,
        pendingEvents = const <AnalyticsEvent>[];

  final AnalyticsStatus status;
  final List<AnalyticsEvent> pendingEvents;

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    List<AnalyticsEvent>? pendingEvents,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      pendingEvents: pendingEvents ?? this.pendingEvents,
    );
  }
}
