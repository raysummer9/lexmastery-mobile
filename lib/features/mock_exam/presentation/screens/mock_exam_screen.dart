import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/mock_exam/domain/entities/mock_exam_question.dart';
import 'package:lexmastery_mobile/features/mock_exam/presentation/controllers/mock_exam_controller.dart';
import 'package:lexmastery_mobile/features/mock_exam/presentation/state/mock_exam_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class MockExamScreen extends ConsumerStatefulWidget {
  const MockExamScreen({super.key});

  @override
  ConsumerState<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends ConsumerState<MockExamScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(mockExamControllerProvider.notifier).startExam(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mockExamControllerProvider);
    final question =
        state.questions.isEmpty ? null : state.questions[state.currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Mock Exam')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          MockExamStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          MockExamStatus.submitted => _MockExamSubmitted(
              state: state,
              onReviewTap: () =>
                  ref.read(mockExamControllerProvider.notifier).reviewExam(),
            ),
          MockExamStatus.reviewing => _MockExamReview(state: state),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Time: ${state.secondsRemaining}s'),
                SizedBox(height: context.spacing.sm),
                if (question != null) ...<Widget>[
                  Text(question.prompt, style: context.typography.titleLarge),
                  SizedBox(height: context.spacing.md),
                  ...question.options.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.spacing.sm),
                      child: OutlinedButton(
                        onPressed: () => ref
                            .read(mockExamControllerProvider.notifier)
                            .answerCurrent(entry.key),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(entry.value),
                        ),
                      ),
                    );
                  }),
                ],
                const Spacer(),
                FilledButton(
                  onPressed: () => ref
                      .read(mockExamControllerProvider.notifier)
                      .submitExam(),
                  child: const Text('Submit Exam'),
                ),
              ],
            ),
        },
      ),
    );
  }
}

class _MockExamSubmitted extends StatelessWidget {
  const _MockExamSubmitted({
    required this.state,
    required this.onReviewTap,
  });

  final MockExamState state;
  final VoidCallback onReviewTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Score: ${state.score}/${state.questions.length}'),
        SizedBox(height: context.spacing.sm),
        Text(state.message ?? ''),
        SizedBox(height: context.spacing.md),
        FilledButton(
          onPressed: onReviewTap,
          child: const Text('Review Answers'),
        ),
      ],
    );
  }
}

class _MockExamReview extends StatelessWidget {
  const _MockExamReview({required this.state});

  final MockExamState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: state.questions.map((MockExamQuestion question) {
        final answer = state.answers[question.id];
        return Card(
          child: ListTile(
            title: Text(question.prompt),
            subtitle: Text(
              'Your answer: ${answer != null ? question.options[answer] : 'None'}\n'
              'Correct: ${question.options[question.correctIndex]}',
            ),
          ),
        );
      }).toList(),
    );
  }
}
