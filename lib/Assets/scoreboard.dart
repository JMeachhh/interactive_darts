import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interactive_darts/Assets/player.dart';

class Scoreboard extends StatelessWidget {
  final List<Player> players;
  final String gameName;
  final int currentPlayerIndex;
  final void Function(int playerIndex)? onUndo;
  final String scoreText;
  final bool showNextPlayerOverlay;
  final Player? nextPlayer;
  final bool showKillerOverlay;
  final Player? killerPlayer;

  const Scoreboard({
    super.key,
    required this.players,
    required this.currentPlayerIndex,
    this.onUndo,
    this.scoreText = '',
    this.showNextPlayerOverlay = false,
    this.nextPlayer,
    required this.gameName,
    this.showKillerOverlay = false, // new
    this.killerPlayer, // new
  });

  Widget _buildThrowSquares(List<double> scores, {int? lives}) {
    if (gameName.toLowerCase() == "classic") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final hasScore = index < scores.length;
          return Container(
            width: 0.06.sh,
            height: 0.06.sh,
            margin: EdgeInsets.symmetric(horizontal: 0.008.sw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.01.sh),
              border: Border.all(color: Colors.blue.shade300, width: 1.5),
              color: hasScore ? Colors.blue.shade100 : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: hasScore
                ? Text(
                    scores[index].abs().toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 0.022.sh,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  )
                : null,
          );
        }),
      );
    } else if (gameName.toLowerCase() == "killer") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final hasLife = (lives ?? 0) > index;
          return Container(
            width: 0.06.sh,
            height: 0.06.sh,
            margin: EdgeInsets.symmetric(horizontal: 0.008.sw),
            child: hasLife
                ? Image.asset(
                    'images/life_killer.jpg',
                    fit: BoxFit.contain,
                  )
                : const SizedBox.shrink(),
          );
        }),
      );
    } else if (gameName.toLowerCase() == "lives") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final hasLife = (lives ?? 0) > index;
          return Container(
            width: 0.06.sh,
            height: 0.06.sh,
            margin: EdgeInsets.symmetric(horizontal: 0.008.sw),
            child: hasLife
                ? Image.asset(
                    'images/life_lives.jpg',
                    fit: BoxFit.contain,
                  )
                : const SizedBox.shrink(),
          );
        }),
      );
    } else {
      // Default for other games without lives
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final hasScore = index < scores.length;
          return Container(
            width: 0.06.sh,
            height: 0.06.sh,
            margin: EdgeInsets.symmetric(horizontal: 0.008.sw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.01.sh),
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
              color: hasScore ? Colors.grey.shade200 : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: hasScore
                ? Text(
                    scores[index].abs().toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 0.022.sh,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = gameName.toLowerCase();
    bool usesLives = false;
    final currentPlayer = players[currentPlayerIndex];

    var nextPlayers = [];

    // Filter next players
    switch (name) {
      case "killer":
        nextPlayers = [
          ...players.sublist(currentPlayerIndex + 1),
          ...players.sublist(0, currentPlayerIndex),
        ].where((p) => p.lives >= 0).toList();
        usesLives = true;
        break;
      case "lives":
        nextPlayers = [
          ...players.sublist(currentPlayerIndex + 1),
          ...players.sublist(0, currentPlayerIndex),
        ].where((p) => p.lives > 0).toList();
        usesLives = true;
        break;
      default:
        nextPlayers = [
          ...players.sublist(currentPlayerIndex + 1),
          ...players.sublist(0, currentPlayerIndex),
        ];
    }

    final currentImageProvider = currentPlayer.imagePath.startsWith('/')
        ? FileImage(File(currentPlayer.imagePath))
        : AssetImage(currentPlayer.imagePath) as ImageProvider;

    Widget scoreTextWidget = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.01.sh),
      child: Text(
        scoreText,
        style: TextStyle(fontSize: 0.022.sh, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );

    // Next Player Overlay
    Widget nextPlayerOverlay = (showNextPlayerOverlay && nextPlayer != null)
        ? Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Next Player",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: nextPlayer!.imagePath.startsWith('/')
                          ? FileImage(File(nextPlayer!.imagePath))
                          : AssetImage(nextPlayer!.imagePath)
                              as ImageProvider<Object>,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nextPlayer!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();

    // Killer Overlay
    Widget killerOverlay = (showKillerOverlay && killerPlayer != null)
        ? Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "New Killer!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: killerPlayer!.imagePath.startsWith('/')
                          ? FileImage(File(killerPlayer!.imagePath))
                          : AssetImage(killerPlayer!.imagePath)
                              as ImageProvider<Object>,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      killerPlayer!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();

    return Stack(
      children: [
        Column(
          children: [
            scoreTextWidget,
            Container(
              height: 0.32.sh,
              width: 0.9.sw,
              child: Row(
                children: [
                  // Current player card
                  Expanded(
                    flex: 3,
                    child: (!usesLives || currentPlayer.lives >= 0)
                        ? Card(
                            color: Colors.blue.shade50,
                            elevation: 0.01.sw,
                            margin: EdgeInsets.all(0.01.sw),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.02.sh),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(0.01.sh),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 0.13.sw,
                                    backgroundImage: currentImageProvider,
                                  ),
                                  SizedBox(height: 0.01.sh),
                                  Text(
                                    currentPlayer.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 0.03.sh,
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 0.005.sh),
                                  if (!usesLives)
                                    Text(
                                      'Scores: ${currentPlayer.score.abs().toStringAsFixed(0)}',
                                      style: TextStyle(fontSize: 0.025.sh),
                                    )
                                  else
                                    Text(
                                      'Turns: ${3 - currentPlayer.throwsThisTurn}',
                                      style: TextStyle(fontSize: 0.018.sh),
                                    ),
                                  _buildThrowSquares(
                                    currentPlayer.throwsThisTurnScores,
                                    lives:
                                        usesLives ? currentPlayer.lives : null,
                                  ),
                                  SizedBox(height: 0.005.sh),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              'Eliminated',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),

                  // Next players + Undo
                  SizedBox(width: 0.02.sw),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: nextPlayers.map((player) {
                                final imageProvider =
                                    player.imagePath.startsWith('/')
                                        ? FileImage(File(player.imagePath))
                                        : AssetImage(player.imagePath)
                                            as ImageProvider;

                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.007.sh),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 0.05.sw,
                                        backgroundImage: imageProvider,
                                      ),
                                      SizedBox(width: 0.02.sw),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              player.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 0.022.sh,
                                              ),
                                            ),
                                            if (!usesLives)
                                              Text(
                                                'Score: ${player.score.abs().toStringAsFixed(0)}',
                                                style: TextStyle(
                                                    fontSize: 0.018.sh),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        if (onUndo != null)
                          Padding(
                            padding: EdgeInsets.only(top: 0.01.sh),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => onUndo!(currentPlayerIndex),
                                child: const Text('Undo Throw'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Overlays
        nextPlayerOverlay,
        killerOverlay,
      ],
    );
  }
}
