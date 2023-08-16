import 'package:flutter/material.dart';
import 'package:neurunner/game/gameplay.dart';
import 'package:neurunner/game/screens/main_menu.dart';
import '../game.dart';
import '../managers/audio_manager.dart';

class GameOver extends StatelessWidget {
  static const id = 'GameOver';
  final NeurunnerGame gameRef;

  const GameOver({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
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
              gameRef.playerData.distance.value >= 4000
                  ? const Text('YOU WON!',
                      style: TextStyle(
                        fontSize: 64,
                      ))
                  : const Text('GAME OVER',
                      style: TextStyle(
                        fontSize: 64,
                      )),
              Text('Final distance: ${gameRef.playerData.distance.value}m',
                  style: const TextStyle(
                    fontSize: 20,
                  )),
              Text('Coins collected: ${gameRef.playerData.coins.value}',
                  style: const TextStyle(
                    fontSize: 20,
                  )),
              Text(
                  'Total score: ${gameRef.playerData.distance.value + gameRef.playerData.coins.value * 10}',
                  style: const TextStyle(
                    fontSize: 32,
                  )),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    AudioManager.playSfx('Click_12.wav');
                    gameRef.overlays.remove(id);
                    gameRef.resumeEngine();
                    gameRef.removeAll(gameRef.children);
                    gameRef.add(GamePlay());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('RESTART'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    AudioManager.playSfx('Click_12.wav');
                    gameRef.overlays.remove(id);
                    gameRef.removeAll(gameRef.children);
                    gameRef.overlays.add(MainMenu.id);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('EXIT TO MENU'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
