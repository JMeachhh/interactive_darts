import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interactive_darts/Assets/player.dart';
import 'package:interactive_darts/Assets/scoreboard.dart';
import 'package:interactive_darts/pages/finish_page.dart';
import 'package:provider/provider.dart';
import 'package:interactive_darts/Assets/player_manager.dart';
import 'package:interactive_darts/Assets/dart_board.dart';

class LivesGamePage extends StatefulWidget {
  const LivesGamePage({super.key});

  @override
  State<LivesGamePage> createState() => _LivesGamePageState();
}

class _LivesGamePageState extends State<LivesGamePage> {
  int currentPlayerIndex = 0;
  String scoreText = 'No score to beat yet';
  bool showNextPlayerOverlay = false;
  int? nextPlayerIndex;
  int scoreToBeat = 0;

  final List<Map<String, dynamic>> _scoreHistory = [];

  @override
  void initState() {
    super.initState();
    final players = context.read<PlayerManager>().players;

    for (var player in players) {
      player.reset();
      player.addLife(3);
    }
  }

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
      // Record everything needed for undo before changing state
      _scoreHistory.add({
        'playerIndex': currentPlayerIndex,
        'scored': scored,
        'previousScoreToBeat': scoreToBeat,
        'previousLives': player.lives,
      });

      player.addScore(scored);
    });

    if (player.throwsThisTurn >= 3) {
      final total = player.throwsThisTurnScores.fold(0.0, (sum, s) => sum + s).toInt();

      // Check if player failed to beat score
      if (scoreToBeat > 0 && total < scoreToBeat) {
        player.removeLife(1);
      } else {
        scoreToBeat = total.toInt();
      }

      scoreText = '${player.name} scored $total';

      if (player.getLife() < 0) {
        // eliminate player
        scoreText = '${player.name} eliminated!';
      }

      player.resetThrows();
      player.resetTempScore();
      _nextPlayer(players);
    }

    List<Player> activePlayers = players.where((p) => p.lives >= 0).toList();

    if (activePlayers.length == 1) {
      final winner = activePlayers.first;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FinishPage(gameName: "Lives", winningPlayer: winner),
          ),
        );
      });

      return;
    }
  }

  void _nextPlayer(List<Player> players) {
    int nextIndex = currentPlayerIndex;
    do {
      nextIndex = (nextIndex + 1) % players.length;
    } while (players[nextIndex].lives < 0);

    nextPlayerIndex = nextIndex;

    setState(() {
      showNextPlayerOverlay = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        currentPlayerIndex = nextPlayerIndex!;
        showNextPlayerOverlay = false;
        nextPlayerIndex = null;
      });
    });
  }

  void undoLastScore(int _) {
    final players = context.read<PlayerManager>().players;

    if (_scoreHistory.isEmpty || showNextPlayerOverlay) {
      return;
    }

    setState(() {
      final lastThrow = _scoreHistory.removeLast();
      final playerIndex = lastThrow['playerIndex'] as int;
      final player = players[playerIndex];

      // Restore player's previous throw
      player.undoLastScore();

      // Restore lives and scoreToBeat
      scoreToBeat = lastThrow['previousScoreToBeat'] as int;
      player.lives = lastThrow['previousLives'] as int;

      scoreText = 'Score to beat: $scoreToBeat';

      currentPlayerIndex = playerIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColour = Colors.blue[100];
    final players = context.watch<PlayerManager>().players;

    String gameName = "Lives";

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
          gameName,
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
            players: players,
            currentPlayerIndex: currentPlayerIndex,
            onUndo: showNextPlayerOverlay ? null : undoLastScore,
            scoreText: scoreText,
            showNextPlayerOverlay: showNextPlayerOverlay,
            nextPlayer: nextPlayer,
            gameName: "lives",
          ),
        ],
      ),
    );
  }
}
