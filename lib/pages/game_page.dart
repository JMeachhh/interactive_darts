import 'package:flutter/material.dart';
import 'package:interactive_darts/Assets/dart_board.dart';

class GamePage extends StatefulWidget {
  final String gameName;

  const GamePage({
    super.key,
    required this.gameName,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String scoreText = 'No score yet';
  double score = 0;

  void onScoreUpdate(int segment, String ring) {
    setState(() {
      switch (ring) {
        case 'single':
          score = segment.toDouble();
          break;
        case 'double':
          score = segment * 2;
          break;
        case 'triple':
          score = segment * 3;
          break;
        default:
          score = segment.toDouble();
      }

      scoreText = 'Score: $score';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameName),
      ),
      body: Column(
        children: [
          DartBoard(
            type: 'normal',
            onScoreChanged: onScoreUpdate,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(scoreText, style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
