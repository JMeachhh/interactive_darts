import 'package:flutter/material.dart';

class Game {
  final String name;
  final int maxPlayers;
  final Widget page;
  final String image;
  final String gameTime;

  Game({
    required this.name,
    required this.maxPlayers,
    required this.page,
    required this.image,
    required this.gameTime,
  });
}
