import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/screens/game_over.dart';
import 'package:neurunner/game/screens/pause_menu.dart';

class Hud extends PositionComponent with HasGameRef<NeurunnerGame> {
  late final TextComponent pointsTextComponent;
  late final TextComponent healthTextComponent;

  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  FutureOr<void> onLoad() async {
    final scoreTextComponent = TextComponent(
      text: 'SCORE',
      position: Vector2(320, 0),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.6),
    );
    add(scoreTextComponent);

    pointsTextComponent = TextComponent(
      text: '0',
      position: Vector2(320, 15),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.5),
    );
    add(pointsTextComponent);

    final pauseButtonComponent = SpriteButtonComponent(
      onPressed: () {
        gameRef.pauseEngine();
        gameRef.overlays.add(PauseMenu.id);
      },
      button: Sprite(game.images.fromCache('hud/pause.png')),
      position: Vector2(638, 2),
      anchor: Anchor.topRight,
      size: Vector2.all(32),
    )..positionType = PositionType.viewport;
    add(pauseButtonComponent);

    final heartComponent = SpriteComponent.fromImage(
      game.images.fromCache('hud/heart.png'),
      position: Vector2(0, 0),
      anchor: Anchor.topLeft,
      size: Vector2.all(60),
    );
    add(heartComponent);

    healthTextComponent = TextComponent(
      text: '100',
      position: Vector2(30, 20),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.5),
    );
    add(healthTextComponent);

    final jumpButtonComponent = SpriteButtonComponent(
      onPressed: () {
        gameRef.player.jump();
        //print('pressed');
      },
      button: Sprite(game.images.fromCache('hud/jump.png')),
      position: Vector2(10, 256),
      anchor: Anchor.bottomLeft,
      size: Vector2(320, 200),
    )..positionType = PositionType.viewport;
    add(jumpButtonComponent);

    final attackButtonComponent = SpriteButtonComponent(
      onPressed: () {
        //print('attack!');
      },
      button: Sprite(game.images.fromCache('hud/attack.png')),
      position: Vector2(630, 256),
      anchor: Anchor.bottomRight,
      size: Vector2(320, 200),
    )..positionType = PositionType.viewport;
    add(attackButtonComponent);

    // Listeners for player data
    gameRef.playerData.points.addListener(onPointsChange);
    gameRef.playerData.hp.addListener(onHpChange);

    return super.onLoad();
  }

  @override
  void onRemove() {
    gameRef.playerData.points.removeListener(onPointsChange);
    gameRef.playerData.hp.removeListener(onHpChange);
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void onPointsChange() {
    pointsTextComponent.text = '${gameRef.playerData.points.value}';
  }

  void onHpChange() {
    healthTextComponent.text = '${gameRef.playerData.hp.value}';

    if (gameRef.playerData.hp.value == 0) {
      gameRef.pauseEngine();
      gameRef.overlays.add(GameOver.id);
    }
  }
}
