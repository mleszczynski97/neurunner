import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:neurunner/game/game.dart';

import 'game/overlays/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

final _game = NeurunnerGame();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neurunner',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget<NeurunnerGame>(
          game: kDebugMode ? NeurunnerGame() : _game,
          overlayBuilderMap: {
            MainMenu.id: (context, game) => MainMenu(gameRef: game),
            // PauseMenu.id: (context, game) => PauseMenu(gameRef: game),
            // GameOver.id: (context, game) => GameOver(gameRef: game),
            // Settings.id: (context, game) => Settings(gameRef: game),
          },
          initialActiveOverlays: const [MainMenu.id],
        ),
      ),
    );
  }
}
