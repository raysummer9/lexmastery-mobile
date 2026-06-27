import 'dart:convert';

import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';

abstract interface class AnalyticsRepository {
  Future<void> enqueue(AnalyticsEvent event);
  Future<List<AnalyticsEvent>> loadQueuedEvents();
  Future<void> clearQueue();
}

class LocalAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<void> enqueue(AnalyticsEvent event) async {
    final events = await loadQueuedEvents();
    final updated = <AnalyticsEvent>[...events, event];
    final serialized =
        updated.map((AnalyticsEvent e) => jsonEncode(e.toJson())).toList();
    await LocalStorageService.writeValue(
        StorageKeys.analyticsQueue, serialized);
  }

  @override
  Future<List<AnalyticsEvent>> loadQueuedEvents() async {
    final raw = LocalStorageService.readValue<List<dynamic>>(
          StorageKeys.analyticsQueue,
        ) ??
        const <dynamic>[];
    return raw
        .map((dynamic item) => AnalyticsEvent.fromJson(
              jsonDecode(item as String) as Map<dynamic, dynamic>,
            ))
        .toList();
  }

  @override
  Future<void> clearQueue() async {
    await LocalStorageService.deleteValue(StorageKeys.analyticsQueue);
  }
}
