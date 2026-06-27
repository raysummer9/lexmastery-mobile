import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/dashboard/data/contracts/dashboard_api_contract.dart';
import 'package:lexmastery_mobile/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:lexmastery_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final DashboardApiContract _contract = DashboardApiContract();

  @override
  Future<DashboardSnapshot> getDashboard() async {
    final cached =
        LocalStorageService.readValue<String>(StorageKeys.dashboardSnapshot);
    if (cached != null) {
      return DashboardSnapshot.fromJson(
        jsonDecode(cached) as Map<dynamic, dynamic>,
      );
    }

    DashboardSnapshot snapshot;
    try {
      final response = await _apiClient.get(_contract.path);
      final parsed =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      snapshot = DashboardSnapshot(
        continueLearningCourseId: parsed.continueLearningCourseId,
        dailyGoalMinutes: parsed.dailyGoalMinutes,
        streakDays: parsed.streakDays,
        aiSuggestion: parsed.aiSuggestion,
        updatedAt: DateTime.parse(parsed.updatedAtIso),
      );
    } catch (_) {
      snapshot = DashboardSnapshot(
        continueLearningCourseId: 'course-contract-law',
        dailyGoalMinutes: 90,
        streakDays: 4,
        aiSuggestion: 'Review contract offer/acceptance distinctions today.',
        updatedAt: DateTime.now(),
      );
    }

    await LocalStorageService.writeValue(
      StorageKeys.dashboardSnapshot,
      jsonEncode(snapshot.toJson()),
    );
    return snapshot;
  }
}
