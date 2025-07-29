import 'package:interactive_darts/Assets/game.dart';
import 'package:interactive_darts/pages/classic_game_page.dart';
import 'package:interactive_darts/pages/killer_game_page.dart';
import 'package:interactive_darts/pages/lives_game_page.dart';

class GamesManager {
  late final Game classic;
  late final Game killer;
  late final Game lives;
  late final List<Game> games;

  GamesManager() {
    classic = Game(
        name: "Classic Game",
        maxPlayers: 8,
        page: ClassicGamePage(),
        image: "images/classic_game.jpg",
        gameTime: "15 - 20 mins");
    killer = Game(
        name: "Killer",
        maxPlayers: 8,
        page: KillerGamePage(),
        image: "images/killer.jpg",
        gameTime: "15 - 20 mins");
    lives = Game(
        name: "Lives",
        maxPlayers: 8,
        page: LivesGamePage(),
        image: "images/lives.jpg",
        gameTime: "15 - 20 mins");

    games = [classic, killer, lives];
  }

  List<Game> getGames() {
    return games;
  }
}
