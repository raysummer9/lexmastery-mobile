import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:lexmastery_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:lexmastery_mobile/features/dashboard/presentation/state/dashboard_state.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final dashboardControllerProvider =
    NotifierProvider<DashboardController, DashboardState>(
  DashboardController.new,
);

class DashboardController extends Notifier<DashboardState> {
  late final DashboardRepository _repository;

  @override
  DashboardState build() {
    _repository = ref.read(dashboardRepositoryProvider);
    return const DashboardState.initial();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(status: DashboardStatus.loading);
    try {
      final snapshot = await _repository.getDashboard();
      state =
          state.copyWith(status: DashboardStatus.loaded, snapshot: snapshot);
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'dashboard_view',
              occurredAt: DateTime.now(),
            ),
          );
    } catch (_) {
      state = state.copyWith(
        status: DashboardStatus.failure,
        message: 'Unable to load dashboard.',
      );
    }
  }
}
