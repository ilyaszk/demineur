import 'dart:async';

import 'package:demineur/screen/resultats_screen.dart';
import 'package:flutter/material.dart';
import 'package:demineur/screen/modele.dart' as modele;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/player_provider.dart';
import 'modele.dart';

class DemineurScreen extends ConsumerStatefulWidget {
  const DemineurScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DemineurScreenState();
  }
}

class _DemineurScreenState extends ConsumerState<DemineurScreen> {
  late modele.Grille _grille;
  late int taille;
  late int nbMines;
  late Difficulte difficulte;
  // Initialize an instance of Stopwatch
  final Stopwatch _stopwatch = Stopwatch();
  // Timer
  late Timer _timer;
  String _result = '00:00:00';

  final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      background: const Color.fromARGB(255, 203, 151, 151),
      seedColor: const Color.fromARGB(255, 100, 52, 63),
    ),
    textTheme: GoogleFonts.latoTextTheme(),
  );

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      // Update the UI
      setState(() {
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });
    _stopwatch.start();
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
  }

  @override
  void initState() {
    super.initState();
    difficulte = ref.read(playerProvider).difficulte;
    taille = getTailleFromDifficulte(difficulte);
    nbMines = getNbMinesFromDifficulte(difficulte);
    _grille = modele.Grille(taille, nbMines);
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '💣: $nbMines',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Text(
                '🕰️: $_result',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // Adjust the height as per your requirement
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              itemCount: taille * taille,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: taille,
              ),
              itemBuilder: (BuildContext context, int index) {
                int ligne = index ~/ taille;
                int colonne = index % taille;
                modele.Coordonnees coord = modele.Coordonnees(ligne, colonne);
                modele.Case caseActuelle = _grille.getCase(coord);
                if (_grille.isFinie()) {
                  caseActuelle.decouverte = true; // Reveal all cases
                  _stop();
                }
                return Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (!_grille.isPerdue()) {
                          modele.Coup coup = modele.Coup(
                              ligne, colonne, modele.Action.decouvrir);
                          _grille.mettreAJour(coup);
                        } else {
                          null;
                        }
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        if (!_grille.isPerdue()) {
                          caseActuelle.marquee = !caseActuelle.marquee;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        color: _grille.caseToColor(caseActuelle),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        caseActuelle.decouverte
                            ? _grille.caseToText(caseActuelle)
                            : '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            _grille.isGagnee()
                ? 'You won! ✌️'
                : _grille.isPerdue()
                    ? 'You lost! 💣'
                    : '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
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
            if (_grille.isFinie())
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(playerProvider.notifier).changeTemps(
                        _result); // Change the time in the playerProvider
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultatsPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  child: const Text('Résultat'),
                ),
              ),
          ])
        ],
      ),
    );
  }
}
