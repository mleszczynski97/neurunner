import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:neurunner/game/game.dart';
import 'game/screens/highscores_menu.dart';
import 'game/screens/game_over.dart';
import 'game/screens/main_menu.dart';
import 'game/screens/pause_menu.dart';
import 'game/screens/settings_menu.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        textTheme: Typography.whiteHelsinki,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body: GameWidget<NeurunnerGame>(
          game: kDebugMode ? NeurunnerGame() : _game,
          overlayBuilderMap: {
            MainMenu.id: (context, game) => MainMenu(gameRef: game),
            PauseMenu.id: (context, game) => PauseMenu(gameRef: game),
            GameOver.id: (context, game) => GameOver(gameRef: game),
            SettingsMenu.id: (context, game) => SettingsMenu(gameRef: game),
            HighscoresMenu.id: (context, game) => HighscoresMenu(gameRef: game),
          },
          initialActiveOverlays: const [MainMenu.id],
        ),
      ),
    );
  }
}
