class CacheMetadata {
  const CacheMetadata({
    required this.createdAt,
    required this.updatedAt,
    required this.expiresAt,
  });

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory CacheMetadata.fromJson(Map<dynamic, dynamic> json) {
    return CacheMetadata(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
}
