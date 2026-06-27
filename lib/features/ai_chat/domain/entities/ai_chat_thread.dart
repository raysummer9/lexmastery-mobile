class AiChatMessage {
  const AiChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String role;
  final String content;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'role': role,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AiChatMessage.fromJson(Map<dynamic, dynamic> json) {
    return AiChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class AiChatThread {
  const AiChatThread({
    required this.id,
    required this.title,
    required this.messages,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final List<AiChatMessage> messages;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'messages': messages.map((AiChatMessage m) => m.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AiChatThread.fromJson(Map<dynamic, dynamic> json) {
    return AiChatThread(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((dynamic m) => AiChatMessage.fromJson(m as Map))
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
