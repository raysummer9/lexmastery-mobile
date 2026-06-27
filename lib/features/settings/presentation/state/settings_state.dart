import 'package:lexmastery_mobile/features/settings/domain/entities/settings.dart';

enum SettingsStatus {
  loading,
  ready,
  updating,
  failure,
}

class SettingsState {
  const SettingsState({
    required this.status,
    this.settings,
    this.message,
  });

  const SettingsState.initial()
      : status = SettingsStatus.loading,
        settings = null,
        message = null;

  final SettingsStatus status;
  final Settings? settings;
  final String? message;

  SettingsState copyWith({
    SettingsStatus? status,
    Settings? settings,
    String? message,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      message: message,
    );
  }
}
