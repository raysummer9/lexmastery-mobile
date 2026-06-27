import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/flashcards/presentation/controllers/flashcards_controller.dart';
import 'package:lexmastery_mobile/features/flashcards/presentation/state/flashcards_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(flashcardsControllerProvider.notifier).loadDeck(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardsControllerProvider);
    final card = state.currentCard;
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          FlashcardsStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          FlashcardsStatus.completed =>
            const Center(child: Text('Session complete. Great retention work.')),
          _ => card == null
              ? const Center(child: Text('No cards available.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Card ${state.currentIndex + 1}/${state.deck.length}',
                      style: context.typography.labelMedium,
                    ),
                    SizedBox(height: context.spacing.md),
                    Container(
                      padding: EdgeInsets.all(context.spacing.lg),
                      decoration: BoxDecoration(
                        color: context.colors.surfacePrimary,
                        borderRadius: context.radius.card,
                        border: Border.all(color: context.colors.borderDefault),
                      ),
                      child: Text(
                        _revealed ? card.back : card.front,
                        style: context.typography.titleLarge,
                      ),
                    ),
                    SizedBox(height: context.spacing.md),
                    OutlinedButton(
                      onPressed: () => setState(() => _revealed = !_revealed),
                      child: Text(_revealed ? 'Hide Answer' : 'Reveal Answer'),
                    ),
                    SizedBox(height: context.spacing.md),
                    Wrap(
                      spacing: context.spacing.sm,
                      runSpacing: context.spacing.sm,
                      children: <Widget>[
                        _rateButton(label: 'Again', quality: 1),
                        _rateButton(label: 'Hard', quality: 2),
                        _rateButton(label: 'Good', quality: 4),
                        _rateButton(label: 'Easy', quality: 5),
                      ],
                    ),
                  ],
                ),
        },
      ),
    );
  }

  Widget _rateButton({
    required String label,
    required int quality,
  }) {
    return FilledButton(
      onPressed: () async {
        await ref.read(flashcardsControllerProvider.notifier).rateCurrentCard(
              quality: quality,
              responseTimeMs: 2500,
            );
        if (mounted) {
          setState(() => _revealed = false);
        }
      },
      child: Text(label),
    );
  }
}
