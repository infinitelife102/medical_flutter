class FeedbackModel {
  final String name;
  final String email;
  final String feedbackText;
  final int rating;
  final DateTime timestamp;

  FeedbackModel({
    required this.name,
    required this.email,
    required this.feedbackText,
    required this.rating,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'feedbackText': feedbackText,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      feedbackText: map['feedbackText'] ?? '',
      rating: map['rating'] ?? 0,
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
