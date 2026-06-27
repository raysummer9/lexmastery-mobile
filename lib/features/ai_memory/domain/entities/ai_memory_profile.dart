class AiMemoryProfile {
  const AiMemoryProfile({
    required this.weakTopics,
    required this.masteredTopics,
    required this.preferences,
    required this.updatedAt,
  });

  final List<String> weakTopics;
  final List<String> masteredTopics;
  final Map<String, String> preferences;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'weakTopics': weakTopics,
      'masteredTopics': masteredTopics,
      'preferences': preferences,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AiMemoryProfile.fromJson(Map<dynamic, dynamic> json) {
    return AiMemoryProfile(
      weakTopics: (json['weakTopics'] as List<dynamic>)
          .map((dynamic e) => '$e')
          .toList(),
      masteredTopics: (json['masteredTopics'] as List<dynamic>)
          .map((dynamic e) => '$e')
          .toList(),
      preferences: Map<String, String>.from(
          json['preferences'] as Map<dynamic, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
