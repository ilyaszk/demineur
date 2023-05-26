import 'package:flutter/material.dart';

import 'modele.dart';

class StartScreen extends StatelessWidget {
  // La fonction du Widget Quiz à appeler pour naviguer vers QuestionScreen

  final Function(Difficulte) startDemineur;
  const StartScreen(this.startDemineur, {Key? key}) : super(key: key);

  // Construction de l'UI du Widget StartScreen
  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo-app.png',
            width: 300,
          ),
          const SizedBox(height: 80),
          const Text(
            'Demineur',
            style: TextStyle(
              color: Color.fromARGB(255, 237, 223, 252),
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () => startDemineur(Difficulte.facile),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_right_alt),
                label: const Text('Facile 💣'),
              ),
              const SizedBox(width: 20),
              OutlinedButton.icon(
                onPressed: () => startDemineur(Difficulte.moyen),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_right_alt),
                label: const Text('Moyen 💣💣'),
              ),
              const SizedBox(width: 20),
              OutlinedButton.icon(
                onPressed: () => startDemineur(Difficulte.difficile),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),

                icon: const Icon(Icons.arrow_right_alt),
                label: const Text('Difficile 💣💣💣'),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
