import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interactive_darts/Assets/player_card.dart';
import 'package:interactive_darts/Assets/player_manager.dart';
import 'package:provider/provider.dart';

// Game Pages
import 'package:interactive_darts/pages/test_page.dart';

// Assets
import 'package:interactive_darts/Assets/player.dart';

class PlayerPage extends StatelessWidget {
  final Widget gamePageWidget;
  final int maxAmountOfPlayers;

  const PlayerPage({
    super.key,
    required this.gamePageWidget,
    required this.maxAmountOfPlayers,
  });

  @override
  Widget build(BuildContext context) {
    final players = context.watch<PlayerManager>().players;

    Color? backgroundColour = const Color.fromARGB(255, 104, 104, 104);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColour,
      ),
      backgroundColor: backgroundColour,
      body: Padding(
        padding: EdgeInsets.only(left: 0.05.sw),
        child: Container(
          height: 0.88.sh,
          width: 0.9.sw,
          color: const Color.fromARGB(255, 196, 196, 196),
          child: Column(
            children: [
              // Choose Players Text
              Padding(
                padding: EdgeInsets.only(top: 0.01.sh),
                child: Text(
                  "Choose Your Players",
                  style:
                      TextStyle(fontSize: 0.04.sh, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 15),

              // Player Adding
              Expanded(
                child: ListView.builder(
                  itemCount: maxAmountOfPlayers,
                  itemBuilder: (context, index) {
                    final player =
                        index < players.length ? players[index] : null;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 0.02.sh),
                      child: PlayerCard(player: player),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
