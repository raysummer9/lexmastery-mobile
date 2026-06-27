import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:lexmastery_mobile/features/profile/domain/entities/profile.dart';
import 'package:lexmastery_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:lexmastery_mobile/features/profile/presentation/state/profile_state.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(
  ProfileController.new,
);

class ProfileController extends Notifier<ProfileState> {
  late final ProfileRepository _repository;

  @override
  ProfileState build() {
    _repository = ref.read(profileRepositoryProvider);
    return const ProfileState.initial();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(status: ProfileStatus.ready, profile: profile);
    } catch (_) {
      state = state.copyWith(
        status: ProfileStatus.failure,
        message: 'Unable to load profile.',
      );
    }
  }

  Future<void> saveProfile(Profile profile) async {
    state = state.copyWith(status: ProfileStatus.updating, message: null);
    try {
      final updated = await _repository.updateProfile(profile);
      await ref.read(syncControllerProvider.notifier).enqueue(
            SyncJob(
              id: 'profile-${updated.updatedAt.microsecondsSinceEpoch}',
              entityType: 'profile',
              payload: updated.toJson(),
              retryCount: 0,
              createdAt: DateTime.now(),
            ),
          );
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'profile_update',
              occurredAt: DateTime.now(),
              payload: <String, dynamic>{'userId': updated.userId},
            ),
          );
      state = state.copyWith(status: ProfileStatus.ready, profile: updated);
    } catch (_) {
      state = state.copyWith(
        status: ProfileStatus.failure,
        message: 'Unable to save profile.',
      );
    }
  }
}
