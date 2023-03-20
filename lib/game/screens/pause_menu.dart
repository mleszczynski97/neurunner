import 'package:flutter/material.dart';
import 'package:neurunner/game/screens/main_menu.dart';
import '../game.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseMenu';
  final NeurunnerGame gameRef;

  const PauseMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      body: Center(
        child: Container(
          height: 160,
          width: 280,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color.fromARGB(255, 80, 79, 77),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2.0,
              blurRadius: 2.0,
              offset: Offset(4, 4),
            )
          ],
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.overlays.remove(id);
                    gameRef.resumeEngine();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Change the button color
                    foregroundColor: Colors.black, // Change the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('RESUME'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.overlays.remove(id);
                    gameRef.removeAll(gameRef.children);
                    gameRef.overlays.add(MainMenu.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Change the button color
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('EXIT'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
