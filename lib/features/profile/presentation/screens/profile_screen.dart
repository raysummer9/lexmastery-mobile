import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/features/profile/domain/entities/profile.dart';
import 'package:lexmastery_mobile/features/profile/presentation/controllers/profile_controller.dart';
import 'package:lexmastery_mobile/features/profile/presentation/state/profile_state.dart';
import 'package:lexmastery_mobile/shared/theme_extensions/theme_context_extensions.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jurisdictionController = TextEditingController();
  final TextEditingController _examController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(profileControllerProvider.notifier).loadProfile(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jurisdictionController.dispose();
    _examController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final profile = state.profile;
    if (profile != null) {
      _nameController.text = profile.name;
      _jurisdictionController.text = profile.jurisdiction;
      _examController.text = profile.examTarget;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: switch (state.status) {
          ProfileStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          ProfileStatus.failure =>
            Center(child: Text(state.message ?? 'Unable to load profile.')),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                SizedBox(height: context.spacing.md),
                TextField(
                  controller: _jurisdictionController,
                  decoration: const InputDecoration(labelText: 'Jurisdiction'),
                ),
                SizedBox(height: context.spacing.md),
                TextField(
                  controller: _examController,
                  decoration: const InputDecoration(labelText: 'Exam Target'),
                ),
                SizedBox(height: context.spacing.lg),
                FilledButton(
                  onPressed: profile == null ||
                          state.status == ProfileStatus.updating
                      ? null
                      : () => ref
                          .read(profileControllerProvider.notifier)
                          .saveProfile(
                            Profile(
                              userId: profile.userId,
                              name: _nameController.text.trim(),
                              email: profile.email,
                              jurisdiction: _jurisdictionController.text.trim(),
                              examTarget: _examController.text.trim(),
                              updatedAt: DateTime.now(),
                            ),
                          ),
                  child: Text(
                    state.status == ProfileStatus.updating
                        ? 'Saving...'
                        : 'Save Profile',
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
