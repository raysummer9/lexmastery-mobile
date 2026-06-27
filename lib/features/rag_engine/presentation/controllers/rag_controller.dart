import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/rag_engine/data/repositories/rag_repository_impl.dart';
import 'package:lexmastery_mobile/features/rag_engine/domain/entities/rag_chunk.dart';
import 'package:lexmastery_mobile/features/rag_engine/domain/repositories/rag_repository.dart';
import 'package:lexmastery_mobile/features/rag_engine/presentation/state/rag_state.dart';

final ragRepositoryProvider = Provider<RagRepository>(
  (ref) => RagRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final ragControllerProvider = NotifierProvider<RagController, RagState>(
  RagController.new,
);

class RagController extends Notifier<RagState> {
  late final RagRepository _repository;

  @override
  RagState build() {
    _repository = ref.read(ragRepositoryProvider);
    return const RagState.initial();
  }

  Future<List<RagChunk>> retrieve(String query) async {
    state = state.copyWith(status: RagStatus.loading);
    try {
      final chunks = await _repository.retrieveChunks(query);
      state = state.copyWith(status: RagStatus.retrieved, chunks: chunks);
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'rag_query',
              occurredAt: DateTime.now(),
              payload: <String, dynamic>{
                'query': query,
                'count': chunks.length
              },
            ),
          );
      return chunks;
    } catch (_) {
      state = state.copyWith(
        status: RagStatus.failure,
        message: 'Unable to retrieve grounded context.',
      );
      return const <RagChunk>[];
    }
  }
}
