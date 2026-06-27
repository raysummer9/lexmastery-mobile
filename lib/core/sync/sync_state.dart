import 'package:lexmastery_mobile/core/sync/sync_job.dart';

enum SyncStatus {
  idle,
  queued,
  syncing,
  failed,
}

class SyncState {
  const SyncState({
    required this.status,
    required this.pendingJobs,
  });

  const SyncState.initial()
      : status = SyncStatus.idle,
        pendingJobs = const <SyncJob>[];

  final SyncStatus status;
  final List<SyncJob> pendingJobs;

  SyncState copyWith({
    SyncStatus? status,
    List<SyncJob>? pendingJobs,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingJobs: pendingJobs ?? this.pendingJobs,
    );
  }
}
