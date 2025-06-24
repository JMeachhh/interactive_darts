import 'package:uuid/uuid.dart';

class Player {
  final String id;
  final String name;
  final String imagePath;
  double score;

  int throwsThisTurn = 0;

  final List<double> _scoreHistory = [];
  final List<double> _allThrows = [];

  Player({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.score,
  });

  factory Player.create({required String name, required String imagePath}) {
    return Player(
      id: const Uuid().v4(),
      name: name,
      imagePath: imagePath,
      score: 0,
    );
  }

  void removeScore(double score) {
  this.score -= score;
  if (this.score < 0) this.score = 0;
}

  void addScore(double value) {
    _scoreHistory.add(score);
    score += value;

    throwsThisTurn += 1;
    _allThrows.add(value);
  }

  void undoLastScore() {
    if (_scoreHistory.isNotEmpty && _allThrows.isNotEmpty) {
      score = _scoreHistory.removeLast();
      _allThrows.removeLast();
      throwsThisTurn = _allThrows.length % 3; // throws in current turn (mod 3)
    }
  }

  void resetThrows() {
    throwsThisTurn = 0;
  }

  /// Returns the last 3 throws to display on the scoreboard
  List<double> get throwsThisTurnScores {
    if (_allThrows.isEmpty) return [];

    // Get last N throws of current turn, max 3
    int count = throwsThisTurn;
    if (count == 0 && _allThrows.isNotEmpty) {
      // If no throws this turn, show empty list
      return [];
    }

    // Return last `throwsThisTurn` throws from _allThrows
    return _allThrows.sublist(_allThrows.length - count);
  }

  /// Reset history and score
  void reset() {
    _scoreHistory.clear();
    _allThrows.clear();
    score = 0;
    throwsThisTurn = 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'score': score,
      };

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      score: (json['score'] as num).toDouble(),
    );
  }
}
