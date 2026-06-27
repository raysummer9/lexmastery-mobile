import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/core/feature_flags/feature_flag.dart';
import 'package:lexmastery_mobile/core/feature_flags/feature_flag_repository.dart';
import 'package:lexmastery_mobile/core/feature_flags/feature_flag_state.dart';

final featureFlagRepositoryProvider = Provider<FeatureFlagRepository>(
  (ref) => LocalFeatureFlagRepository(),
);

final featureFlagControllerProvider =
    NotifierProvider<FeatureFlagController, FeatureFlagState>(
  FeatureFlagController.new,
);

class FeatureFlagController extends Notifier<FeatureFlagState> {
  late final FeatureFlagRepository _repository;

  @override
  FeatureFlagState build() {
    _repository = ref.read(featureFlagRepositoryProvider);
    return const FeatureFlagState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(status: FeatureFlagStatus.loading);
    final flags = await _repository.fetchFlags();
    state = state.copyWith(
      status: FeatureFlagStatus.ready,
      flags: flags,
    );
  }

  bool isEnabled(String key) {
    final flag = state.flags.where((FeatureFlag f) => f.key == key);
    if (flag.isEmpty) return false;
    final selected = flag.first;
    return selected.enabled && selected.rolloutPercentage > 0;
  }
}
