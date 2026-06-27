import 'dart:convert';

import 'package:lexmastery_mobile/core/feature_flags/feature_flag.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';

abstract interface class FeatureFlagRepository {
  Future<List<FeatureFlag>> fetchFlags();
}

class LocalFeatureFlagRepository implements FeatureFlagRepository {
  @override
  Future<List<FeatureFlag>> fetchFlags() async {
    final cachedRaw = LocalStorageService.readValue<List<dynamic>>(
          StorageKeys.featureFlags,
        ) ??
        const <dynamic>[];
    if (cachedRaw.isNotEmpty) {
      return cachedRaw
          .map((dynamic item) => FeatureFlag.fromJson(
                jsonDecode(item as String) as Map<dynamic, dynamic>,
              ))
          .toList();
    }

    final defaults = <FeatureFlag>[
      const FeatureFlag(
        key: 'ai_tutor_streaming_v1',
        enabled: true,
        rolloutPercentage: 100,
      ),
      const FeatureFlag(
        key: 'experimental_search_semantic_v1',
        enabled: false,
        rolloutPercentage: 0,
      ),
    ];
    await LocalStorageService.writeValue(
      StorageKeys.featureFlags,
      defaults.map((FeatureFlag flag) => jsonEncode(flag.toJson())).toList(),
    );
    return defaults;
  }
}
