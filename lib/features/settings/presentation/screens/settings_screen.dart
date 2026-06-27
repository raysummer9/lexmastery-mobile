import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/settings/domain/entities/settings.dart';
import 'package:lexmastery_mobile/features/settings/presentation/controllers/settings_controller.dart';
import 'package:lexmastery_mobile/features/settings/presentation/state/settings_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(settingsControllerProvider.notifier).loadSettings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsControllerProvider);
    final settings = state.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          SettingsStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          SettingsStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load settings.')),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<AppThemeMode>(
                  value: settings?.themeMode ?? AppThemeMode.system,
                  items: AppThemeMode.values
                      .map(
                        (mode) => DropdownMenuItem<AppThemeMode>(
                          value: mode,
                          child: Text(mode.name),
                        ),
                      )
                      .toList(),
                  onChanged: settings == null
                      ? null
                      : (mode) {
                          if (mode == null) return;
                          ref
                              .read(settingsControllerProvider.notifier)
                              .saveSettings(
                                Settings(
                                  themeMode: mode,
                                  aiVerbosity: settings.aiVerbosity,
                                  analyticsEnabled: settings.analyticsEnabled,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                        },
                  decoration: const InputDecoration(labelText: 'Theme mode'),
                ),
                SizedBox(height: context.spacing.md),
                DropdownButtonFormField<String>(
                  value: settings?.aiVerbosity ?? 'balanced',
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: 'concise', child: Text('concise')),
                    DropdownMenuItem(
                        value: 'balanced', child: Text('balanced')),
                    DropdownMenuItem(
                        value: 'detailed', child: Text('detailed')),
                  ],
                  onChanged: settings == null
                      ? null
                      : (verbosity) {
                          if (verbosity == null) return;
                          ref
                              .read(settingsControllerProvider.notifier)
                              .saveSettings(
                                Settings(
                                  themeMode: settings.themeMode,
                                  aiVerbosity: verbosity,
                                  analyticsEnabled: settings.analyticsEnabled,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                        },
                  decoration: const InputDecoration(labelText: 'AI verbosity'),
                ),
              ],
            ),
        },
      ),
    );
  }
}
