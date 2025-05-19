// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// game pages
import 'package:interactive_darts/pages/test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class GameCard extends StatelessWidget {
  final String gameName;
  final String amountOfPlayers;
  final String gameTime;
  final Widget gamePage;
  final String gameImage;
  // icon

  const GameCard({
    super.key,
    required this.gameName,
    required this.amountOfPlayers,
    required this.gameTime,
    required this.gamePage,
    required this.gameImage,
  });

  @override
  Widget build(BuildContext context) {
    // Game View
    double gameViewPadding = 0.02.sh;
    double gameNameFontSize = 0.045.sh;
    double gameDetailFontSize = 0.022.sh;
    double gameIconSize = 0.7.sw;
    Color? gameViewBackgroundColour = const Color.fromARGB(255, 54, 144, 180);

    // Game Details
    const Color? fontColour = Colors.black;

    return Container(
      decoration: BoxDecoration(color: gameViewBackgroundColour),
      child: Padding(
        padding: EdgeInsets.all(gameViewPadding),
        child: Column(
          children: [
            // Game Icon
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => gamePage),
                );
              },
              child: Image(
                height: gameIconSize,
                width: gameIconSize,
                image: AssetImage(gameImage),
                fit: BoxFit.cover
              ),
            ),

            // Game Details
            Column(
              children: [
                Text(
                  gameName,
                  style: TextStyle(
                      fontSize: gameNameFontSize,
                      fontWeight: FontWeight.bold,
                      color: fontColour),
                ),
                SizedBox(
                  width: gameIconSize,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people,
                          color: fontColour, size: gameDetailFontSize),
                      SizedBox(width: 5),
                      Text(amountOfPlayers,
                          style: TextStyle(
                              fontSize: gameDetailFontSize, color: fontColour)),
                      SizedBox(width: 20),
                      Icon(Icons.timer,
                          color: fontColour, size: gameDetailFontSize),
                      SizedBox(width: 5),
                      Text(
                        gameTime,
                        style: TextStyle(
                            fontSize: gameDetailFontSize, color: fontColour),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
    String gameOnePlayers = "Players 1-3";
    String gameOneTime = "15 - 20 mins";
    const String gameOneImage = testImage;
    Widget gameOnePage = TestPage();

    // Game 2
    // game two icon
    String gameTwoName = "Game Name";
    String gameTwoPlayers = "Players 1-3";
    String gameTwoTime = "15 - 20 mins";
    const String gameTwoImage = testImage;
    Widget gameTwoPage = TestPage();

    // Game 3
    // game three icon
    String gameThreeName = "Game Name";
    String gameThreePlayers = "Players 1-3";
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
                          amountOfPlayers: gameOnePlayers,
                          gameTime: gameOneTime,
                          gamePage: gameOnePage,
                          gameImage: gameOneImage,
                        ),

                        SizedBox(height: 15),

                        // 2nd Game
                        GameCard(
                          gameName: gameTwoName,
                          amountOfPlayers: gameTwoPlayers,
                          gameTime: gameTwoTime,
                          gamePage: gameTwoPage,
                          gameImage: gameTwoImage,
                        ),

                        SizedBox(height: 15),

                        // 3rd Game
                        GameCard(
                          gameName: gameThreeName,
                          amountOfPlayers: gameThreePlayers,
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
