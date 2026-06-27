import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/ai_memory/data/contracts/ai_memory_api_contract.dart';
import 'package:lexmastery_mobile/features/ai_memory/domain/entities/ai_memory_profile.dart';
import 'package:lexmastery_mobile/features/ai_memory/domain/repositories/ai_memory_repository.dart';

class AiMemoryRepositoryImpl implements AiMemoryRepository {
  AiMemoryRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  final AiMemoryApiContract _contract = AiMemoryApiContract();

  @override
  Future<AiMemoryProfile> getProfile() async {
    final cached =
        LocalStorageService.readValue<String>(StorageKeys.aiMemoryProfile);
    if (cached != null) {
      return AiMemoryProfile.fromJson(
          jsonDecode(cached) as Map<dynamic, dynamic>);
    }
    return AiMemoryProfile(
      weakTopics: const <String>['consideration'],
      masteredTopics: const <String>['offer and acceptance'],
      preferences: const <String, String>{
        'explanationDepth': 'balanced',
        'jurisdiction': 'england_and_wales',
      },
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<AiMemoryProfile> updateProfile(AiMemoryProfile profile) async {
    try {
      await _apiClient.post(
        _contract.path,
        data:
            _contract.toRequest(UpdateMemoryRequest(payload: profile.toJson())),
      );
    } catch (_) {
      // Keep local-first memory updates non-blocking.
    }
    await LocalStorageService.writeValue(
      StorageKeys.aiMemoryProfile,
      jsonEncode(profile.toJson()),
    );
    return profile;
  }
}
