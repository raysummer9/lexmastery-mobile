class DashboardSnapshot {
  const DashboardSnapshot({
    required this.continueLearningCourseId,
    required this.dailyGoalMinutes,
    required this.streakDays,
    required this.aiSuggestion,
    required this.updatedAt,
  });

  final String continueLearningCourseId;
  final int dailyGoalMinutes;
  final int streakDays;
  final String aiSuggestion;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'continueLearningCourseId': continueLearningCourseId,
      'dailyGoalMinutes': dailyGoalMinutes,
      'streakDays': streakDays,
      'aiSuggestion': aiSuggestion,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DashboardSnapshot.fromJson(Map<dynamic, dynamic> json) {
    return DashboardSnapshot(
      continueLearningCourseId: json['continueLearningCourseId'] as String,
      dailyGoalMinutes: json['dailyGoalMinutes'] as int,
      streakDays: json['streakDays'] as int,
      aiSuggestion: json['aiSuggestion'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
