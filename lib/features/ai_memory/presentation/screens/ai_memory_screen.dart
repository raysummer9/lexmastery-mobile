import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/ai_memory/domain/entities/ai_memory_profile.dart';
import 'package:lexmastery_mobile/features/ai_memory/presentation/controllers/ai_memory_controller.dart';
import 'package:lexmastery_mobile/features/ai_memory/presentation/state/ai_memory_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class AiMemoryScreen extends ConsumerStatefulWidget {
  const AiMemoryScreen({super.key});

  @override
  ConsumerState<AiMemoryScreen> createState() => _AiMemoryScreenState();
}

class _AiMemoryScreenState extends ConsumerState<AiMemoryScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(aiMemoryControllerProvider.notifier).loadProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiMemoryControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('AI Memory')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          AiMemoryStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          AiMemoryStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load memory.')),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Weak Topics', style: context.typography.titleLarge),
                SizedBox(height: context.spacing.xs),
                Text(
                  state.profile?.weakTopics.join(', ') ?? '-',
                  style: context.typography.bodyMedium,
                ),
                SizedBox(height: context.spacing.md),
                Text('Mastered Topics', style: context.typography.titleLarge),
                SizedBox(height: context.spacing.xs),
                Text(
                  state.profile?.masteredTopics.join(', ') ?? '-',
                  style: context.typography.bodyMedium,
                ),
                SizedBox(height: context.spacing.lg),
                FilledButton(
                  onPressed: () {
                    final profile = state.profile;
                    if (profile == null) return;
                    ref.read(aiMemoryControllerProvider.notifier).updateProfile(
                          AiMemoryProfile(
                            weakTopics: <String>[
                              ...profile.weakTopics,
                              'privity of contract',
                            ],
                            masteredTopics: profile.masteredTopics,
                            preferences: profile.preferences,
                            updatedAt: DateTime.now(),
                          ),
                        );
                  },
                  child: const Text('Add Weak Topic'),
                ),
              ],
            ),
        },
      ),
    );
  }
}
