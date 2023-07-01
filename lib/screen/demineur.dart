import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modele.dart';
import 'start_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    background: const Color.fromARGB(255, 203, 151, 151),
    seedColor: const Color.fromARGB(255, 100, 52, 63),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

class Demineur extends StatefulWidget {
  const Demineur({Key? key}) : super(key: key);

  @override
  State<Demineur> createState() {
    return _DemineurState();
  }
}

enum ScreenState { start, demineur }

class _DemineurState extends State<Demineur> {
  ScreenState screenState = ScreenState.start;
  late Difficulte difficulte = Difficulte.facile;
  late String _userName = "";

  void startDemineur(Difficulte? diff, String? name) {
    setState(() {
      screenState = ScreenState.demineur;
      if (diff != null) {
        difficulte = diff;
      }
      if (name != null) {
        _userName = name;
      }
    });
  }

  void reStartDemineur() {
    setState(() {
      screenState = ScreenState.start;
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: const StartScreen());
  }
}
