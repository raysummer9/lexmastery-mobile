import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/core/sync/sync_repository.dart';
import 'package:lexmastery_mobile/core/sync/sync_state.dart';

final syncRepositoryProvider = Provider<SyncRepository>(
  (ref) => LocalSyncRepository(),
);

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(
  SyncController.new,
);

class SyncController extends Notifier<SyncState> {
  late final SyncRepository _repository;

  @override
  SyncState build() {
    _repository = ref.read(syncRepositoryProvider);
    return const SyncState.initial();
  }

  Future<void> hydrate() async {
    final queue = await _repository.loadQueue();
    state = state.copyWith(
      status: queue.isEmpty ? SyncStatus.idle : SyncStatus.queued,
      pendingJobs: queue,
    );
  }

  Future<void> enqueue(SyncJob job) async {
    final updated = <SyncJob>[...state.pendingJobs, job];
    await _repository.saveQueue(updated);
    state = state.copyWith(
      status: SyncStatus.queued,
      pendingJobs: updated,
    );
  }

  Future<void> processQueue() async {
    if (state.pendingJobs.isEmpty) {
      state = state.copyWith(status: SyncStatus.idle);
      return;
    }
    state = state.copyWith(status: SyncStatus.syncing);
    final retriable = <SyncJob>[];
    for (final job in state.pendingJobs) {
      // Placeholder policy for Phase 0. Remote sync is introduced later.
      final shouldRetry = job.retryCount >= 3;
      if (shouldRetry) {
        retriable.add(job);
      }
    }
    await _repository.saveQueue(retriable);
    state = state.copyWith(
      status: retriable.isEmpty ? SyncStatus.idle : SyncStatus.failed,
      pendingJobs: retriable,
    );
  }
}
