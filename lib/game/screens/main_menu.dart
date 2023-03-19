import 'package:flutter/material.dart';
import '../game.dart';
import '../gameplay.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';
  final NeurunnerGame gameRef;

  const MainMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 79, 77),
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
                  gameRef.add(GamePlay());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Change the button color
                  foregroundColor: Colors.black, // Change the text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('PLAY'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(id);
                  gameRef.add(GamePlay());
                  // gameRef.overlays.add(Settings.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Change the button color
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('HIGHSCORES'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(id);
                  gameRef.add(GamePlay());
                  // gameRef.overlays.add(Settings.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Change the button color
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('SETTINGS'),
              ),
            )
          ],
        ),
      ),
    );
  }
}