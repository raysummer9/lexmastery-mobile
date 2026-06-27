class Profile {
  const Profile({
    required this.userId,
    required this.name,
    required this.email,
    required this.jurisdiction,
    required this.examTarget,
    required this.updatedAt,
  });

  final String userId;
  final String name;
  final String email;
  final String jurisdiction;
  final String examTarget;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'jurisdiction': jurisdiction,
      'examTarget': examTarget,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Profile.fromJson(Map<dynamic, dynamic> json) {
    return Profile(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      jurisdiction: json['jurisdiction'] as String,
      examTarget: json['examTarget'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
