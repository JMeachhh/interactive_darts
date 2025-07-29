import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interactive_darts/Assets/player.dart';

class Scoreboard extends StatelessWidget {
  final List<Player> players;
  final int currentPlayerIndex;
  final void Function(int playerIndex)? onUndo;
  final String scoreText;
  final bool showNextPlayerOverlay;
  final Player? nextPlayer;

  const Scoreboard({
    super.key,
    required this.players,
    required this.currentPlayerIndex,
    this.onUndo,
    this.scoreText = '',
    this.showNextPlayerOverlay = false,
    this.nextPlayer,
  });

  Widget _buildThrowSquares(List<double> scores) {
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
            border: Border.all(
              color: Colors.blue.shade300,
              width: 1.5,
            ),
            color: hasScore ? Colors.blue.shade100 : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: hasScore
              ? Text(
                  scores[index].toStringAsFixed(0),
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
  }

  @override
  Widget build(BuildContext context) {
    final currentPlayer = players[currentPlayerIndex];
    final nextPlayers = [
      ...players.sublist(currentPlayerIndex + 1),
      ...players.sublist(0, currentPlayerIndex),
    ];

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

    Widget nextPlayerOverlay = (showNextPlayerOverlay && nextPlayer != null)
        ? Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Next Player',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        nextPlayer!.name,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: nextPlayer!.imagePath.startsWith('/')
                            ? FileImage(File(nextPlayer!.imagePath))
                            : AssetImage(nextPlayer!.imagePath)
                                as ImageProvider<Object>,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ],
                  ),
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
                    child: Card(
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
                              onBackgroundImageError: (_, __) {
                                debugPrint('Failed to load: ${currentPlayer.imagePath}');
                              },
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
                            Text(
                              'Score: ${currentPlayer.score.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 0.025.sh),
                            ),
                            _buildThrowSquares(currentPlayer.throwsThisTurnScores),
                            SizedBox(height: 0.005.sh),
                          ],
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
                        // Scrollable list of next players
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: nextPlayers.map((player) {
                                final imageProvider = player.imagePath.startsWith('/')
                                    ? FileImage(File(player.imagePath))
                                    : AssetImage(player.imagePath) as ImageProvider;

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 0.007.sh),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 0.05.sw,
                                        backgroundImage: imageProvider,
                                        onBackgroundImageError: (_, __) {
                                          debugPrint('Failed to load: ${player.imagePath}');
                                        },
                                      ),
                                      SizedBox(width: 0.02.sw),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              player.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 0.022.sh,
                                              ),
                                            ),
                                            Text(
                                              'Score: ${player.score.toStringAsFixed(0)}',
                                              style: TextStyle(fontSize: 0.018.sh),
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

                        // Undo button
                        if (onUndo != null)
                          Padding(
                            padding: EdgeInsets.only(top: 0.01.sh),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => onUndo!(currentPlayerIndex),
                                child: const Text('Undo Score'),
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
        nextPlayerOverlay,
      ],
    );
  }
}
