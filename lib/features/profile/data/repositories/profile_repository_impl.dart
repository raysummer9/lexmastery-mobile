import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/profile/data/contracts/profile_api_contract.dart';
import 'package:lexmastery_mobile/features/profile/domain/entities/profile.dart';
import 'package:lexmastery_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final UpdateProfileApiContract _contract = UpdateProfileApiContract();

  @override
  Future<Profile> getProfile() async {
    final cached = LocalStorageService.readValue<String>(StorageKeys.profile);
    if (cached != null) {
      return Profile.fromJson(jsonDecode(cached) as Map<dynamic, dynamic>);
    }
    return Profile(
      userId: 'phase1-user',
      name: 'LexMastery Learner',
      email: 'learner@lexmastery.ai',
      jurisdiction: 'England & Wales',
      examTarget: 'SQE',
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    final request = UpdateProfileRequest(
      userId: profile.userId,
      name: profile.name,
      email: profile.email,
      jurisdiction: profile.jurisdiction,
      examTarget: profile.examTarget,
    );

    Profile updated = profile;
    try {
      final response = await _apiClient.post(
        _contract.path,
        data: _contract.toRequest(request),
      );
      final remote =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      updated = Profile(
        userId: remote.userId,
        name: remote.name,
        email: remote.email,
        jurisdiction: remote.jurisdiction,
        examTarget: remote.examTarget,
        updatedAt: DateTime.parse(remote.updatedAtIso),
      );
    } catch (_) {
      updated = Profile(
        userId: profile.userId,
        name: profile.name,
        email: profile.email,
        jurisdiction: profile.jurisdiction,
        examTarget: profile.examTarget,
        updatedAt: DateTime.now(),
      );
    }

    await LocalStorageService.writeValue(
      StorageKeys.profile,
      jsonEncode(updated.toJson()),
    );
    return updated;
  }
}
