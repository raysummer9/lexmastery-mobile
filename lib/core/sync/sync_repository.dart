import 'dart:convert';

import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';

abstract interface class SyncRepository {
  Future<List<SyncJob>> loadQueue();
  Future<void> saveQueue(List<SyncJob> queue);
}

class LocalSyncRepository implements SyncRepository {
  @override
  Future<List<SyncJob>> loadQueue() async {
    final raw =
        LocalStorageService.readValue<List<dynamic>>(StorageKeys.syncQueue) ??
            const <dynamic>[];
    return raw
        .map((dynamic e) => SyncJob.fromJson(
              jsonDecode(e as String) as Map<dynamic, dynamic>,
            ))
        .toList();
  }

  @override
  Future<void> saveQueue(List<SyncJob> queue) async {
    final serialized =
        queue.map((SyncJob e) => jsonEncode(e.toJson())).toList();
    await LocalStorageService.writeValue(StorageKeys.syncQueue, serialized);
  }
}
