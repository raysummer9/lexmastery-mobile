class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'prompt': prompt,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
    };
  }

  factory QuizQuestion.fromJson(Map<dynamic, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      options:
          (json['options'] as List<dynamic>).map((dynamic e) => '$e').toList(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }
}
