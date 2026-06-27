import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_repository.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_state.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>(
  (ref) => LocalAnalyticsRepository(),
);

final analyticsControllerProvider =
    NotifierProvider<AnalyticsController, AnalyticsState>(
  AnalyticsController.new,
);

class AnalyticsController extends Notifier<AnalyticsState> {
  late final AnalyticsRepository _repository;

  @override
  AnalyticsState build() {
    _repository = ref.read(analyticsRepositoryProvider);
    return const AnalyticsState.initial();
  }

  Future<void> hydrate() async {
    final queued = await _repository.loadQueuedEvents();
    state = state.copyWith(
      status: AnalyticsStatus.collecting,
      pendingEvents: queued,
    );
  }

  Future<void> track(AnalyticsEvent event) async {
    await _repository.enqueue(event);
    final queued = await _repository.loadQueuedEvents();
    state = state.copyWith(
      status: AnalyticsStatus.collecting,
      pendingEvents: queued,
    );
  }

  Future<void> flush() async {
    state = state.copyWith(status: AnalyticsStatus.syncing);
    await _repository.clearQueue();
    state = state.copyWith(
      status: AnalyticsStatus.idle,
      pendingEvents: const <AnalyticsEvent>[],
    );
  }
}
