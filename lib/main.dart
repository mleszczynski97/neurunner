import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:neurunner/game/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const GameWidget<NeurunnerGame>.controlled(
      gameFactory: NeurunnerGame.new,
    ),
  );
}
