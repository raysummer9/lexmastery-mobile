class FlashcardItem {
  const FlashcardItem({
    required this.id,
    required this.front,
    required this.back,
    required this.easeFactor,
    required this.intervalDays,
    required this.nextReviewAt,
  });

  final String id;
  final String front;
  final String back;
  final double easeFactor;
  final int intervalDays;
  final DateTime nextReviewAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'front': front,
      'back': back,
      'easeFactor': easeFactor,
      'intervalDays': intervalDays,
      'nextReviewAt': nextReviewAt.toIso8601String(),
    };
  }

  factory FlashcardItem.fromJson(Map<dynamic, dynamic> json) {
    return FlashcardItem(
      id: json['id'] as String,
      front: json['front'] as String,
      back: json['back'] as String,
      easeFactor: (json['easeFactor'] as num).toDouble(),
      intervalDays: json['intervalDays'] as int,
      nextReviewAt: DateTime.parse(json['nextReviewAt'] as String),
    );
  }
}
