import 'package:lexmastery_mobile/core/network/api_contract.dart';

class DashboardResponse {
  const DashboardResponse({
    required this.continueLearningCourseId,
    required this.dailyGoalMinutes,
    required this.streakDays,
    required this.aiSuggestion,
    required this.updatedAtIso,
  });

  final String continueLearningCourseId;
  final int dailyGoalMinutes;
  final int streakDays;
  final String aiSuggestion;
  final String updatedAtIso;
}

class DashboardApiContract implements ApiContract<void, DashboardResponse> {
  @override
  String get method => 'GET';

  @override
  String get path => '/dashboard';

  @override
  DashboardResponse parseResponse(Map<String, dynamic> json) {
    return DashboardResponse(
      continueLearningCourseId: json['continueLearningCourseId'] as String,
      dailyGoalMinutes: json['dailyGoalMinutes'] as int,
      streakDays: json['streakDays'] as int,
      aiSuggestion: json['aiSuggestion'] as String,
      updatedAtIso: json['updatedAt'] as String,
    );
  }

  @override
  Map<String, dynamic> toRequest(void request) => const <String, dynamic>{};
}
