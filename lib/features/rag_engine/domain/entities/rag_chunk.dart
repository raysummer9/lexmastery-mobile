class RagChunk {
  const RagChunk({
    required this.sourceId,
    required this.title,
    required this.content,
    required this.score,
  });

  final String sourceId;
  final String title;
  final String content;
  final double score;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sourceId': sourceId,
      'title': title,
      'content': content,
      'score': score,
    };
  }

  factory RagChunk.fromJson(Map<dynamic, dynamic> json) {
    return RagChunk(
      sourceId: json['sourceId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }
}
