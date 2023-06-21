import 'package:demineur/lib/demineur_screen.dart';
import 'package:flutter/material.dart';

import 'modele.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
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
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un nom.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<Difficulte>(
                        value: _selectedDifficulty,
                        onChanged: (Difficulte? newValue) {
                          setState(() {
                            _selectedDifficulty = newValue!;
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
                            // widget.startDemineur(_selectedDifficulty, _name!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DemineurScreen(_name!, _selectedDifficulty),
                              ),
                            );
                          }
                        },
                        child: const Text('Commencer'),
                      ),
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

  String? _name;

  Difficulte _selectedDifficulty = Difficulte.facile;
}
