import 'package:demineur/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scoreBoardProvider = ChangeNotifierProvider((ref) => ScoreBoard());

class ScoreBoard extends ChangeNotifier {
  final List<Player> _players = [];

  List<Player> get players => _players;

  void addPlayer(Player player) {
    // Create a new instance of Player using the provided player's properties
    final newPlayer = Player();
    newPlayer.changeName(player.name);
    newPlayer.changeDifficulte(player.difficulte);
    newPlayer.changeTemps(player.temps);
    _players.add(newPlayer);
    notifyListeners();
  }
}
