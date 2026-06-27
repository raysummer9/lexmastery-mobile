import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/notifications/domain/entities/notification_preferences.dart';
import 'package:lexmastery_mobile/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:lexmastery_mobile/features/notifications/presentation/state/notifications_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () =>
          ref.read(notificationsControllerProvider.notifier).loadPreferences(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsControllerProvider);
    final preferences = state.preferences;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          NotificationsStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          NotificationsStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load preferences.')),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _FrequencyField(
                  label: 'Study reminders',
                  currentValue: preferences?.studyReminders ?? 'daily',
                  onChanged: (value) => _save(
                    preferences,
                    studyReminders: value,
                  ),
                ),
                SizedBox(height: context.spacing.md),
                _FrequencyField(
                  label: 'Exam alerts',
                  currentValue: preferences?.examAlerts ?? 'important_only',
                  onChanged: (value) => _save(
                    preferences,
                    examAlerts: value,
                  ),
                ),
                SizedBox(height: context.spacing.md),
                _FrequencyField(
                  label: 'AI suggestions',
                  currentValue: preferences?.aiSuggestions ?? 'balanced',
                  onChanged: (value) => _save(
                    preferences,
                    aiSuggestions: value,
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }

  Future<void> _save(
    NotificationPreferences? current, {
    String? studyReminders,
    String? examAlerts,
    String? aiSuggestions,
  }) async {
    if (current == null) return;
    await ref.read(notificationsControllerProvider.notifier).savePreferences(
          NotificationPreferences(
            studyReminders: studyReminders ?? current.studyReminders,
            examAlerts: examAlerts ?? current.examAlerts,
            aiSuggestions: aiSuggestions ?? current.aiSuggestions,
            updatedAt: DateTime.now(),
          ),
        );
  }
}

class _FrequencyField extends StatelessWidget {
  const _FrequencyField({
    required this.label,
    required this.currentValue,
    required this.onChanged,
  });

  final String label;
  final String currentValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem(value: 'off', child: Text('off')),
        DropdownMenuItem(
            value: 'important_only', child: Text('important_only')),
        DropdownMenuItem(value: 'daily', child: Text('daily')),
        DropdownMenuItem(value: 'balanced', child: Text('balanced')),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }
}
