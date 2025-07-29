import 'package:flutter/material.dart';

class KillerGamePage extends StatelessWidget {
  const KillerGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Killer Game Page"),
      ),
      body: const Center(
        child: Text(
          "Welcome to a killer game!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}