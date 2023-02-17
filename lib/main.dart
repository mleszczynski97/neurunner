import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:neurunner/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(
    const GameWidget<NeurunnerGame>.controlled(
      gameFactory: NeurunnerGame.new,
    ),
  );
}
