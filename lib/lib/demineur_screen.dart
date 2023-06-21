import 'dart:async';

import 'package:demineur/lib/resultats_screen.dart';
import 'package:flutter/material.dart';
import 'package:demineur/lib/modele.dart' as modele;
import 'package:google_fonts/google_fonts.dart';

import 'modele.dart';

class DemineurScreen extends StatefulWidget {
  late final int taille;
  late final int nbMines;

  // final Duration timer;

  final String _userName;

  late final Difficulte _difficulte;

  DemineurScreen(this._userName, this._difficulte, {super.key}) {
    taille = getTailleFromDifficulte(_difficulte);
    nbMines = getNbMinesFromDifficulte(_difficulte);
  }

  int getTailleFromDifficulte(Difficulte difficulte) {
    switch (difficulte) {
      case Difficulte.facile:
        return 5;
      case Difficulte.moyen:
        return 10;
      case Difficulte.difficile:
        return 15;
      default:
        return 8;
    }
  }

  int getNbMinesFromDifficulte(Difficulte difficulte) {
    switch (difficulte) {
      case Difficulte.facile:
        return 5;
      case Difficulte.moyen:
        return 15;
      case Difficulte.difficile:
        return 30;
      default:
        return 10;
    }
  }

  @override
  State<StatefulWidget> createState() => _DemineurScreenState();
}

class _DemineurScreenState extends State<DemineurScreen> {
  late modele.Grille _grille;

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
    // Timer.periodic() will call the callback function every 100 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      // Update the UI
      setState(() {
        // result in hh:mm:ss format
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });
    // Start the stopwatch
    _stopwatch.start();
  }

  // This function will be called when the user presses the Stop button
  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
  }

  // This function will be called when the user presses the Reset button

  @override
  void initState() {
    super.initState();
    _grille = modele.Grille(widget.taille, widget.nbMines);
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
                '💣: ${widget.nbMines}',
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
              itemCount: widget.taille * widget.taille,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.taille,
              ),
              itemBuilder: (BuildContext context, int index) {
                int ligne = index ~/ widget.taille;
                int colonne = index % widget.taille;
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
                        color: caseToColor(caseActuelle),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        caseActuelle.decouverte ? caseToText(caseActuelle) : '',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultatsPage(
                          temps: _result,
                          userName: widget._userName,
                          difficulte: widget._difficulte,
                        ),
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

  String caseToText(modele.Case laCase) {
    if (laCase.minee) {
      return '💣';
    } else if (laCase.marquee) {
      return 'M';
    } else if (laCase.decouverte) {
      return laCase.nbMinesAutour == 0 ? '' : laCase.nbMinesAutour.toString();
    } else {
      return '';
    }
  }

  caseToColor(modele.Case laCase) {
    if (laCase.marquee) {
      return Colors.red;
    } else if (laCase.decouverte) {
      return Colors.white;
    } else {
      return const Color(0x816269FF);
    }
  }

  void resetGame() {
    setState(() {
      _grille = modele.Grille(widget.taille, widget.nbMines);
    });
  }
}
