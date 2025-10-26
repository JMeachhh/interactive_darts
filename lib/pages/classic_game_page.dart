import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interactive_darts/Assets/player.dart';
import 'package:interactive_darts/pages/finish_page.dart';
import 'package:provider/provider.dart';
import 'package:interactive_darts/Assets/dart_board.dart';
import 'package:interactive_darts/Assets/scoreboard.dart';
import 'package:interactive_darts/Assets/player_manager.dart';

class ClassicGamePage extends StatefulWidget {
  const ClassicGamePage({super.key});

  @override
  State<ClassicGamePage> createState() => _ClassicGamePageState();
}

class _ClassicGamePageState extends State<ClassicGamePage> {
  int currentPlayerIndex = 0;
  String scoreText = 'No score yet';
  bool showNextPlayerOverlay = false;
  int? nextPlayerIndex;

  int targetScore = 501;
  bool doubleOut = false;
  bool configDone = false;

  final List<Map<String, dynamic>> _scoreHistory = [];

  @override
  void initState() {
    super.initState();

    final players = context.read<PlayerManager>().players;
    for (var player in players) {
      player.reset();
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!configDone) {
        showGameSetup();
      }
    });
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
    double newScore = player.score - scored;

    // Prevent score from going below zero
    if (newScore < 0) {
      setState(() {
        scoreText = '${player.name} bust! Turn skipped.';
        player.resetThrows();
        _nextPlayer(players);
      });
      return;
    }

    // Double-out logic
    bool isWinningThrow = newScore == 0;
    bool isDoubleFinish = (ring == 'double');

    if (isWinningThrow) {
      if (doubleOut && !isDoubleFinish) {
        setState(() {
          scoreText = '${player.name} bust! Must finish on a double.';
          player.resetThrows();
          _nextPlayer(players);
        });
        return;
      }

      // Player wins
      setState(() {
        player.addScore(-scored);
        scoreText = '${player.name} wins the game!';
        showNextPlayerOverlay = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FinishPage(gameName: "Classic Game", winningPlayer: player),
          ),
        );
      });

      return;
    }

    setState(() {
      player.addScore(-scored);
      scoreText = '${player.name} scored $scored';

      _scoreHistory.add({
        'playerIndex': currentPlayerIndex,
        'score': player.score,
        'throw': scored,
      });
    });

    if (player.throwsThisTurn >= 3) {
      player.resetThrows();
      _nextPlayer(players);
    }
  }

  void _nextPlayer(List<Player> players) {
    nextPlayerIndex = (currentPlayerIndex + 1) % players.length;

    setState(() {
      showNextPlayerOverlay = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        currentPlayerIndex = nextPlayerIndex!;
        scoreText = "${players[currentPlayerIndex].name}'s turn";
        showNextPlayerOverlay = false;
        nextPlayerIndex = null;
      });
    });
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

  void showGameSetup() {
    int tempTargetScore = targetScore;
    bool tempDoubleOut = doubleOut;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Choose Game Settings"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: tempTargetScore,
                    items: const [
                      DropdownMenuItem(value: 301, child: Text("301")),
                      DropdownMenuItem(value: 501, child: Text("501")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => tempTargetScore = value);
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Double Finish"),
                      Switch(
                        value: tempDoubleOut,
                        onChanged: (value) {
                          setDialogState(() => tempDoubleOut = value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      targetScore = tempTargetScore;
                      doubleOut = tempDoubleOut;
                      configDone = true;

                      final players = context.read<PlayerManager>().players;
                      for (var player in players) {
                        player.score = targetScore.toDouble();
                        player.clearScoreHistory();
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Start Game"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColour = Colors.blue[100];
    final players = context.watch<PlayerManager>().players;

    String gameName = "Classic";

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
            gameName: "classic",
          ),
        ],
      ),
    );
  }
}
