import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/rag_engine/presentation/controllers/rag_controller.dart';
import 'package:lexmastery_mobile/features/rag_engine/presentation/state/rag_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class RagEngineScreen extends ConsumerStatefulWidget {
  const RagEngineScreen({super.key});

  @override
  ConsumerState<RagEngineScreen> createState() => _RagEngineScreenState();
}

class _RagEngineScreenState extends ConsumerState<RagEngineScreen> {
  final TextEditingController _queryController = TextEditingController(
    text: 'offer and acceptance',
  );

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ragControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('RAG Engine')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(labelText: 'RAG query'),
            ),
            SizedBox(height: context.spacing.md),
            FilledButton(
              onPressed: () => ref
                  .read(ragControllerProvider.notifier)
                  .retrieve(_queryController.text.trim()),
              child: const Text('Retrieve Context'),
            ),
            SizedBox(height: context.spacing.md),
            if (state.status == RagStatus.loading)
              const LinearProgressIndicator(),
            SizedBox(height: context.spacing.sm),
            Expanded(
              child: ListView.builder(
                itemCount: state.chunks.length,
                itemBuilder: (context, index) {
                  final chunk = state.chunks[index];
                  return Card(
                    child: ListTile(
                      title: Text(chunk.title),
                      subtitle: Text(chunk.content),
                      trailing: Text(chunk.score.toStringAsFixed(2)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
