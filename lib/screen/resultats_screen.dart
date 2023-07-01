import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/player_provider.dart';

class ResultatsPage extends ConsumerWidget {
  const ResultatsPage( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Consumer(
      builder: (context, watch, _) {
        final player = ref.watch(playerProvider);
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.fromLTRB(20, 120, 20, 100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Résultats',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'La partie à duré : ${player.temps}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Difficulté : ${player.difficulte.name}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Joueur : ${player.name}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 50),
                          textStyle: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        child: const Text('Retour'),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 50),
                          textStyle: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        child: const Text('Accueil'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
