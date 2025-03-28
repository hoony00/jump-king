
class ScoreModel  {
  final int score;
  final int highScore;
  final DateTime date;
  final bool isServerMode;

  ScoreModel({
    required this.score,
    required this.highScore,
    required this.date,
    required this.isServerMode,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      score: json['score'] as int,
      highScore: json['highScore'] as int,
      date: DateTime.parse(json['date'] as String),
      isServerMode: json['isServerMode'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'highScore': highScore,
      'date': date.toIso8601String(),
      'isServerMode': isServerMode,
    };
  }
}

