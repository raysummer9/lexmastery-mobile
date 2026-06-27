class NotificationPreferences {
  const NotificationPreferences({
    required this.studyReminders,
    required this.examAlerts,
    required this.aiSuggestions,
    required this.updatedAt,
  });

  final String studyReminders;
  final String examAlerts;
  final String aiSuggestions;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'studyReminders': studyReminders,
      'examAlerts': examAlerts,
      'aiSuggestions': aiSuggestions,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory NotificationPreferences.fromJson(Map<dynamic, dynamic> json) {
    return NotificationPreferences(
      studyReminders: json['studyReminders'] as String,
      examAlerts: json['examAlerts'] as String,
      aiSuggestions: json['aiSuggestions'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
