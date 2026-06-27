import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:lexmastery_mobile/features/settings/domain/entities/settings.dart';
import 'package:lexmastery_mobile/features/settings/domain/repositories/settings_repository.dart';
import 'package:lexmastery_mobile/features/settings/presentation/state/settings_state.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(
  SettingsController.new,
);

class SettingsController extends Notifier<SettingsState> {
  late final SettingsRepository _repository;

  @override
  SettingsState build() {
    _repository = ref.read(settingsRepositoryProvider);
    return const SettingsState.initial();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(status: SettingsStatus.loading);
    try {
      final settings = await _repository.getSettings();
      state = state.copyWith(status: SettingsStatus.ready, settings: settings);
    } catch (_) {
      state = state.copyWith(
        status: SettingsStatus.failure,
        message: 'Unable to load settings.',
      );
    }
  }

  Future<void> saveSettings(Settings settings) async {
    state = state.copyWith(status: SettingsStatus.updating);
    try {
      final updated = await _repository.updateSettings(settings);
      state = state.copyWith(status: SettingsStatus.ready, settings: updated);
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'settings_update',
              occurredAt: DateTime.now(),
              payload: <String, dynamic>{
                'themeMode': updated.themeMode.name,
                'aiVerbosity': updated.aiVerbosity,
              },
            ),
          );
    } catch (_) {
      state = state.copyWith(
        status: SettingsStatus.failure,
        message: 'Unable to save settings.',
      );
    }
  }
}
