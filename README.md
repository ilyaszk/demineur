# Demineur

Le jeu Demineur est une version simplifiée du jeu classique du démineur. 
Le joueur doit explorer une grille de cases, certaines contenant des mines. 
L'objectif est d'éviter de cliquer sur une case contenant une mine et de marquer toutes les cases qui en contiennent.

## Fonctionnalités

- Choix de la difficulté : Le joueur peut choisir entre trois niveaux de difficulté - Facile, Moyen et Difficile. Chaque niveau de difficulté définit la taille de la grille et le nombre de mines.
- Chronomètre : Le jeu affiche un chronomètre qui indique le temps écoulé depuis le début de la partie.
- Marquage des mines : Le joueur peut marquer les cases suspectées de contenir une mine en effectuant un appui long sur la case.
- Affichage des résultats : Une fois la partie terminée, le joueur voit s'afficher un message indiquant s'il a gagné ou perdu, ainsi que le temps écoulé pendant la partie.
- Scoreboard : Le jeu propose également un scoreboard qui enregistre les meilleurs temps de jeu pour chaque niveau de difficulté.

## Composants

Le jeu est construit à l'aide du framework Flutter et utilise le gestionnaire d'état Flutter Riverpod. Voici une description des principaux fichiers du projet :

- `demineur_screen.dart` : Ce fichier contient la classe `DemineurScreen`, qui est l'écran principal du jeu. Il gère l'état du jeu, la logique du chronomètre, la construction de la grille de cases et la gestion des interactions avec les cases.
- `modele.dart` : Ce fichier définit les modèles de données utilisés dans le jeu, tels que la classe `Grille` qui représente la grille de cases, la classe `Case` qui représente une case individuelle, et la classe `Coup` qui représente un coup joué par le joueur.
- `resultats_screen.dart` : Ce fichier contient la classe `ResultatsPage`, qui affiche les résultats d'une partie une fois qu'elle est terminée. Il affiche le temps écoulé, la difficulté choisie et le nom du joueur.
- `start_screen.dart` : Ce fichier contient la classe `StartScreen`, qui est l'écran d'accueil du jeu. Il permet au joueur de saisir son nom, de choisir la difficulté et de commencer une partie.

## Auteur
Le jeu a été développé par Votre Ilyas Zahaf kradra.