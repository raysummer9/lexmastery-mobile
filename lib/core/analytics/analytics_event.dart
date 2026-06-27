enum AnalyticsEventType {
  screenViewed,
  featureUsed,
  custom,
}

class AnalyticsEvent {
  const AnalyticsEvent({
    required this.type,
    required this.name,
    required this.occurredAt,
    this.payload = const <String, dynamic>{},
  });

  factory AnalyticsEvent.screenViewed({
    required String screenName,
  }) {
    return AnalyticsEvent(
      type: AnalyticsEventType.screenViewed,
      name: 'screen_viewed',
      occurredAt: DateTime.now(),
      payload: <String, dynamic>{'screenName': screenName},
    );
  }

  final AnalyticsEventType type;
  final String name;
  final DateTime occurredAt;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.name,
      'name': name,
      'occurredAt': occurredAt.toIso8601String(),
      'payload': payload,
    };
  }

  factory AnalyticsEvent.fromJson(Map<dynamic, dynamic> json) {
    return AnalyticsEvent(
      type: AnalyticsEventType.values.byName(json['type'] as String),
      name: json['name'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      payload: Map<String, dynamic>.from(json['payload'] as Map),
    );
  }
}
