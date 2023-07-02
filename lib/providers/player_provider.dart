import 'package:demineur/screen/modele.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerProvider = ChangeNotifierProvider((ref) => Player());

class Player extends ChangeNotifier {
  String _name = 'Mon joueur';
  Difficulte _difficulte = Difficulte.facile;
  String _temps = '00:00:00';

  String get name => _name;

  Difficulte get difficulte => _difficulte;

  String get temps => _temps;


  void changeName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void changeDifficulte(Difficulte newDifficulte) {
    _difficulte = newDifficulte;
    notifyListeners();
  }

  void changeTemps(String newTemps) {
    _temps = newTemps;
    notifyListeners();
  }
}
