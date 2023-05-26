import 'package:flutter/material.dart';
import 'package:demineur/lib/modele.dart' as modele;

class DemineurScreen extends StatefulWidget {
  final int taille;
  final int nbMines;
  final Function onRestart;

  DemineurScreen(this.taille, this.nbMines, this.onRestart);

  @override
  State<StatefulWidget> createState() => _DemineurScreen();
}

class _DemineurScreen extends State<DemineurScreen> {
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
            padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
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
                      }else{
                        null;
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
        //rajouter un container qui va afficher le resultat de la partie
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(
            _grille.isGagnee() ? 'You won! ✌️' : _grille.isPerdue() ? 'You lost! 💣' : '',
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
                gameOver = false;
              });
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
