import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/ai_tutor/domain/entities/ai_tutor_message.dart';
import 'package:lexmastery_mobile/features/ai_tutor/presentation/controllers/ai_tutor_controller.dart';
import 'package:lexmastery_mobile/features/ai_tutor/presentation/state/ai_tutor_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class AiTutorScreen extends ConsumerStatefulWidget {
  const AiTutorScreen({super.key});

  @override
  ConsumerState<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends ConsumerState<AiTutorScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiTutorControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('AI Tutor')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: state.mode,
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(
                    value: 'explanation', child: Text('explanation')),
                DropdownMenuItem(value: 'exam', child: Text('exam')),
                DropdownMenuItem(value: 'practice', child: Text('practice')),
                DropdownMenuItem(value: 'socratic', child: Text('socratic')),
              ],
              onChanged: (String? mode) {
                if (mode != null) {
                  ref.read(aiTutorControllerProvider.notifier).setMode(mode);
                }
              },
              decoration: const InputDecoration(labelText: 'Tutor mode'),
            ),
            SizedBox(height: context.spacing.md),
            if (state.status == AiTutorStatus.loading ||
                state.status == AiTutorStatus.streaming)
              const LinearProgressIndicator(),
            if (state.message != null) ...<Widget>[
              SizedBox(height: context.spacing.sm),
              Text(
                state.message!,
                style: context.typography.bodyMedium.copyWith(
                  color: context.colors.error,
                ),
              ),
            ],
            SizedBox(height: context.spacing.sm),
            Expanded(
              child: ListView.builder(
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message = state.messages[index];
                  return _TutorBubble(message: message);
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      labelText: 'Ask a legal concept...',
                    ),
                  ),
                ),
                SizedBox(width: context.spacing.sm),
                FilledButton(
                  onPressed: () {
                    final question = _questionController.text.trim();
                    _questionController.clear();
                    ref
                        .read(aiTutorControllerProvider.notifier)
                        .askTutor(question);
                  },
                  child: const Text('Ask'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorBubble extends StatelessWidget {
  const _TutorBubble({required this.message});

  final AiTutorMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: context.spacing.sm),
        padding: EdgeInsets.all(context.spacing.sm),
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: isUser
              ? context.colors.actionPrimary
              : context.colors.surfacePrimary,
          borderRadius: context.radius.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.content,
              style: context.typography.bodyMedium.copyWith(
                color: isUser ? Colors.white : context.colors.textPrimary,
              ),
            ),
            if (message.citations.isNotEmpty && !isUser) ...<Widget>[
              SizedBox(height: context.spacing.xs),
              Text(
                'Citations: ${message.citations.join(', ')}',
                style: context.typography.captionSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
