import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:neurunner/neurunner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(
    const GameWidget<NeurunnerGame>.controlled(
      gameFactory: NeurunnerGame.new,
    ),
  );
}
