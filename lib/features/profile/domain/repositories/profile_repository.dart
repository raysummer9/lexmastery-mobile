import 'package:lexmastery_mobile/features/profile/domain/entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Profile> getProfile();
  Future<Profile> updateProfile(Profile profile);
}
