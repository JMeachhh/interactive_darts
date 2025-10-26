import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:interactive_darts/pages/player_page.dart';

class GameCard extends StatelessWidget {
  final String gameName;
  final int maxAmountOfPlayers;
  final String gameTime;
  final Widget gamePage;
  final String gameImage;
  // icon

  const GameCard({
    super.key,
    required this.gameName,
    required this.maxAmountOfPlayers,
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
                  MaterialPageRoute(
                      builder: (context) => PlayerPage(
                            gamePageWidget: gamePage,
                            maxAmountOfPlayers: maxAmountOfPlayers,
                            gameName: gameName,
                          )),
                );
              },
              child: Image(
                  height: gameIconSize,
                  width: gameIconSize,
                  image: AssetImage(gameImage),
                  fit: BoxFit.cover),
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
                      SizedBox(width: 2),
                      Flexible(
                        child: Text("Players 1 - $maxAmountOfPlayers",
                            style: TextStyle(
                                fontSize: gameDetailFontSize,
                                color: fontColour)),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.timer,
                          color: fontColour, size: gameDetailFontSize),
                      SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          gameTime,
                          style: TextStyle(
                              fontSize: gameDetailFontSize, color: fontColour),
                        ),
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
