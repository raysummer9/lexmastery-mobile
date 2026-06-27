import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/lesson_player/presentation/controllers/lesson_player_controller.dart';
import 'package:lexmastery_mobile/features/lesson_player/presentation/state/lesson_player_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class LessonPlayerScreen extends ConsumerStatefulWidget {
  const LessonPlayerScreen({
    required this.lessonId,
    super.key,
  });

  final String lessonId;

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(lessonPlayerControllerProvider.notifier).loadLesson(
            widget.lessonId,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonPlayerControllerProvider);
    final progress = state.lessonProgress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Player'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Ask AI Tutor',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI Tutor entry point stubbed for Phase 3.'),
                ),
              );
            },
            icon: const Icon(Icons.smart_toy_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          LessonPlayerStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          LessonPlayerStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load lesson.')),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  state.lessonContent?.title ?? '-',
                  style: context.typography.headlineMedium,
                ),
                SizedBox(height: context.spacing.xs),
                Text(
                  'Progress: ${progress?.progressPercent ?? 0}%',
                  style: context.typography.bodyMedium,
                ),
                SizedBox(height: context.spacing.md),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.lessonContent?.paragraphs.length ?? 0,
                    itemBuilder: (context, index) {
                      final paragraph = state.lessonContent!.paragraphs[index];
                      return Card(
                        child: ListTile(
                          title: Text(paragraph),
                          subtitle: Text('Paragraph ${index + 1}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () => ref
                                .read(lessonPlayerControllerProvider.notifier)
                                .markParagraphRead(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
