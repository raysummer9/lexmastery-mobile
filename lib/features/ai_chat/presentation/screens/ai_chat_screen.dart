import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/ai_chat/domain/entities/ai_chat_thread.dart';
import 'package:lexmastery_mobile/features/ai_chat/presentation/controllers/ai_chat_controller.dart';
import 'package:lexmastery_mobile/features/ai_chat/presentation/state/ai_chat_state.dart';
import 'package:lexmastery_mobile/features/ai_tutor/routes/ai_tutor_routes.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(aiChatControllerProvider.notifier).loadThreads(),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AiChatState>(aiChatControllerProvider, (previous, next) {
      if (next.routingTarget == AiChatRoutingTarget.tutor) {
        ref.read(aiChatControllerProvider.notifier).consumeRoutingSignal();
        context.go(AiTutorRoutes.tutorPath);
      }
    });
    final state = ref.watch(aiChatControllerProvider);
    final thread = state.activeThread;
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                ref.read(aiChatControllerProvider.notifier).startThread(),
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: state.mode,
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(value: 'general', child: Text('general')),
                DropdownMenuItem(value: 'legal_qa', child: Text('legal_qa')),
                DropdownMenuItem(
                    value: 'study_support', child: Text('study_support')),
                DropdownMenuItem(
                    value: 'explanation', child: Text('explanation')),
              ],
              onChanged: (String? mode) {
                if (mode != null) {
                  ref.read(aiChatControllerProvider.notifier).setMode(mode);
                }
              },
              decoration: const InputDecoration(labelText: 'Mode'),
            ),
            SizedBox(height: context.spacing.md),
            Expanded(
              child: ListView.builder(
                itemCount: thread?.messages.length ?? 0,
                itemBuilder: (context, index) {
                  final message = thread!.messages[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),
            SizedBox(height: context.spacing.sm),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Ask anything legal...',
                    ),
                  ),
                ),
                SizedBox(width: context.spacing.sm),
                FilledButton(
                  onPressed: () {
                    final text = _messageController.text.trim();
                    _messageController.clear();
                    ref
                        .read(aiChatControllerProvider.notifier)
                        .sendMessage(text);
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final AiChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: context.spacing.sm),
        padding: EdgeInsets.all(context.spacing.sm),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser
              ? context.colors.actionPrimary
              : context.colors.surfacePrimary,
          borderRadius: context.radius.card,
        ),
        child: Text(
          message.content,
          style: context.typography.bodyMedium.copyWith(
            color: isUser ? Colors.white : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
