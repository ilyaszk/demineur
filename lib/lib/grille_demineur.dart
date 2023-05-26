import 'package:flutter/material.dart';
import 'package:demineur/lib/modele.dart' as modele;

class GrilleDemineur extends StatefulWidget {
  final int taille;
  final int nbMines;

  GrilleDemineur(this.taille, this.nbMines);

  @override
  State<StatefulWidget> createState() => _GrilleDemineur();
}

class _GrilleDemineur extends State<GrilleDemineur> {
  late modele.Grille _grille;
  bool gameOver = false;

  @override
  void initState() {
    _grille = modele.Grille(widget.taille, widget.nbMines);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7, // Adjust the height as per your requirement
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: widget.taille * widget.taille,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.taille,
            ),
            itemBuilder: (BuildContext context, int index) {
              int ligne = index ~/ widget.taille;
              int colonne = index % widget.taille;
              modele.Coordonnees coord = modele.Coordonnees(ligne, colonne);
              modele.Case caseActuelle = _grille.getCase(coord);

              if (gameOver) {
                caseActuelle.decouverte = true; // Reveal all cases
              }

              return Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (!gameOver) {
                        modele.Coup coup =
                        modele.Coup(ligne, colonne, modele.Action.decouvrir);
                        _grille.mettreAJour(coup);
                        resultAction();
                      }
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      if (!gameOver) {
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
        Container(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {
              resetGame();
            },
            child: Text('Restart'),
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


  void win(BuildContext context) {
    if (_grille.isGagnee()) {
      gameOver = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('You won!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void lost(BuildContext context) {
    if (_grille.isPerdue()) {
      gameOver = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('You lost!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void resultAction() {
    win(context);
    lost(context);
    setState(() {}); // Trigger a rebuild of the grid
  }

  String caseToText(modele.Case laCase) {
    if (laCase.minee) {
      return 'B';
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
      gameOver = false;
    });
  }
}
