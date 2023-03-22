import 'package:flutter/material.dart';
import 'package:neurunner/game/screens/main_menu.dart';
import '../game.dart';
import '../managers/audio_manager.dart';

class HighscoresMenu extends StatelessWidget {
  static const id = 'HighscoresMenu';
  final NeurunnerGame gameRef;

  const HighscoresMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 80, 79, 77),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "HIGHSCORES",
                  style: TextStyle(
                    //color: Color.fromARGB(255, 169, 94, 238),
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ),
              // Add the highscores board here
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOP 10 RECORDS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),

                    // Add the highscores rows here
                    for (int i = 1; i <= 10; i++)
                      Text(
                        i == 10
                            ? '$i.   Player$i  |   Score: ${5000 ~/ i}'
                            : '0$i.   Player0$i  |   Score: ${5000 ~/ i}',
                        style: const TextStyle(fontSize: 15),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      AudioManager.playSfx('Click_12.wav');
                      gameRef.overlays.remove(id);
                      gameRef.overlays.add(MainMenu.id);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('BACK'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
