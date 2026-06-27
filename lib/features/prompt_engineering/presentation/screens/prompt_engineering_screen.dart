import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/domain/entities/prompt_template.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/presentation/controllers/prompt_engineering_controller.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/presentation/state/prompt_engineering_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class PromptEngineeringScreen extends ConsumerStatefulWidget {
  const PromptEngineeringScreen({super.key});

  @override
  ConsumerState<PromptEngineeringScreen> createState() =>
      _PromptEngineeringScreenState();
}

class _PromptEngineeringScreenState
    extends ConsumerState<PromptEngineeringScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref
          .read(promptEngineeringControllerProvider.notifier)
          .loadTemplates(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promptEngineeringControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Prompt Engineering')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          PromptEngineeringStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          PromptEngineeringStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load templates.')),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<PromptTemplate>(
                  items: state.templates
                      .map(
                        (PromptTemplate template) =>
                            DropdownMenuItem<PromptTemplate>(
                          value: template,
                          child: Text(template.name),
                        ),
                      )
                      .toList(),
                  onChanged: (PromptTemplate? selected) {
                    if (selected == null) return;
                    ref
                        .read(promptEngineeringControllerProvider.notifier)
                        .render(
                      template: selected,
                      context: const <String, String>{
                        'topic': 'consideration',
                        'jurisdiction': 'england_and_wales',
                        'question': 'What is valid consideration?',
                      },
                    );
                  },
                  decoration: const InputDecoration(labelText: 'Template'),
                ),
                SizedBox(height: context.spacing.md),
                Text(
                  state.renderedPrompt ??
                      'Select a template to render prompt output.',
                  style: context.typography.bodyMedium,
                ),
              ],
            ),
        },
      ),
    );
  }
}
