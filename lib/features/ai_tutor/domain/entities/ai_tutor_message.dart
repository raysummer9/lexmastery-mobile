class AiTutorMessage {
  const AiTutorMessage({
    required this.role,
    required this.content,
    required this.createdAt,
    this.citations = const <String>[],
  });

  final String role;
  final String content;
  final DateTime createdAt;
  final List<String> citations;
}
