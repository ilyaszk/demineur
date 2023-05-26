import 'package:demineur/lib/start_screen.dart';
import 'package:flutter/material.dart';

import 'demineur_screen.dart';

// Widget principal qui gère l'état de toute l'application
// et affiche soit StartScreen, soit QuestionsScreen, soit ResultsScreen
class Demineur extends StatefulWidget {
  // Contructeur
  const Demineur({super.key});

  // Instanciation de l'état _DemineurState associé au widget Demineur
  @override
  State<Demineur> createState() {
    return _DemineurState();
  }
}

// Les différents types de Screen à afficher
enum ScreenState { start, demineur}

// L'état associé au widget Demineur
class _DemineurState extends State<Demineur> {
  // Les questions du Demineur
  // Pour savoir quel widget afficher
  ScreenState screenState = ScreenState.start;

  // Méthode appelée depuis StartScreen pour "naviguer" vers QuestionsScreen
  void startDemineur() {
    setState(() {
      screenState = ScreenState.demineur; // on va afficher QuestionScreen
    });
  }

  // Méthode appelée depuis ResultsScreen pour "naviguer" vers StartScreen
  void reStartDemineur() {
    setState(() {
      screenState = ScreenState.start; // On va afficher StartScreen
    });
  }

  // Retourne le widget à afficher selon l'état (valeur de screenState)
  Widget chooseScreenWidget() {
    switch (screenState) {
      case ScreenState.start:
        {
          return StartScreen(startDemineur);
        }
      case ScreenState.demineur:
        {
          return DemineurScreen(
            10,
            10,
            reStartDemineur,
          );
        }
    }
  }

  // Construction de l'UI du Widget Demineur
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(139, 78, 13, 151),
                Color.fromARGB(81, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: chooseScreenWidget(),
        ),
      ),
    );
  }
}
