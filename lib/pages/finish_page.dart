import 'package:flutter/material.dart';
import 'package:interactive_darts/Assets/player.dart';

class FinishPage extends StatelessWidget {
  final String gameName;
  final Player winningPlayer;
  const FinishPage(
      {required this.gameName, required this.winningPlayer, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Well done ${winningPlayer.name} for winning $gameName",
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
