import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/player_provider.dart';
import '../providers/scoreboard_provider.dart';
import 'demineur_screen.dart';
import 'modele.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StartScreenState();
  }
}

class _StartScreenState extends ConsumerState<StartScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/logo-app.png',
                  width: 300,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Demineur',
                  style: TextStyle(
                    color: Color.fromARGB(255, 100, 52, 63),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Consumer(
                        builder: (context, watch, _) {
                          final player = ref.watch(playerProvider);
                          return TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              border: UnderlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir un nom.';
                              }
                              ref
                                  .read(playerProvider.notifier)
                                  .changeName(value);
                            },
                            onSaved: (value) {
                              player.changeName(value!);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<Difficulte>(
                        value: ref.read(playerProvider.notifier).difficulte,
                        onChanged: (Difficulte? newValue) {
                          setState(() {
                            ref
                                .read(playerProvider.notifier)
                                .changeDifficulte(newValue!);
                          });
                        },
                        items: Difficulte.values.map((Difficulte difficulty) {
                          return DropdownMenuItem<Difficulte>(
                            value: difficulty,
                            child: Text(
                              difficulty.name.toUpperCase(),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DemineurScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text('Commencer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Scoreboard',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Table(
                                        border: TableBorder.all(),
                                        children: [
                                          const TableRow(children: [
                                            TableCell(
                                              child: Text(
                                                'Nom',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                'Difficulté',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                'Temps',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ]),
                                          ...ref
                                              .read(scoreBoardProvider)
                                              .players
                                              .map((e) => TableRow(children: [
                                            TableCell(
                                              child: Text(
                                                e.name,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                e.difficulte.name,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                e.temps,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ]))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Fermer'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Scoreboard'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
