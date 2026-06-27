import 'package:lexmastery_mobile/features/profile/domain/entities/profile.dart';

enum ProfileStatus {
  loading,
  ready,
  updating,
  failure,
}

class ProfileState {
  const ProfileState({
    required this.status,
    this.profile,
    this.message,
  });

  const ProfileState.initial()
      : status = ProfileStatus.loading,
        profile = null,
        message = null;

  final ProfileStatus status;
  final Profile? profile;
  final String? message;

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      message: message,
    );
  }
}
