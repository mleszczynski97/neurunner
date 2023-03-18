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
      backgroundColor: Colors.grey.withOpacity(0.2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(id);
                  gameRef.resumeEngine();
                  // gameRef.add(GamePlay());
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
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(id);
                  gameRef.removeAll(gameRef.children);
                  gameRef.overlays.add(MainMenu.id);
                  // gameRef.overlays.add(Settings.id);
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
    );
  }
}
