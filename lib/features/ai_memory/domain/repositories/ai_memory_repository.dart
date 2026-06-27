import 'package:lexmastery_mobile/features/ai_memory/domain/entities/ai_memory_profile.dart';

abstract interface class AiMemoryRepository {
  Future<AiMemoryProfile> getProfile();
  Future<AiMemoryProfile> updateProfile(AiMemoryProfile profile);
}
