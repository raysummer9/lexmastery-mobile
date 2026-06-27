enum AppThemeMode {
  system,
  light,
  dark,
}

class Settings {
  const Settings({
    required this.themeMode,
    required this.aiVerbosity,
    required this.analyticsEnabled,
    required this.updatedAt,
  });

  final AppThemeMode themeMode;
  final String aiVerbosity;
  final bool analyticsEnabled;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'themeMode': themeMode.name,
      'aiVerbosity': aiVerbosity,
      'analyticsEnabled': analyticsEnabled,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Settings.fromJson(Map<dynamic, dynamic> json) {
    return Settings(
      themeMode: AppThemeMode.values.byName(json['themeMode'] as String),
      aiVerbosity: json['aiVerbosity'] as String,
      analyticsEnabled: json['analyticsEnabled'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
