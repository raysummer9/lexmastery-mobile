class FeatureFlag {
  const FeatureFlag({
    required this.key,
    required this.enabled,
    required this.rolloutPercentage,
  });

  final String key;
  final bool enabled;
  final int rolloutPercentage;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'enabled': enabled,
      'rolloutPercentage': rolloutPercentage,
    };
  }

  factory FeatureFlag.fromJson(Map<dynamic, dynamic> json) {
    return FeatureFlag(
      key: json['key'] as String,
      enabled: json['enabled'] as bool,
      rolloutPercentage: json['rolloutPercentage'] as int,
    );
  }
}
