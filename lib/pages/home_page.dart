// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// assets
import 'package:interactive_darts/Assets/game_card.dart';
import 'package:interactive_darts/Assets/games_manager.dart';

// game pages
import 'package:interactive_darts/pages/test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // General
    Color? backgroundColour = Color.fromARGB(255, 140, 199, 223);
    Color? chooseGameMenuColour = Colors.red[300];

    final games = GamesManager().getGames();

    return Scaffold(
      backgroundColor: backgroundColour,
      body: Padding(
        padding: EdgeInsets.only(left: 0.05.sw, top: 0.25.sh),
        child: Container(
            height: 0.72.sh,
            width: 0.9.sw,
            decoration: BoxDecoration(
                color: chooseGameMenuColour,
                borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(0.03.sw),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Title
              const Text("Choose Your Game!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),

              // Games View
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        for (var game in games)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: GameCard(
                              gameName: game.name,
                              maxAmountOfPlayers: game.maxPlayers,
                              gameTime: game.gameTime,
                              gamePage: game.page,
                              gameImage: game.image,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}
