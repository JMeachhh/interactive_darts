// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// assets
import 'package:interactive_darts/Assets/game_card.dart';

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

    const String testImage = 'images/placeholder.jpg';

    // Game 1
    String gameOneName = "Game Name";
    int gameOnePlayers = 3;
    String gameOneTime = "15 - 20 mins";
    const String gameOneImage = testImage;
    Widget gameOnePage = TestPage();

    // Game 2
    String gameTwoName = "Game Name";
    int gameTwoPlayers = 6;
    String gameTwoTime = "15 - 20 mins";
    const String gameTwoImage = testImage;
    Widget gameTwoPage = TestPage();

    // Game 3
    String gameThreeName = "Game Name";
    int gameThreePlayers = 2;
    String gameThreeTime = "15 - 20 mins";
    const String gameThreeImage = testImage;
    Widget gameThreePage = TestPage();

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
                        // 1st Game
                        GameCard(
                          gameName: gameOneName,
                          maxAmountOfPlayers: gameOnePlayers,
                          gameTime: gameOneTime,
                          gamePage: gameOnePage,
                          gameImage: gameOneImage,
                        ),

                        SizedBox(height: 15),

                        // 2nd Game
                        GameCard(
                          gameName: gameTwoName,
                          maxAmountOfPlayers: gameTwoPlayers,
                          gameTime: gameTwoTime,
                          gamePage: gameTwoPage,
                          gameImage: gameTwoImage,
                        ),

                        SizedBox(height: 15),

                        // 3rd Game
                        GameCard(
                          gameName: gameThreeName,
                          maxAmountOfPlayers: gameThreePlayers,
                          gameTime: gameThreeTime,
                          gamePage: gameThreePage,
                          gameImage: gameThreeImage,
                        )
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
