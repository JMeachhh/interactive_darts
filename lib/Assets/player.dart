import 'package:uuid/uuid.dart';

class Player {
  final String id;
  final String name;
  final String imagePath;
  double score;
  int lives;

  int throwsThisTurn = 0;

  final List<double> scoreHistory = [];
  final List<double> allThrows = [];

  Player({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.score,
    this.lives = 0,
  });

  factory Player.create({required String name, required String imagePath}) {
    return Player(
      id: const Uuid().v4(),
      name: name,
      imagePath: imagePath,
      score: 0,
      lives: 0,
    );
  }

  void addLife(int amount) {
    lives = (lives + amount).clamp(-1, 3);
  }

  void removeLife(int amount) {
    lives = (lives - amount).clamp(-1, 3);
  }

  void addThrow() {
    throwsThisTurn += 1;
  }

  int getLife() {
    return lives;
  }

  int getThrowsLeft() {
    return throwsThisTurn;
  }

  void removeScore(double score) {
    this.score -= score;
    if (this.score < 0) this.score = 0;
  }

  void addScore(double value) {
    scoreHistory.add(score);
    score += value;

    throwsThisTurn += 1;
    allThrows.add(value);
  }

  void undoLastScore() {
    if (scoreHistory.isNotEmpty && allThrows.isNotEmpty) {
      score = scoreHistory.removeLast();
      allThrows.removeLast();
      throwsThisTurn = allThrows.length % 3; // throws in current turn (mod 3)
    }
  }

  // Reset current score only (used at the start of a new turn)
  void resetTempScore() {
    score = 0;
  }

  // Restore a previous turn's throws and score (for undo)
  void restoreTurn(List<double> previousThrows) {
    allThrows.addAll(previousThrows);
    score = previousThrows.fold(0.0, (sum, s) => sum + s);
    throwsThisTurn = previousThrows.length;
  }

  void resetThrows() {
    throwsThisTurn = 0;
  }

  /// Returns the last 3 throws to display on the scoreboard
  List<double> get throwsThisTurnScores {
    if (allThrows.isEmpty) return [];

    // Get last N throws of current turn, max 3
    int count = throwsThisTurn;
    if (count == 0 && allThrows.isNotEmpty) {
      // If no throws this turn, show empty list
      return [];
    }

    // Return last `throwsThisTurn` throws from _allThrows
    return allThrows.sublist(allThrows.length - count);
  }

  /// Reset history and score
  void reset() {
    scoreHistory.clear();
    allThrows.clear();
    score = 0;
    throwsThisTurn = 0;
    lives = 0;
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

  void clearScoreHistory() {
    scoreHistory.clear();
    allThrows.clear();
    throwsThisTurn = 0;
  }
}
