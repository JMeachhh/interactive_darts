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

class KillerGamePage extends StatefulWidget {
  const KillerGamePage({super.key});

  @override
  State<KillerGamePage> createState() => _KillerGamePageState();
}

class _KillerGamePageState extends State<KillerGamePage> {
  final dartBoardKey = GlobalKey<DartBoardState>();

  int currentPlayerIndex = 0;
  bool showNextPlayerOverlay = false;
  int? nextPlayerIndex;
  String scoreText = 'No score yet';

  Player? killerPlayer;

  bool showKillerOverlay = false;

  bool newKiller = false;

  final List<Map<String, dynamic>> _scoreHistory = [];

  late List<Map<String, dynamic>> playerSegments;

  @override
  void initState() {
    super.initState();

    final players = context.read<PlayerManager>().players;
    final random = Random();
    for (var player in players) {
      player.reset();
    }

    final colors = [
      Colors.red,
      Colors.deepPurple,
      Colors.blue,
      Colors.yellow,
      Colors.purple[200],
      Colors.orange,
      Colors.green[900],
      Colors.greenAccent[400],
    ];

    final availableSegments = List.generate(20, (index) => index + 1);

    playerSegments = List.generate(players.length, (_) {
      final segmentIndex = random.nextInt(availableSegments.length);
      int segmentNumber = availableSegments.removeAt(segmentIndex);
      Color? colour = colors[random.nextInt(colors.length)];
      return {
        'number': segmentNumber,
        'colour': colour,
      };
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      highlightTargets();
    });
  }

  void highlightTargets() {
    final players = context.read<PlayerManager>().players;
    final updates = <Map<String, dynamic>>[];

    if (players.isEmpty) return;

    final currentPlayer = players[currentPlayerIndex];

    if (currentPlayer.getLife() == 3) {
      // Highlight all other players' segments
      for (int i = 0; i < playerSegments.length; i++) {
        if (i == currentPlayerIndex) continue;
        final segment = playerSegments[i];
        if (segment['number'] > 0) {
          updates.add({
            'number': segment['number'],
            'colour': segment['colour'],
          });
        }
      }
    } else {
      // Highlight only current player's segment
      final segment = playerSegments[currentPlayerIndex];
      updates.add({
        'number': segment['number'],
        'colour': segment['colour'],
      });
    }

    dartBoardKey.currentState?.resetBoard();
    dartBoardKey.currentState?.changeColours(updates);
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
        final nextPlayer = players[currentPlayerIndex];

        if (nextPlayer.getLife() == 3) {
          scoreText = "${nextPlayer.name}'s turn (Killer)";
        } else {
          scoreText = "${nextPlayer.name}'s turn";
        }

        showNextPlayerOverlay = false;
        nextPlayerIndex = null;
        highlightTargets();
      });
    });
  }

  void onScoreUpdate(int segment, String ringName) {
    int multiplier = switch (ringName) {
      'bull' => 3,
      'double' => 2,
      'triple' => 3,
      _ => 1,
    };

    final players = context.read<PlayerManager>().players;
    if (players.isEmpty) return;

    final player = players[currentPlayerIndex];

    if (player.getLife() == 3) {
    } else {}

    int previousLives = player.getLife();

    player.addThrow();

    setState(() {
      // Hitting own target
      if (segment == playerSegments[currentPlayerIndex]['number'] ||
          segment == 25 ||
          segment == 50) {
        player.addLife(multiplier);

        if (previousLives < 3 && player.getLife() == 3) {
          setState(() {
            showKillerOverlay = true;
            killerPlayer = player; 
          });

          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              scoreText = "${player.name} is a killer!";
              showKillerOverlay = false;
              killerPlayer = null; 
            });
          });
        } else {
          scoreText = '${player.name} gained a life!';
        }
      } else {
        bool hit = false;
        // If Killer
        if (player.getLife() == 3) {
          // Check if hit other
          for (int i = 0; i < playerSegments.length; i++) {
            if (playerSegments[i]['number'] == segment) {
              hit = true;
              scoreText = '${player.name} hit ${players[i].name}!';

              // Take off apropriate lives
              players[i].removeLife(multiplier);

              if (players[i].getLife() < 0) {
                // eliminate player and remove segment
                scoreText = '${players[i].name} elimintated!';
                playerSegments[i]['number'] = -1;
              }
            }
          }

          if (!hit) {
            scoreText = '${player.name} missed!';
          }
        } else {
          scoreText =
              '${player.name} missed! Their segment is ${playerSegments[currentPlayerIndex]['number']}';
        }
      }

      List<Player> activePlayers = players.where((p) => p.lives >= 0).toList();

      if (activePlayers.length == 1) {
        final winner = activePlayers.first;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FinishPage(gameName: "Killer", winningPlayer: winner),
            ),
          );
        });

        return;
      }
    });

    setState(() {
      _scoreHistory.add({
        'playerIndex': currentPlayerIndex,
        'playerLives': players.map((p) => p.lives).toList(),
        'playerSegments': playerSegments
            .map((segment) => Map<String, dynamic>.from(segment))
            .toList(),
        'scoreText': scoreText,
      });
    });

    if (player.throwsThisTurn >= 3) {
      player.resetThrows();
      _nextPlayer(players);
    }

    highlightTargets();
  }

  void undoLastScore(int _) {
    final players = context.read<PlayerManager>().players;

    if (_scoreHistory.isEmpty || showNextPlayerOverlay) {
      setState(() {
        scoreText = 'No Score to Undo';
      });
      return;
    }

    final lastTurn = _scoreHistory.removeLast();

    setState(() {
      currentPlayerIndex = lastTurn['playerIndex'] as int;

      // Restore lives
      final savedLives = List<int>.from(lastTurn['playerLives']);
      for (int i = 0; i < players.length; i++) {
        players[i].lives = savedLives[i];
      }

      // Restore segments
      playerSegments = (lastTurn['playerSegments'] as List)
          .map((segment) => Map<String, dynamic>.from(segment))
          .toList();

      scoreText = lastTurn['scoreText'] as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColour = Colors.blue[100];
    final players = context.watch<PlayerManager>().players;

    String gameName = "Killer";

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
            key: dartBoardKey,
            type: 'normal',
            onScoreChanged: (segment, ring) {
              if (!showNextPlayerOverlay) {
                onScoreUpdate(segment, ring);
              }
            },
          ),
          const SizedBox(height: 16),
          Scoreboard(
            gameName: "killer",
            players: players,
            currentPlayerIndex: currentPlayerIndex,
            onUndo: showNextPlayerOverlay ? null : undoLastScore,
            scoreText: scoreText,
            showNextPlayerOverlay: showNextPlayerOverlay,
            showKillerOverlay: showKillerOverlay,
            nextPlayer: nextPlayer,
            killerPlayer: killerPlayer,
          ),
        ],
      ),
    );
  }
}
