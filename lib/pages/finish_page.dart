import 'dart:io';
import 'package:flutter/material.dart';
import 'package:interactive_darts/Assets/player.dart';

class FinishPage extends StatelessWidget {
  final String gameName;
  final Player winningPlayer;
  const FinishPage(
      {required this.gameName, required this.winningPlayer, super.key});

  @override
  Widget build(BuildContext context) {
    final ImageProvider avatarImage = winningPlayer.imagePath.startsWith('/')
        ? FileImage(File(winningPlayer.imagePath))
        : AssetImage(winningPlayer.imagePath) as ImageProvider;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: avatarImage,
              backgroundColor: Colors.grey.shade200,
              onBackgroundImageError: (_, __) {
                debugPrint('Failed to load: ${winningPlayer.imagePath}');
              },
            ),
            const SizedBox(height: 20),
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
