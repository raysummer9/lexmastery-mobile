class SyncJob {
  const SyncJob({
    required this.id,
    required this.entityType,
    required this.payload,
    required this.retryCount,
    required this.createdAt,
  });

  final String id;
  final String entityType;
  final Map<String, dynamic> payload;
  final int retryCount;
  final DateTime createdAt;

  SyncJob copyWith({
    int? retryCount,
  }) {
    return SyncJob(
      id: id,
      entityType: entityType,
      payload: payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'entityType': entityType,
      'payload': payload,
      'retryCount': retryCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SyncJob.fromJson(Map<dynamic, dynamic> json) {
    return SyncJob(
      id: json['id'] as String,
      entityType: json['entityType'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
      retryCount: json['retryCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
