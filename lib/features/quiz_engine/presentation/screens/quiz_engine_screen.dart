import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/quiz_engine/domain/entities/quiz_question.dart';
import 'package:lexmastery_mobile/features/quiz_engine/presentation/controllers/quiz_engine_controller.dart';
import 'package:lexmastery_mobile/features/quiz_engine/presentation/state/quiz_engine_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class QuizEngineScreen extends ConsumerStatefulWidget {
  const QuizEngineScreen({super.key});

  @override
  ConsumerState<QuizEngineScreen> createState() => _QuizEngineScreenState();
}

class _QuizEngineScreenState extends ConsumerState<QuizEngineScreen> {
  bool _timedMode = true;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(quizEngineControllerProvider.notifier).startQuiz(
            timedMode: _timedMode,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizEngineControllerProvider);
    final question =
        state.questions.isEmpty ? null : state.questions[state.currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Engine')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          QuizEngineStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          QuizEngineStatus.completed => _CompletedView(
              state: state,
              onReviewTap: () =>
                  ref.read(quizEngineControllerProvider.notifier).openReview(),
            ),
          QuizEngineStatus.reviewing => _ReviewView(state: state),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SwitchListTile(
                        value: _timedMode,
                        onChanged: (value) =>
                            setState(() => _timedMode = value),
                        title: const Text('Timed mode'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (_timedMode)
                      Text(
                        '${state.secondsRemaining}s',
                        style: context.typography.titleLarge,
                      ),
                  ],
                ),
                if (question != null) ...<Widget>[
                  Text(
                    'Question ${state.currentIndex + 1}/${state.questions.length}',
                    style: context.typography.labelMedium,
                  ),
                  SizedBox(height: context.spacing.sm),
                  Text(question.prompt, style: context.typography.titleLarge),
                  SizedBox(height: context.spacing.md),
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.spacing.sm),
                      child: OutlinedButton(
                        onPressed: () => ref
                            .read(quizEngineControllerProvider.notifier)
                            .answerCurrentQuestion(index),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(option),
                        ),
                      ),
                    );
                  }),
                ],
                const Spacer(),
                FilledButton(
                  onPressed: () => ref
                      .read(quizEngineControllerProvider.notifier)
                      .submitQuiz(),
                  child: const Text('Submit Quiz'),
                ),
              ],
            ),
        },
      ),
    );
  }
}

class _CompletedView extends StatelessWidget {
  const _CompletedView({
    required this.state,
    required this.onReviewTap,
  });

  final QuizEngineState state;
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

class _ReviewView extends StatelessWidget {
  const _ReviewView({required this.state});

  final QuizEngineState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: state.questions.map((QuizQuestion question) {
        final answer = state.answers[question.id];
        return Card(
          child: ListTile(
            title: Text(question.prompt),
            subtitle: Text(
              'Your answer: ${answer != null ? question.options[answer] : 'None'}\n'
              'Correct: ${question.options[question.correctIndex]}\n'
              'Explanation: ${question.explanation}',
            ),
          ),
        );
      }).toList(),
    );
  }
}
