import 'dart:io';
import '../lib/console_ui.dart' as ui;
import '../lib/modele.dart' as modele;

void main(List<String> arguments) async {
  // Saisie des paramètres : taille et nombre de mines (15 sec. max pour choisir)
  var params= await ui.saisirParametresTimeout(delai: 15);
  // Initialisation de la grille
  var grille = modele.Grille(params['taille']!, params['nbMines']!);
  // Pour tester/déboguer : on affiche tout de suite la solution
  ui.afficher(grille, montrerSolution: true); // à commenter pour jouer vraiment
  // Déroulement d'une partie
  do {
    ui.afficher(grille);
    modele.Coup coup = await ui.saisirCoup(grille.taille);
    grille.mettreAJour(coup);
    ui.afficherResultat(grille);
  } while (!grille.isFinie());
  // A la fin on affiche la solution
  ui.afficher(grille, montrerSolution: true);
  exit(0);
}
