import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'player.dart';

class PlayerManager extends ChangeNotifier {
  List<Player> _players = [];

  List<Player> get players => _players;

  PlayerManager() {
    loadPlayers();
  }

  void addPlayer(Player player) {
    _players.add(player);
    savePlayers();
    notifyListeners();
  }

  void savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playerJsonList = _players.map((p) => jsonEncode(p.toJson())).toList();
    prefs.setStringList('players', playerJsonList);
  }

  void loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playerJsonList = prefs.getStringList('players') ?? [];
    final uuid = Uuid();

    _players = playerJsonList.map((jsonStr) {
      final data = jsonDecode(jsonStr);

      // Assign a new UUID if missing
      if (data['id'] == null) {
        data['id'] = uuid.v4();
      }

      return Player.fromJson(data);
    }).toList();

    savePlayers();

    notifyListeners();
  }

  void updatePlayer(Player updatedPlayer) {
    final index = _players.indexWhere((p) => p.id == updatedPlayer.id);
    if (index != -1) {
      _players[index] = updatedPlayer;
      savePlayers(); // persist to shared_preferences
      notifyListeners();
    }
  }

  void removePlayer(Player player) {
  _players.removeWhere((p) => p.id == player.id);
  savePlayers();
  notifyListeners();
}
}
