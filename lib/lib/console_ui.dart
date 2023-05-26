import 'dart:io';
import 'dart:async';
import 'stdin_async.dart' as stdin_async;
import 'modele.dart' as modele;

// Tailles MIN et MAX de la grille
const TAILLE_MAX = 10;
const TAILLE_MIN = 2;
// Caractère affiché selon l'état de la case
const CASE_VIDE = ' ';
const CASE_MINEE = 'B';
const CASE_MARQUEE = 'M';
const CASE_COUVERTE = '*';

// Saisie des paramètres avec un timeout de delai secondes
// Si paramètres non saisis, return {TAILLE_MAX,TAILLE_MAX}
Future<Map<String, int>> saisirParametresTimeout({int delai = 30}) async {
  stdout.write("Vous avez $delai secondes pour répondre...\n");
  return await saisirParametres().timeout(Duration(seconds: delai),
      onTimeout: () {
        stdout.write("\nPar défaut Taille=${TAILLE_MAX}, Nombre de Mines=${TAILLE_MAX}\n");
        return {'taille': TAILLE_MAX, 'nbMines': TAILLE_MAX};
  });
}

// Saisie sur stdin de la taille et du nombre de mines
Future<Map<String, int>> saisirParametres() async {
  // saisir la taille et le nombre de mines
  int taille;
  do {
    stdout.write("Taille de la grille [$TAILLE_MIN..$TAILLE_MAX] : ");
    try {
      taille = int.parse(await stdin_async.readLine());
    } catch (e) {
      taille = 0;
    }
  } while (taille < TAILLE_MIN || taille > TAILLE_MAX);

  int nbMines;
  do {
    stdout.write("Nombre de mines     [1..${taille * taille - 1}] : ");
    try {
      nbMines = int.parse(await stdin_async.readLine());
    } catch (e) {
      nbMines = 0;
    }
  } while (nbMines < 1 || nbMines > taille * taille - 1);
  return {'taille': taille, 'nbMines': nbMines};
}

// Saisie sur stdin du coup d'un joueur :
// - deux entiers ligne,colonne compris entre 0 et taille-1
// - un caractère pour l'action : d (découvrir) ou m (marquer)
Future<modele.Coup> saisirCoup(int taille) async {
  int ligne, colonne;
  String action;
  stdout.write("\n");
  do {
    stdout.write("Quelle ligne jouez-vous   [0..${taille - 1}] : ");
    try {
      ligne = int.parse(await stdin_async.readLine());
    } catch (e) {
      ligne = -1;
    }
  } while (ligne < 0 || ligne >= taille);
  do {
    stdout.write("Quelle colonne jouez-vous [0..${taille - 1}] : ");
    try {
      colonne = int.parse(await stdin_async.readLine());
    } catch (e) {
      colonne = -1;
    }
  } while (colonne < 0 || colonne >= taille);
  do {
    stdout.write("Quelle action jouez-vous  [d|m]  : ");
    action = (await stdin_async.readLine()).toLowerCase();
  } while (action != 'd' && action != 'm');
  return modele.Coup(
      ligne,
      colonne,
      (action == 'd' || action == 'D')
          ? modele.Action.decouvrir
          : modele.Action.marquer);
}

// Affiche sur stdout la grille (en montrant la solution ou pas)
void afficher(modele.Grille grille, {bool montrerSolution = false}) {
  stdout.write("\n");
  afficherNumeroColonnes(grille.taille);
  afficheLigneSeparatrice(grille.taille);
  for (int ligne = 0; ligne < grille.taille; ligne++) {
    stdout.write("$ligne ");
    for (int colonne = 0; colonne < grille.taille; colonne++) {
      stdout.write('|');
      // On récupère la case en coordonnée {ligne,colonne} et on l'affiche
      modele.Case laCase = grille.getCase(modele.Coordonnees(ligne, colonne));
      if (montrerSolution) {
        afficherSolution(laCase);
      } else {
        afficherJeu(laCase);
      }
    }
    stdout.write('|\n');
    afficheLigneSeparatrice(grille.taille);
  }
}

// Affiche le résultat selon l'état de la grille après un coup joué
void afficherResultat(modele.Grille grille) {
  if (grille.isPerdue()) {
    stdout.write("\nBOUM ! VOUS AVEZ PERDU !\n");
  } else {
    if (grille.isGagnee()) {
      stdout.write("\nBRAVO ! VOUS AVEZ GAGNE !\n");
    } else {
      stdout.write("\nIl faut continuer à déminer...\n");
    }
  }
}

// Affiche sur stdout les numéros de colonne en haut de la grille
void afficherNumeroColonnes(int taille) {
  // afficher les numéros de colonne
  stdout.write("  ");
  for (int colonne = 0; colonne < taille; colonne++) {
    stdout.write(' $colonne');
  }
  stdout.write("\n");
}

// Affiche sur stdout une ligne séparatrice entre deux lignes de la grille
void afficheLigneSeparatrice(int taille) {
// afficher ligne séparatrice horizontale
  stdout.write("  ");
  for (int colonne = 0; colonne < taille; colonne++) {
    stdout.write("+-");
  }
  stdout.write("+\n");
}

// Affiche sur stdout une case en mode "jeu" (cache le contenu si non découverte)
void afficherJeu(modele.Case laCase) {
  // Afficher le contenu d'une case en mode "jeu"
  if (!laCase.decouverte) {
    if (laCase.marquee) {
      stdout.write(CASE_MARQUEE);
    } else {
      stdout.write(CASE_COUVERTE);
    }
  } else {
    if (laCase.nbMinesAutour > 0) {
      stdout.write(laCase.nbMinesAutour);
    } else {
      stdout.write(CASE_VIDE);
    }
  }
}

// Affiche sur stdout une case en mode "solution" (montre les bombes)
void afficherSolution(modele.Case laCase) {
  // Afficher le contenu d'une case en mode "solution"
  if (laCase.minee) {
    stdout.write(CASE_MINEE);
  } else if (laCase.nbMinesAutour > 0) {
    stdout.write(laCase.nbMinesAutour);
  } else {
    stdout.write(CASE_VIDE);
  }
}
