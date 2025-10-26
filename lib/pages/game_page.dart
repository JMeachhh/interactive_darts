import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interactive_darts/Assets/player.dart';
import 'package:provider/provider.dart';
import 'package:interactive_darts/Assets/dart_board.dart';
import 'package:interactive_darts/Assets/scoreboard.dart';
import 'package:interactive_darts/Assets/player_manager.dart';

class GamePage extends StatefulWidget {
  final String gameName;
  final int maxAmountOfPlayers;

  const GamePage({
    super.key,
    required this.gameName,
    required this.maxAmountOfPlayers,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentPlayerIndex = 0;
  String scoreText = 'No score yet';
  bool showNextPlayerOverlay = false;
  int? nextPlayerIndex;

  final List<Map<String, dynamic>> _scoreHistory = [];

  void onScoreUpdate(int segment, String ring) {
    final players = context.read<PlayerManager>().players;
    if (players.isEmpty || showNextPlayerOverlay) return;

    int multiplier = switch (ring) {
      'double' => 2,
      'triple' => 3,
      _ => 1,
    };

    double scored = segment * multiplier.toDouble();
    final player = players[currentPlayerIndex];

    setState(() {
      player.addScore(scored);
      scoreText = '${player.name} scored $scored';

      _scoreHistory.add({
        'playerIndex': currentPlayerIndex,
        'score': player.score,
        'throw': scored,
      });
    });

    if (player.throwsThisTurn >= 3) {
      nextPlayerIndex = (currentPlayerIndex + 1) % players.length;

      setState(() {
        showNextPlayerOverlay = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          player.resetThrows();
          currentPlayerIndex = nextPlayerIndex!;
          scoreText = '${players[currentPlayerIndex].name}\'s turn';
          showNextPlayerOverlay = false;
          nextPlayerIndex = null;
        });
      });
    }
  }

  void undoLastScore(int _) {
    final players = context.read<PlayerManager>().players;

    if (_scoreHistory.isEmpty || showNextPlayerOverlay) {
      setState(() {
        scoreText = 'No Score to Undo';
      });
      return;
    }

    setState(() {
      final lastTurn = _scoreHistory.removeLast();
      final playerIndex = lastTurn['playerIndex'] as int;

      context.read<PlayerManager>().undoLastScore(playerIndex);
      currentPlayerIndex = playerIndex;
      scoreText = '${players[playerIndex].name} undid their last score';
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColour = Colors.blue[100];
    final players = context.watch<PlayerManager>().players;

    Player? nextPlayer =
        (nextPlayerIndex != null && nextPlayerIndex! < players.length)
            ? players[nextPlayerIndex!]
            : null;

    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColour,
        title: Text(
          widget.gameName,
          style: GoogleFonts.cinzelDecorative(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 0.04.sh,
          ),
        ),
      ),
      body: Column(
        children: [
          DartBoard(
            type: 'normal',
            onScoreChanged: (segment, ring) {
              if (!showNextPlayerOverlay) {
                onScoreUpdate(segment, ring);
              }
            },
          ),
          const SizedBox(height: 16),
          Scoreboard(
            gameName: "Test",
            players: players,
            currentPlayerIndex: currentPlayerIndex,
            onUndo: showNextPlayerOverlay ? null : undoLastScore,
            scoreText: scoreText,
            showNextPlayerOverlay: showNextPlayerOverlay,
            nextPlayer: nextPlayer,
          ),
        ],
      ),
    );
  }
}
