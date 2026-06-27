import 'package:lexmastery_mobile/core/feature_flags/feature_flag.dart';

enum FeatureFlagStatus {
  loading,
  ready,
  failure,
}

class FeatureFlagState {
  const FeatureFlagState({
    required this.status,
    required this.flags,
  });

  const FeatureFlagState.initial()
      : status = FeatureFlagStatus.loading,
        flags = const <FeatureFlag>[];

  final FeatureFlagStatus status;
  final List<FeatureFlag> flags;

  FeatureFlagState copyWith({
    FeatureFlagStatus? status,
    List<FeatureFlag>? flags,
  }) {
    return FeatureFlagState(
      status: status ?? this.status,
      flags: flags ?? this.flags,
    );
  }
}
