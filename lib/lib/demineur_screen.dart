import 'dart:async';

import 'package:flutter/material.dart';
import 'package:demineur/lib/modele.dart' as modele;

class DemineurScreen extends StatefulWidget {
  final int taille;
  final int nbMines;

  // final Duration timer;
  final Function onRestart;

  DemineurScreen(this.taille, this.nbMines, this.onRestart);

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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '💣: ${widget.nbMines}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Text(
                '🕰️: $_result',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height *
              0.6, // Adjust the height as per your requirement
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                      style: TextStyle(
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
        //rajouter un container qui va afficher le resultat de la partie
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(
            _grille.isGagnee()
                ? 'You won! ✌️'
                : _grille.isPerdue()
                    ? 'You lost! 💣'
                    : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.onRestart();
              });
            },
            child: Text('Retour'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0x988E7DFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(200, 100),
              textStyle: const TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        )
      ],
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
      return Color(0x816269FF);
    }
  }

  void resetGame() {
    setState(() {
      _grille = modele.Grille(widget.taille, widget.nbMines);
    });
  }
}
