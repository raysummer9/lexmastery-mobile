import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/features/ai_memory/data/repositories/ai_memory_repository_impl.dart';
import 'package:lexmastery_mobile/features/ai_memory/domain/entities/ai_memory_profile.dart';
import 'package:lexmastery_mobile/features/ai_memory/domain/repositories/ai_memory_repository.dart';
import 'package:lexmastery_mobile/features/ai_memory/presentation/state/ai_memory_state.dart';

final aiMemoryRepositoryProvider = Provider<AiMemoryRepository>(
  (ref) => AiMemoryRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final aiMemoryControllerProvider =
    NotifierProvider<AiMemoryController, AiMemoryState>(
  AiMemoryController.new,
);

class AiMemoryController extends Notifier<AiMemoryState> {
  late final AiMemoryRepository _repository;

  @override
  AiMemoryState build() {
    _repository = ref.read(aiMemoryRepositoryProvider);
    return const AiMemoryState.initial();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(status: AiMemoryStatus.loading);
    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(status: AiMemoryStatus.ready, profile: profile);
    } catch (_) {
      state = state.copyWith(
        status: AiMemoryStatus.failure,
        message: 'Unable to load AI memory profile.',
      );
    }
  }

  Future<void> updateProfile(AiMemoryProfile profile) async {
    state = state.copyWith(status: AiMemoryStatus.syncing);
    final updated = await _repository.updateProfile(profile);
    await ref.read(syncControllerProvider.notifier).enqueue(
          SyncJob(
            id: 'ai-memory-${DateTime.now().microsecondsSinceEpoch}',
            entityType: 'ai_memory',
            payload: updated.toJson(),
            retryCount: 0,
            createdAt: DateTime.now(),
          ),
        );
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'ai_memory_updated',
            occurredAt: DateTime.now(),
          ),
        );
    state = state.copyWith(status: AiMemoryStatus.ready, profile: updated);
  }
}
